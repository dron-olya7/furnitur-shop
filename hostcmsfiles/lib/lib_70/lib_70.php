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

$Siteuser_Controller_Show = Core_Page::instance()->object;

$xslUserAuthorization = Core_Array::get(Core_Page::instance()->libParams, 'userAuthorizationXsl');

$oSiteuser = $Siteuser_Controller_Show->getEntity();

if ($oSiteuser->id)
{
	if (Core::moduleIsActive('shop'))
	{
		/* Последние заказы пользователя */
		$oShop_Orders = Core_Entity::factory('Shop_Order');

		$oShop_Orders
			->queryBuilder()
			->leftJoin('shops', 'shop_orders.shop_id', '=', 'shops.id')
			->where('shop_orders.siteuser_id', '=', $oSiteuser->id)
			->where('shops.site_id', '=', CURRENT_SITE)
			->limit(3)
			->clearOrderBy()
			->orderBy('shop_orders.id', 'DESC');

		$aShop_Orders = $oShop_Orders->findAll(FALSE);

		foreach ($aShop_Orders as $oShop_Order)
		{
			$sum = $oShop_Order->sum();

			$aShop_Order_Items = $oShop_Order->Shop_Order_Items->findAll(FALSE);

			foreach ($aShop_Order_Items as $oShop_Order_Item)
			{
				$oShop_Order->addEntity(
					$oShop_Order_Item->clearEntities()
						->showXmlItem(TRUE)
				);
			}

			$oShop_Order
				->showXmlOrderStatus(TRUE)
				->showXmlDelivery(TRUE);

			//Currency
			$oShop_Currency = Core_Entity::factory('Shop_Currency', $oShop_Order->shop_currency_id);

			if (!is_null($oShop_Currency))
			{
				$oShop_Order->addEntity(
					$oShop_Currency
				);
			}

			$Siteuser_Controller_Show->addEntity(
				$oShop_Order
					->addEntity(
						Core::factory('Core_Xml_Entity')
						->name('sum')
						->value($sum)
				)
			);
		}
	}

	if (Core::moduleIsActive('maillist'))
	{
		/* Почтовые рассылки */
		$aMaillists = $oSiteuser->getAllowedMaillists();

		if (count($aMaillists))
		{
			$Siteuser_Controller_Show->addEntity(
					$oMaillistEntity = Core::factory('Core_Xml_Entity')
						->name('maillists')
				);

			foreach ($aMaillists as $oMaillist)
			{
				$oMaillist_Siteuser = $oSiteuser->Maillist_Siteusers->getByMaillist($oMaillist->id);

				$oMaillistEntity->addEntity(
					$oMaillist->clearEntities()
				);

				if (!is_null($oMaillist_Siteuser))
				{
					$oMaillist->addEntity(
						$oMaillist_Siteuser->clearEntities()
					);
				}
			}
		}
	}

	if (Core::moduleIsActive('helpdesk'))
	{
		$aHelpdesks = Core_Entity::factory('Site', CURRENT_SITE)->Helpdesks->findAll(FALSE);

		if (count($aHelpdesks))
		{
			$Siteuser_Controller_Show->addEntity(
				$oTicketEntity = Core::factory('Core_Xml_Entity')
					->name('helpdesk_tickets')
			);

			$oHelpdesk = $aHelpdesks[0];

			$oHelpdesk_Tickets = $oHelpdesk->Helpdesk_Tickets;

			$oHelpdesk_Tickets
				->queryBuilder()
				->where('helpdesk_tickets.siteuser_id', '=', $oSiteuser->id)
				->limit(5)
				->clearOrderBy()
				->orderBy('helpdesk_tickets.id', 'DESC');

			$aHelpdesk_Tickets = $oHelpdesk_Tickets->findAll(FALSE);

			foreach ($aHelpdesk_Tickets as $oHelpdesk_Ticket)
			{
				$oTicketEntity->addEntity(
					$oHelpdesk_Ticket->clearEntities()
						->showXmlSiteuser(FALSE)
				);

				$oHelpdesk_Messages = $oHelpdesk_Ticket->Helpdesk_Messages;
				$oHelpdesk_Messages
					->queryBuilder()
					->clearOrderBy()
					->orderBy('helpdesk_messages.id', 'ASC')
					->limit(1);

				$aHelpdesk_Messages = $oHelpdesk_Messages->findAll(FALSE);

				if (count($aHelpdesk_Messages))
				{
					$oHelpdesk_Message = $aHelpdesk_Messages[0];

					$oHelpdesk_Ticket->addEntity(
						Core::factory('Core_Xml_Entity')
							->name('helpdesk_ticket_subject')
							->value($oHelpdesk_Message->subject)
					);
				}
			}
		}
	}

	$Siteuser_Controller_Show->addEntity(
		Core::factory('Core_Xml_Entity')
			->name('item')
			->addEntity(
				Core::factory('Core_Xml_Entity')->name('name')->value('Личная информация')
			)
			->addEntity(
				Core::factory('Core_Xml_Entity')->name('path')->value('registration/')
			)
			->addEntity(
				Core::factory('Core_Xml_Entity')->name('image')->value('/images/user/info.png')
			)
	);

	if (Core::moduleIsActive('maillist'))
	{
		$Siteuser_Controller_Show->addEntity(
			Core::factory('Core_Xml_Entity')
				->name('item')
				->addEntity(
					Core::factory('Core_Xml_Entity')->name('name')->value('Почтовые рассылки')
				)
				->addEntity(
					Core::factory('Core_Xml_Entity')->name('path')->value('maillist/')
				)
				->addEntity(
					Core::factory('Core_Xml_Entity')->name('image')->value('/images/user/maillist.png')
				)
		);
	}

	if (Core::moduleIsActive('helpdesk'))
	{
		$Siteuser_Controller_Show->addEntity(
			Core::factory('Core_Xml_Entity')
				->name('item')
				->addEntity(
					Core::factory('Core_Xml_Entity')->name('name')->value('Служба техподдержки')
				)
				->addEntity(
					Core::factory('Core_Xml_Entity')->name('path')->value('helpdesk/')
				)
				->addEntity(
					Core::factory('Core_Xml_Entity')->name('image')->value('/images/user/helpdesk.png')
				)
		);
	}

	if (Core::moduleIsActive('shop'))
	{
		$Siteuser_Controller_Show->addEntity(
			Core::factory('Core_Xml_Entity')
				->name('item')
				->addEntity(
					Core::factory('Core_Xml_Entity')->name('name')->value('Мои заказы')
				)
				->addEntity(
					Core::factory('Core_Xml_Entity')->name('path')->value('order/')
				)
				->addEntity(
					Core::factory('Core_Xml_Entity')->name('image')->value('/images/user/order.png')
				)
		);

		if (Core::moduleIsActive('siteuser'))
		{
			$oAffiliate_Plans = Core_Entity::factory('Site', CURRENT_SITE)->Affiliate_Plans;

			$aSiteuserGroupId = array();

			$oSiteuser_Groups = $oSiteuser->Siteuser_Groups->findAll();
			foreach ($oSiteuser_Groups as $oSiteuser_Group)
			{
				$aSiteuserGroupId[] = $oSiteuser_Group->id;
			}

			if (count($aSiteuserGroupId))
			{
				$oAffiliate_Plans->queryBuilder()
					->where('siteuser_group_id', 'IN', $aSiteuserGroupId);

				$aAffiliate_Plans = $oAffiliate_Plans->findAll();

				if (count($aAffiliate_Plans))
				{
					$Siteuser_Controller_Show->addEntity(
						Core::factory('Core_Xml_Entity')
							->name('item')
							->addEntity(
								Core::factory('Core_Xml_Entity')->name('name')->value('Партнерские программы')
							)
							->addEntity(
								Core::factory('Core_Xml_Entity')->name('path')->value('affiliats/')
							)
							->addEntity(
								Core::factory('Core_Xml_Entity')->name('image')->value('/images/user/partner.png')
							)
					);
				}
			}
		}
	}

	if (Core::moduleIsActive('siteuser'))
	{
		$Siteuser_Controller_Show->addEntity(
			Core::factory('Core_Xml_Entity')
				->name('item')
				->addEntity(
					Core::factory('Core_Xml_Entity')->name('name')->value('Лицевой счет')
				)
				->addEntity(
					Core::factory('Core_Xml_Entity')->name('path')->value('account/')
				)
				->addEntity(
					Core::factory('Core_Xml_Entity')->name('image')->value('/images/user/account.png')
				)
		);
	}

	if (Core::moduleIsActive('shop'))
	{
		$Siteuser_Controller_Show->addEntity(
			Core::factory('Core_Xml_Entity')
				->name('item')
				->addEntity(
					Core::factory('Core_Xml_Entity')->name('name')->value('Мои объявления')
				)
				->addEntity(
					Core::factory('Core_Xml_Entity')->name('path')->value('my_advertisement/')
				)
				->addEntity(
					Core::factory('Core_Xml_Entity')->name('image')->value('/images/user/bulletin-board.png')
				)
		);
	}

	if (Core::moduleIsActive('message'))
	{
		$Siteuser_Controller_Show->addEntity(
			Core::factory('Core_Xml_Entity')
				->name('item')
				->addEntity(
					Core::factory('Core_Xml_Entity')->name('name')->value('Мои сообщения')
				)
				->addEntity(
					Core::factory('Core_Xml_Entity')->name('path')->value('my_messages/')
				)
				->addEntity(
					Core::factory('Core_Xml_Entity')->name('image')->value('/images/user/message.png')
				)
		);
	}

	$Siteuser_Controller_Show->addEntity(
		Core::factory('Core_Xml_Entity')
			->name('item')
			->addEntity(
				Core::factory('Core_Xml_Entity')->name('name')->value('Выход')
			)
			->addEntity(
				Core::factory('Core_Xml_Entity')->name('path')->value('?action=exit')
			)
			->addEntity(
				Core::factory('Core_Xml_Entity')->name('image')->value('/images/user/exit.png')
			)
	);
}

$Siteuser_Controller_Show->xsl(
	Core_Entity::factory('Xsl')->getByName($xslUserAuthorization)
)
	->showGroups(true)
	->show();