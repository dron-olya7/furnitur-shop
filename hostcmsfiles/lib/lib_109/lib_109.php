<?php
if (Core::moduleIsActive('shop'))
{
	$xsl = Core_Array::get(Core_Page::instance()->widgetParams, 'xsl');

	// Категории
	$Shop_Controller_Show = new Shop_Controller_Show(
		Core_Entity::factory('Shop', Core_Page::instance()->widgetParams['shopId'])
	);

	if (is_object(Core_Page::instance()->object)
	&& get_class(Core_Page::instance()->object) == 'Shop_Controller_Show')
	{
		$Shop_Controller_Show->addEntity(
			Core::factory('Core_Xml_Entity')
			->name('current_group_id')
			->value(intval(Core_Page::instance()->object->group))
		);
	}

	$Shop_Controller_Show
		->xsl(
			Core_Entity::factory('Xsl')->getByName($xsl)
		)
		->groupsMode('all')
		->viewed(FALSE)
		->itemsPropertiesList(FALSE)
		->calculateTotal(FALSE)
		->limit(0)
		->show();
}