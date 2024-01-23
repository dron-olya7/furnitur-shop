<?php

$Shop_Favorite_Controller_Show = Core_Page::instance()->object;

$oShop = $Shop_Favorite_Controller_Show->getEntity();

$Shop_Favorite_Controller_Show = new Shop_Favorite_Controller_Show(
	Core_Entity::factory('Shop', 1)
);

$xslName = Core_Array::get(Core_Page::instance()->libParams, 'favoriteXsl');

$Shop_Favorite_Controller_Show
	->xsl(
		Core_Entity::factory('Xsl')->getByName($xslName)
	)
	->itemsPropertiesList(FALSE)
	->show();