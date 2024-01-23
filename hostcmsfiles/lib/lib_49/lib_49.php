<?php

if (!Core::moduleIsActive('deal'))
{
	?><h1>Сделки</h1>
	<p>Функционал недоступен, приобретите более старшую редакцию.</p>
	<p>Модуль &laquo;<a href="https://www.hostcms.ru/hostcms/modules/siteusers/">Сделки</a>&raquo; доступен в редакции &laquo;<a href="https://www.hostcms.ru/hostcms/editions/corporation/">Корпорация</a>&raquo;.</p>
	<?php
	return;
}

if (!Core::moduleIsActive('siteuser'))
{
	?>
	<h1>Клиенты</h1>
	<p>Функционал недоступен, приобретите более старшую редакцию.</p>
	<p>Модуль &laquo;<a href="https://www.hostcms.ru/hostcms/modules/siteusers/">Клиенты</a>&raquo; доступен в редакциях &laquo;<a href="https://www.hostcms.ru/hostcms/editions/corporation/">Корпорация</a>&raquo; и &laquo;<a href="https://www.hostcms.ru/hostcms/editions/business/">Бизнес</a>&raquo;.</p>
	<?php
	return ;
}

$Deal_Controller_Show = Core_Page::instance()->object;

/* Добавление свойств */
function addPropertyValue($oDeal, $oProperty, $oProperty_Value, $value)
{
	switch ($oProperty->type)
	{
		case 0: // Int
		case 3: // List
		case 5: // Information system
			$oProperty_Value->value(intval($value));
			$oProperty_Value->save();
		break;
		case 1: // String
		case 4: // Textarea
		case 6: // Wysiwyg
			$oProperty_Value->value(Core_Str::stripTags(strval($value)));
			$oProperty_Value->save();
		break;
		case 8: // Date
			$date = strval($value);
			$date = Core_Date::date2sql($date);
			$oProperty_Value->value($date);
			$oProperty_Value->save();
		break;
		case 9: // Datetime
			$datetime = strval($value);
			$datetime = Core_Date::datetime2sql($datetime);
			$oProperty_Value->value($datetime);
			$oProperty_Value->save();
		break;
		case 7: // Checkbox
			$oProperty_Value->value(is_null($value) ? 0 : 1);
			$oProperty_Value->save();
		break;
	}
}

// Обновление данных или регистрация нового пользователя
if (!is_null(Core_Array::getPost('add')))
{
	$name = Core_Array::getPost('name', '', 'trim');
	$description = Core_Array::getPost('description', '', 'trim');
	$deal_template_id = Core_Array::getPost('deal_template_id', 0, 'int');

	if ($deal_template_id)
	{
		$oSite = Core_Entity::factory('Site', CURRENT_SITE);

		$oSiteuser = Core_Entity::factory('Siteuser')->getCurrent();
		$siteuser_id = !is_null($oSiteuser)
			? $oSiteuser->id
			: 0;

		$oCompany = $oSite->Companies->getFirst();
		$company_id = !is_null($oCompany)
			? $oCompany->id
			: 0;

		$oShop = $oSite->Shops->getFirst();
		$shop_id = !is_null($oShop)
			? $oShop->id
			: 0;

		$deal_template_step_id = 0;

		$oDeal_Template = Core_Entity::factory('Deal_Template')->getById($deal_template_id);

		if (!is_null($oDeal_Template))
		{
			$oDeal_Template_Step = $oDeal_Template->getStartingStep();

			if (!is_null($oDeal_Template_Step))
			{
				$deal_template_step_id = $oDeal_Template_Step->id;
			}
		}

		$oDeal = Core_Entity::factory('Deal');
		$oDeal->name = $name;
		$oDeal->description = $description;
		$oDeal->company_id = $company_id;
		$oDeal->creator_id = 0;
		$oDeal->user_id = 0;
		$oDeal->shop_currency_id = 0;
		$oDeal->shop_id = $shop_id;
		$oDeal->site_id = $oSite->id;
		$oDeal->siteuser_id = $siteuser_id;
		$oDeal->deal_template_id = $deal_template_id;
		$oDeal->deal_template_step_id = $deal_template_step_id;
		$oDeal->save();

		// Дополнительные свойства, новые значения
		$oDeal_Property_List = Core_Entity::factory('Deal_Template_Property_List', $deal_template_id);

		$aProperties = $oDeal_Property_List->Properties->findAll();
		foreach ($aProperties as $oProperty)
		{
			// Поле не скрытое
			if ($oProperty->type != 10)
			{
				$sFieldName = "property_{$oProperty->id}";

				$value = Core_Array::getPost($sFieldName);

				$oProperty_Value = $oProperty->createNewValue($oDeal->id);
				addPropertyValue($oDeal, $oProperty, $oProperty_Value, $value);
			}
		}
	}
}

$xslName = $Deal_Controller_Show->deal_template_id
	? Core_Array::get(Core_Page::instance()->libParams, 'addDealXsl')
	: Core_Array::get(Core_Page::instance()->libParams, 'dealXsl');

if ($Deal_Controller_Show->deal_template_id)
{
	$Deal_Controller_Show->showDeals(FALSE);
}

$Deal_Controller_Show
	->xsl(
		Core_Entity::factory('Xsl')->getByName($xslName)
	)
	->itemsProperties(TRUE)
	->dealTemplates(TRUE)
	->dealTemplateSteps(TRUE)
	->attachments(TRUE)
	->notes(TRUE)
	->shopItems(TRUE)
	->dealSiteusers(TRUE)
	->events(TRUE)
	->dealsPropertiesList(TRUE)
	->show();