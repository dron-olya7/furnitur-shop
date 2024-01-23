<?php

$oShop = Core_Entity::factory('Shop', Core_Array::get(Core_Page::instance()->libParams, 'shopId'));

Core_Page::instance()->response
	->header('Pragma', "no-cache")
	->header('Cache-Control', "private, no-cache");

if (Core_Array::getRequest('favorite'))
{
	// Запрещаем индексацию страницы избранного
	Core_Page::instance()->response
		->header('X-Robots-Tag', 'none');

	$favorite = Core_Array::getRequest('favorite');
	!is_array($favorite) && $favorite = array($favorite);

	$oShop_Favorite_Controller = Shop_Favorite_Controller::instance();

	foreach ($favorite as $shop_item_id)
	{
		$oShop_Favorite_Controller
			->clear()
			->shop_item_id(intval($shop_item_id))
			->add();
	}
}

// Ajax
if (Core_Array::getRequest('_', FALSE)
	&& (Core_Array::getRequest('favorite') || Core_Array::getRequest('loadFavorite')))
{
	ob_start();

	// Краткое избранное
	$Shop_Favorite_Controller_Show = new Shop_Favorite_Controller_Show(
		$oShop
	);
	$Shop_Favorite_Controller_Show
		->xsl(
			Core_Entity::factory('Xsl')->getByName(
				Core_Array::get(Core_Page::instance()->libParams, 'littleFavoriteXsl')
			)
		)
		->show();

	echo json_encode(ob_get_clean());
	exit();
}

$Shop_Favorite_Controller_Show = new Shop_Favorite_Controller_Show($oShop);

Core_Page::instance()->object = $Shop_Favorite_Controller_Show;