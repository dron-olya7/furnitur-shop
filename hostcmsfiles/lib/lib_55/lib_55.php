<?php

$Shop_Controller_Show = Core_Page::instance()->object;

$xslName = $Shop_Controller_Show->item
	? Core_Array::get(Core_Page::instance()->libParams, 'shopItemXsl')
	: Core_Array::get(Core_Page::instance()->libParams, 'shopXsl');

$Shop_Controller_Show->addEntity(
	Core::factory('Core_Xml_Entity')
		->name('ТекущаяГруппа')->value(
			intval(is_array($Shop_Controller_Show->group)
				? Core_Array::first($Shop_Controller_Show->group)
				: $Shop_Controller_Show->group
			)
		)
)->addEntity(
	Core::factory('Core_Xml_Entity')
		->name('show_comments')->value(Core_Array::get(Core_Page::instance()->libParams, 'showComments', 1))
)->addEntity(
	Core::factory('Core_Xml_Entity')
		->name('show_add_comments')->value(Core_Array::get(Core_Page::instance()->libParams, 'showAddComment', 2))
);

$Shop_Controller_Show->tags(TRUE);

if ($Shop_Controller_Show->item == 0)
{
	$Shop_Controller_Show->itemsForbiddenTags(array('text'));

	// Producers
	if (Core_Array::getGet('producer_id'))
	{
		$iProducerId = intval(Core_Array::getGet('producer_id'));
		$Shop_Controller_Show->producer($iProducerId);
	}

	if (Core_Array::getGet('filter') || Core_Array::getGet('sorting'))
	{
		$Shop_Controller_Show->addEntity(
			Core::factory('Core_Xml_Entity')
				->name('filter')->value(1)
		);

		// Sorting
		$sorting = intval(Core_Array::getGet('sorting'));

		($sorting == 1 || $sorting == 2)
			&& $Shop_Controller_Show->orderBy('absolute_price', $sorting == 1 ? 'ASC' : 'DESC');

		$sorting == 3 && $Shop_Controller_Show->orderBy('shop_items.name', 'ASC');

		$Shop_Controller_Show->addEntity(
			Core::factory('Core_Xml_Entity')
				->name('sorting')->value($sorting)
		);

		// Prices
		$Shop_Controller_Show->setFilterPricesConditions($_GET);

		// Additional properties
		$Shop_Controller_Show->setFilterPropertiesConditions($_GET);
	}
}
else
{
	$Shop_Controller_Show
		->associatedItems(TRUE)
		->modifications(TRUE)
		->comments(TRUE)
		->tabs(TRUE)
		;

	if (Core_Array::getPost('add_comment') && Core_Array::get(Core_Page::instance()->libParams, 'showComments', 1))
	{
		$oShop = $Shop_Controller_Show->getEntity();

		$Shop_Controller_Show->cache(FALSE);

		$oLastComment = Core_Entity::factory('Comment')->getLastCommentByIp(
			Core_Array::get($_SERVER, 'REMOTE_ADDR')
		);

		$oXmlCommentTag = Core::factory('Core_Xml_Entity')
			->name('document');

		$siteuser_id = 0;
		if (Core::moduleIsActive('siteuser'))
		{
			$oSiteuser = Core_Entity::factory('Siteuser')->getCurrent();

			if ($oSiteuser)
			{
				$siteuser_id = $oSiteuser->id;
			}
		}

		$oComment = Core_Entity::factory('Comment');

		$allowable_tags = '<b><strong><i><em><br><p><u><strike><ul><ol><li>';
		$oComment->parent_id = intval(Core_Array::getPost('parent_id', 0));
		$oComment->active = $oShop->comment_active;
		$oComment->author = Core_Str::stripTags(Core_Array::getPost('name'));
		$oComment->email = Core_Str::stripTags(Core_Array::getPost('email'));
		$oComment->phone = Core_Str::stripTags(Core_Array::getPost('phone'));
		$oComment->grade = intval(Core_Array::getPost('grade', 0));
		$oComment->subject = Core_Str::stripTags(Core_Array::getPost('subject'));
		$oComment->text = nl2br(Core_Str::stripTags(Core_Array::getPost('text'), $allowable_tags));
		$oComment->siteuser_id = $siteuser_id;

		$oShop_Item = Core_Entity::factory('Shop_Item', $Shop_Controller_Show->item);

		$oXmlCommentTag
			->addEntity($oComment)
			->addEntity($oShop_Item);

		if (is_null($oLastComment) || time() > Core_Date::sql2timestamp($oLastComment->datetime) + ADD_COMMENT_DELAY)
		{
			if ($oShop->use_captcha == 0 || $siteuser_id > 0 || Core_Captcha::valid(Core_Array::getPost('captcha_id'), Core_Array::getPost('captcha')))
			{
				// Antispam
				if (Core::moduleIsActive('antispam'))
				{
					$Antispam_Controller = new Antispam_Controller();
					$bAntispamAnswer = $Antispam_Controller
						->addText($oComment->author)
						->addText($oComment->email)
						->addText($oComment->phone)
						->addText($oComment->subject)
						->addText($oComment->text)
						->execute();

					// Check e-mail
					if ($bAntispamAnswer)
					{
						$bAntispamAnswer = Antispam_Domain_Controller::checkEmail($oComment->email);
					}
				}
				else
				{
					$bAntispamAnswer = TRUE;
				}

				if ($bAntispamAnswer)
				{
					$oComment->save();

					$oComment
						->dateFormat($oShop->format_date)
						->dateTimeFormat($oShop->format_datetime);

					$oShop_Item->add($oComment)->clearCache();

					$oXmlCommentTag->addEntity($oShop);

					// Отправка письма администратору
					$sText = Xsl_Processor::instance()
						->xml($oXmlCommentTag->getXml())
						->xsl(
							Core_Entity::factory('Xsl')
								->getByName(Core_Array::get(Core_Page::instance()->libParams, 'addCommentAdminMailXsl'))
						)
						->process();

					$aFrom = array_map('trim', explode(',', EMAIL_TO));

					Core_Mail::instance()
						->to(EMAIL_TO)
						->from($aFrom[0])
						->header('Reply-To', Core_Valid::email($oComment->email)
							? $oComment->email
							: $aFrom[0]
						)
						->subject(Core::_('Shop.comment_mail_subject'))
						->message(trim($sText))
						->contentType(Core_Array::get(Core_Page::instance()->libParams, 'commentMailNoticeType', 0) == 0
							? 'text/plain'
							: 'text/html'
						)
						->send();
				}
				else
				{
					$oXmlCommentTag->addEntity(Core::factory('Core_Xml_Entity')
						->name('error_antispam')->value(1)
					);

					$oComment->text = Core_Str::br2nl($oComment->text);
					$Shop_Controller_Show->addEntity($oComment);
				}
			}
			else
			{
				$oXmlCommentTag->addEntity(Core::factory('Core_Xml_Entity')
					->name('error_captcha')->value(1)
				);

				$oComment->text = Core_Str::br2nl($oComment->text);
				$Shop_Controller_Show->addEntity($oComment);
			}
		}
		else
		{
			$oXmlCommentTag->addEntity(Core::factory('Core_Xml_Entity')
				->name('error_time')->value(1)
			);

			$oComment->text = Core_Str::br2nl($oComment->text);
			$Shop_Controller_Show->addEntity($oComment);
		}

		// Результат добавления комментария
		$xsl_result = Xsl_Processor::instance()
			->xml($oXmlCommentTag->getXml())
			->xsl(Core_Entity::factory('Xsl')->getByName(
				Core_Array::get(Core_Page::instance()->libParams, 'addCommentNoticeXsl'))
			)
			->process();

		$Shop_Controller_Show->addEntity(
			Core::factory('Core_Xml_Entity')
				->name('message')->value($xsl_result)
		);
	}
}

// В корне выводим из всех групп
/*if ($Shop_Controller_Show->group == 0 || !is_null($Shop_Controller_Show->tag))
{
	$Shop_Controller_Show->group(FALSE)->forbidSelectModifications();
}*/

class Hostcms_Shop_Item_Observer
{
	static public function onBeforeGetXml($object)
	{
		$object->addXmlTag('modifications_count', $object->Modifications->getCount());
	}

	static public function onBeforeSelectModifications($object, $args)
	{
		$args[0]
			->queryBuilder()
			->clearOrderBy()
			->orderBy('shop_items.sorting', 'ASC')
			->orderBy('shop_items.name', 'ASC');
	}
}

if ($Shop_Controller_Show->item)
{
	$oShop_Item_Sets = Core_Entity::factory('Shop_Item_Set');
	$oShop_Item_Sets
		->queryBuilder()
		->where('shop_item_sets.shop_item_set_id', '=', $Shop_Controller_Show->item)
		->limit(3);

	$aShop_Item_Sets = $oShop_Item_Sets->findAll(FALSE);

	if (count($aShop_Item_Sets))
	{
		$oXmlParentSets = Core::factory('Core_Xml_Entity')
			->name('parent_sets');

		foreach ($aShop_Item_Sets as $oShop_Item_Set)
		{
			$oShop_Item = $oShop_Item_Set->Shop_Item;

			$newShopItem = clone $oShop_Item;
			$newShopItem->id = $oShop_Item->id;

			$oXmlParentSets->addEntity($newShopItem);
		}

		$Shop_Controller_Show->addEntity($oXmlParentSets);
	}

	$Shop_Controller_Show->warehousesItems(TRUE);

	Core_Event::attach('shop_item.onBeforeSelectModifications', array('Hostcms_Shop_Item_Observer', 'onBeforeSelectModifications'));
}
else
{
	Core_Event::attach('shop_item.onBeforeGetXml', array('Hostcms_Shop_Item_Observer', 'onBeforeGetXml'));
}

$Shop_Controller_Show
	->xsl(
		Core_Entity::factory('Xsl')->getByName($xslName)
	)
	->show();