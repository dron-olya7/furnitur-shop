<?php
if (!Core::moduleIsActive('siteuser'))
{
	?>
	<h1>Клиенты</h1>
	<p>Функционал недоступен, приобретите более старшую редакцию.</p>
	<p>Модуль &laquo;<a href="https://www.hostcms.ru/hostcms/modules/siteusers/">Клиенты</a>&raquo; доступен в редакциях &laquo;<a href="https://www.hostcms.ru/hostcms/editions/corporation/">Корпорация</a>&raquo; и &laquo;<a href="https://www.hostcms.ru/hostcms/editions/business/">Бизнес</a>&raquo;.</p>
	<?php
	return ;
}

$oSiteuser = Core_Entity::factory('Siteuser')->getCurrent();

if (is_null($oSiteuser))
{
	?><h1>Вы не авторизованы!</h1>
	<p>Для просмотра заказов необходимо авторизироваться.</p>
	<?php
	return ;
}

$xslDiscountcard = Core_Array::get(Core_Page::instance()->libParams, 'xsl');

$Shop_Discountcard_Controller_Show = new Shop_Discountcard_Controller_Show($oSiteuser);
$Shop_Discountcard_Controller_Show
	->xsl(
		Core_Entity::factory('Xsl')->getByName($xslDiscountcard)
	)
	->show();