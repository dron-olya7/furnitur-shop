<?php
$oShop = Core_Entity::factory('Shop', Core_Array::get(Core_Page::instance()->widgetParams, 'shopId'));
$brandsXsl = Core_Array::get(Core_Page::instance()->widgetParams, 'brandsXsl');
$limit = Core_Array::get(Core_Page::instance()->widgetParams, 'limit');

if (Core::moduleIsActive('shop'))
{
	$oShop_Producer_Controller_Show = new Shop_Producer_Controller_Show(
		Core_Entity::factory('Shop', $oShop->id)
	);

	$oShop_Producer_Controller_Show
		->xsl(
			Core_Entity::factory('Xsl')->getByName($brandsXsl)
		)
		->limit($limit)
		->show();
}