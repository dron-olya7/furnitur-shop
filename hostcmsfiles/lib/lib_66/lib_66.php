<?php

if (Core::moduleIsActive('form'))
{
	$oForm = Core_Entity::factory('Form', Core_Array::get(Core_Page::instance()->libParams, 'formId'));

	$Form_Controller_Show = new Form_Controller_Show($oForm);

	$xslName = Core_Array::get(Core_Page::instance()->libParams, 'formXsl');

	if (!is_null(Core_Array::getPost($oForm->button_name)))
	{
		$Form_Controller_Show
			->values($_POST + $_FILES)
			// 0 - html, 1- plain text
			->mailType(Core_Array::get(Core_Page::instance()->libParams, 'mailType'))
			->mailXsl(
				Core_Entity::factory('Xsl')->getByName(Core_Array::get(Core_Page::instance()->libParams, 'notificationMailXsl'))
			)
			->mailFromFieldName(Core_Array::get(Core_Page::instance()->libParams, 'emailFieldName'))
			->process();
	}

	$Form_Controller_Show
		->xsl(
			Core_Entity::factory('Xsl')->getByName($xslName)
		)
		->show();
}
else
{
	?>
	<h2 class="mt-4">Формы</h2>
	<div class="alert alert-danger" role="alert">
		<p>Функционал недоступен, приобретите более старшую редакцию.</p>
		<p>Модуль &laquo;<a href="https://www.hostcms.ru/hostcms/modules/forms/">Формы</a>&raquo; доступен в редакциях &laquo;<a href="https://www.hostcms.ru/hostcms/editions/corporation/">Корпорация</a>&raquo;, &laquo;<a href="https://www.hostcms.ru/hostcms/editions/business/">Бизнес</a>&raquo; и &laquo;<a href="https://www.hostcms.ru/hostcms/editions/small-business/">Малый бизнес</a>&raquo;.</p>
	</div>
	<?php
}