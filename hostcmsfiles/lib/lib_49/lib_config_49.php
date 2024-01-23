<?php

if (Core::moduleIsActive('deal') && Core::moduleIsActive('siteuser'))
{
	$oSiteuser = Core_Entity::factory('Siteuser')->getCurrent();

	// Если пользователь не авторизован
	if (is_null($oSiteuser))
	{
		// Редирект на авторизацию
		header('Location: /users/');
		exit();
	}

	$Deal_Controller_Show = new Deal_Controller_Show(
		Core_Entity::factory('Site', CURRENT_SITE)
	);

	$Deal_Controller_Show
		->limit(10)
		->parseUrl();

	Core_Page::instance()->object = $Deal_Controller_Show;
}