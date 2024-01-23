<?php
if (!Core::moduleIsActive('maillist'))
{
	?>
	<h1>Почтовые рассылки</h1>
	<p>Функционал недоступен, приобретите более старшую редакцию.</p>
	<p>Модуль &laquo;<a href="http://www.hostcms.ru/hostcms/modules/maillists/">Почтовые рассылки</a>&raquo; доступен в редакции &laquo;<a href="http://www.hostcms.ru/hostcms/editions/corporation/">Корпорация</a>&raquo;.</p>
	<?php
	return ;
}

$Maillist_Unsubscribe_Reason_Controller_Show = Core_Page::instance()->object;

if ($Maillist_Unsubscribe_Reason_Controller_Show)
{
	$xslName = Core_Array::get(Core_Page::instance()->libParams, 'xsl');

	if (!is_null(Core_Array::getPost('unsubscribe')))
	{
		$Maillist_Unsubscribe_Reason_Controller_Show->unsubscribe();
	}

	$Maillist_Unsubscribe_Reason_Controller_Show
		->xsl(Core_Entity::factory('Xsl')->getByName($xslName))
		->show();
}