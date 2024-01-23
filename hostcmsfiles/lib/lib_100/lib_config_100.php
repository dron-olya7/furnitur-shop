<?php

$oShop = Core_Entity::factory('Shop', Core_Array::get(Core_Page::instance()->libParams, 'shopId'));

$siteuser_id = 0;

if (Core::moduleIsActive('siteuser'))
{
	$oSiteuser = Core_Entity::factory('Siteuser')->getCurrent();
	$oSiteuser && $siteuser_id = $oSiteuser->id;
}

$shop_favorite_list_id = Core_Array::getRequest('shop_favorite_list_id', 0, 'int');
$bRemoveFavorite = Core_Array::getRequest('removeFavorite', 0, 'int');
$bEmptyList = Core_Array::getRequest('emptyList', 0, 'int');

if ($shop_favorite_list_id || $bRemoveFavorite || $bEmptyList)
{
	$siteuser_id = 0;
}

if (Core_Array::getRequest('shop_item_id') && !$siteuser_id)
{
	// Запрещаем индексацию страницы избранного
	Core_Page::instance()->response
		->header('X-Robots-Tag', 'none');

	$ids = Core_Array::getRequest('shop_item_id');
	!is_array($ids) && $ids = array($ids);

	$oShop_Favorite_Controller = Shop_Favorite_Controller::instance();

	foreach ($ids as $key => $shop_item_id)
	{
		$oShop_Favorite_Controller
			->clear()
			->shop_item_id(intval($shop_item_id))
			->shop_favorite_list_id(intval($shop_favorite_list_id))
			->add();
	}
}

if (!is_null(Core_Array::getPost('add_favorite_list')))
{
	$aJson = array(
		'status' => 'error',
		'id' => 0,
		'name' => '',
		'shop_id' => 0,
		'siteuser_id' => 0
	);

	$name = Core_Array::getPost('name', '', 'strval');
	$shop_id = Core_Array::getPost('shop_id', '', 'int');
	$siteuser_id = Core_Array::getPost('siteuser_id', '', 'int');

	if ($shop_id && $siteuser_id && strlen($name))
	{
		$oShop_Favorite_List = Core_Entity::factory('Shop_Favorite_List');
		$oShop_Favorite_List->shop_id = $shop_id;
		$oShop_Favorite_List->siteuser_id = $siteuser_id;
		$oShop_Favorite_List->name = $name;
		$oShop_Favorite_List->save();

		$aJson = array(
			'status' => 'success',
			'id' => $oShop_Favorite_List->id,
			'name' => $name,
			'shop_id' => $shop_id,
			'siteuser_id' => $siteuser_id
		);
	}

	Core::showJson($aJson);
}

if (!is_null(Core_Array::getRequest('loadFavoriteList')))
{
	$shop_item_id = Core_Array::getRequest('shop_item_id', 0, 'int');

	$oShop_Item = Core_Entity::factory('Shop_Item')->getById($shop_item_id);

	// Генерация окна с заказом в 1 клик
	if ( !is_null($oShop_Item)
		&& (!is_null(Core_Array::getRequest('showDialog')) || !is_null(Core_Array::getRequest('removeFavorite')))
		&& Core_Array::getRequest('_', FALSE)
	)
	{
		$xslName = $siteuser_id
			? Core_Array::get(Core_Page::instance()->libParams, 'loadFavoriteListXsl')
			: Core_Array::get(Core_Page::instance()->libParams, 'littleFavoriteXsl');

		ob_start();

		$Shop_Favorite_Controller_Show = new Shop_Favorite_Controller_Show(
			$oShop
		);

		$Shop_Favorite_Controller_Show->addEntity($oShop_Item);

		$Shop_Favorite_Controller_Show
			->xsl(
				Core_Entity::factory('Xsl')->getByName($xslName)
			)
			->itemsPropertiesList(FALSE)
			->show();

		Core::showJson(
			array(
				'html' => ob_get_clean(),
				'shop_item_id' => $oShop_Item->id,
				'siteuser_id' => $siteuser_id
			)
		);
	}
}

$Shop_Favorite_Controller_Show = new Shop_Favorite_Controller_Show($oShop);

Core_Page::instance()->object = $Shop_Favorite_Controller_Show;