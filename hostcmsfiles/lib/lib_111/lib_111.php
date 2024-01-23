<?php
if (Core::moduleIsActive('shop'))
{
	$xsl = Core_Array::get(Core_Page::instance()->widgetParams, 'xsl');

	$Shop_Controller_Tag_Show = new Shop_Controller_Tag_Show(
 		Core_Entity::factory('Shop', 1)
 	);

 	$Shop_Controller_Tag_Show
 		->xsl(
 			Core_Entity::factory('Xsl')->getByName($xsl)
 		)
 		->limit(30)
 		->show();
}