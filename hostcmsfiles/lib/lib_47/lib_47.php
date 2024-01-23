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

$Shop_Discountcard_Controller_Show = new Shop_Discountcard_Controller_Show($oSiteuser);

$aSiteuser_Groups = $oSiteuser->Siteuser_Groups->findAll();

foreach ($aSiteuser_Groups as $oSiteuser_Group)
{
	$Shop_Discountcard_Controller_Show->addEntity(
		$oSiteuser_Group->clearEntities()
	);
}

$aShops = Core_Entity::factory('Shop')->getAllBySite_id(CURRENT_SITE);

/* Лицевой счет */
$Shop_Discountcard_Controller_Show->addEntity(
	$oAccountEntity = Core::factory('Core_Xml_Entity')
		->name('account')
);

foreach ($aShops as $oShop)
{
	$amount = $oSiteuser->getTransactionsAmount($oShop);

	$aBonuses = $oSiteuser->getBonuses($oShop);

	$oShop->addEntity(
		Core::factory('Core_Xml_Entity')
			->name('transaction_amount')
			->value($amount)
	)->addEntity(
		Core::factory('Core_Xml_Entity')
			->name('bonuses_amount')
			->value($aBonuses['total'])
	);

	$oAccountEntity->addEntity($oShop);
}

$Shop_Discountcard_Controller_Show
	->xsl(
		Core_Entity::factory('Xsl')->getByName(
			Core_Array::get(Core_Page::instance()->libParams, 'xsl')
		)
	)
	->show();