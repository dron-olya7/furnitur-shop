<?php
$oInformationsystem = Core_Entity::factory('Informationsystem', Core_Array::get(Core_Page::instance()->widgetParams, 'informationsystemId'));
$newsXsl = Core_Array::get(Core_Page::instance()->widgetParams, 'newsXsl');

if (Core::moduleIsActive('informationsystem'))
{
	$Informationsystem_Controller_Show = new Informationsystem_Controller_Show(
		Core_Entity::factory('Informationsystem', $oInformationsystem->id)
	);

	$Informationsystem_Controller_Show
		->xsl(
			Core_Entity::factory('Xsl')->getByName($newsXsl)
		)
		->groupsMode('none')
		->limit(3)
		->itemsForbiddenTags(array('text'))
		->commentsRating(TRUE)
		->siteuser(FALSE)
		->show();
}