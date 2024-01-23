<?php
// Второе верхнее меню
$Structure_Controller_Show = new Structure_Controller_Show(
	Core_Entity::factory('Site', CURRENT_SITE));

$Structure_Controller_Show
	->xsl(Core_Entity::factory('Xsl')->getByName('ШапкаНизМенюСайт2'))
	->menu(4)
	->showShopGroups(TRUE)
	->level(3)
	->show();