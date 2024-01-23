<?php
$oShop = Core_Entity::factory('Shop', Core_Array::get(Core_Page::instance()->widgetParams, 'shopId'));
$viewXsl = Core_Array::get(Core_Page::instance()->widgetParams, 'viewXsl');

if (Core::moduleIsActive('shop'))
{
	$Shop_Controller_Show = new Shop_Controller_Show(
		Core_Entity::factory('Shop', $oShop->id)
	);

	$Shop_Controller_Show
		->xsl(
			Core_Entity::factory('Xsl')->getByName($viewXsl)
		)
		->groupsMode('none')
		->group(FALSE)
		->viewed(TRUE)
		->commentsRating(TRUE)
		->itemsPropertiesList(FALSE)
		->itemsProperties(FALSE)
		->cache(FALSE)
		->limit(0)
		->itemsForbiddenTags(array('text', 'description'))
		->show();
}