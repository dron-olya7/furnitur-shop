<?php

$oShop = Core_Entity::factory('Shop', Core_Array::get(Core_Page::instance()->libParams, 'shopId'));

$Shop_Controller_Show = new Shop_Controller_Show($oShop);

$Shop_Controller_Show
	// Выводить свойства товаров
	->itemsProperties(TRUE)
	->commentsProperties(TRUE)
	->commentsRating(TRUE)
	// ->seoFilters(TRUE)
	// Выводить специальные цены
	->specialprices(TRUE)
	// Выводить модификации на уровне с товаром
	// ->modificationsList(TRUE)
	// ->modificationsGroup(TRUE)
	// Режим вывода групп
	->groupsMode('all')
	// Выводить доп. св-ва групп
	//->groupsProperties(TRUE)
	// Фильтровать по ярлыкам
	//->filterShortcuts(TRUE)
	// Только доступные элементы списков в фильтре
	//->itemsPropertiesListJustAvailable(TRUE)
	// ->barcodes(TRUE)
	// ->warehouseMode('in-stock')
;

/* Количество */
$on_page = intval(Core_Array::getGet('on_page'));
if ($on_page > 0 && $on_page < 150)
{
	$limit = $on_page;

	$Shop_Controller_Show->addEntity(
		Core::factory('Core_Xml_Entity')
			->name('on_page')->value($on_page)
	);
}
else
{
	$limit = $oShop->items_on_page;
}

$Shop_Controller_Show
	//->warehouseMode('in-stock')
	->limit($limit)
	->parseUrl();

// Выводить товары из подгрупп
$Shop_Controller_Show->group
	&& $Shop_Controller_Show->subgroups(TRUE);

// При фильтрации модификации выводятся на уровне товаров
if (count($Shop_Controller_Show->getFilterProperties()) || count($Shop_Controller_Show->getFilterPrices()) || $Shop_Controller_Show->producer)
{
	$Shop_Controller_Show->modificationsList(TRUE)->modificationsGroup(TRUE);
}

// Обработка скачивания файла электронного товара
$guid = Core_Array::getGet('download_file');
if ($guid != '')
{
	$oShop_Order_Item_Digital = Core_Entity::factory('Shop_Order_Item_Digital')->getByGuid($guid);

	if (!is_null($oShop_Order_Item_Digital) && $oShop_Order_Item_Digital->Shop_Order_Item->Shop_Order->shop_id == $oShop->id)
	{
		$iDay = 7;

		// Проверяем, доступна ли ссылка (Ссылка доступна в течение недели после оплаты)
		if (Core_Date::sql2timestamp($oShop_Order_Item_Digital->Shop_Order_Item->Shop_Order->payment_datetime) > time() - 24 * 60 * 60 * $iDay)
		{
			$oShop_Item_Digital = $oShop_Order_Item_Digital->Shop_Item_Digital;
			if ($oShop_Item_Digital->filename != '')
			{
				Core_File::download($oShop_Item_Digital->getFullFilePath(), $oShop_Item_Digital->filename);
				exit();
			}
		}
		else
		{
			Core_Message::show(Core::_('Shop_Order_Item_Digital.time_is_up', $iDay));
		}
	}

	Core_Page::instance()->response->status(404)->sendHeaders()->showBody();
	exit();
}

if (!is_null(Core_Array::getRequest('selectModification')))
{
	$aJSON = array();

	$shop_item_id = intval(Core_Array::getPost('shop_item_id'));

	$bAllPropertiesExists = TRUE;
	$aPropertyIDs = $aProperty_Values = array();
	foreach ($_POST as $key => $value)
	{
		$aExplode = explode('property_', $key);
		if (isset($aExplode[1]))
		{
			$value
				? $aProperty_Values[$aExplode[1]] = $value
				: $bAllPropertiesExists = FALSE;

			$aPropertyIDs[] = $aExplode[1];
		}
	}

	$oShop_Item = Core_Entity::factory('Shop_Item')->getById($shop_item_id);

	if (!is_null($oShop_Item))
	{
		if (count($aProperty_Values))
		{
			$oModifications = $oShop_Item->Modifications;
			$oModifications->queryBuilder()
				->select('shop_items.*')
				->leftJoin('shop_item_properties', 'shop_items.shop_id', '=', 'shop_item_properties.shop_id')
				->leftJoin('property_value_ints', 'shop_items.id', '=', 'property_value_ints.entity_id',
					array(
						array('AND' => array('shop_item_properties.property_id', '=', Core_QueryBuilder::expression('`property_value_ints`.`property_id`')))
					)
				)
				->where('shop_items.active', '=', 1);

			$oModifications->queryBuilder()->open();

			foreach ($aProperty_Values as $property_id => $value)
			{
				$oModifications->queryBuilder()
					// Идентификатор дополнительного свойства
					->where('shop_item_properties.property_id', '=', $property_id)
					// Значение дополнительного свойства
					->where('property_value_ints.value', '=', $value)
					->setOr();
			}

			$oModifications->queryBuilder()->close();

			$oModifications->queryBuilder()
				->groupBy('shop_items.id')
				// Количество свойств, если 1, то можно не указывать
				->having(Core_Querybuilder::expression('COUNT(DISTINCT `shop_item_properties`.`property_id`)'), '=', count($aProperty_Values));

			$aModifications = $oModifications->findAll(FALSE);

			$aValues = array();
			foreach ($aModifications as $oModification)
			{
				$aTmp_Property_Values = $oModification->getPropertyValues(FALSE, $aPropertyIDs);

				foreach ($aTmp_Property_Values as $oProperty_Value)
				{
					// Если список
					if ($oProperty_Value->Property->type == 3)
					{
						if (!isset($aValues[$oProperty_Value->property_id]) || !in_array($oProperty_Value->value, $aValues[$oProperty_Value->property_id]))
						{
							$aValues[$oProperty_Value->property_id][] = intval($oProperty_Value->value);
						}
					}
				}
			}

			$aJSON['available'] = $aValues;

			// Переданы все свойства, передаем подхоодящие модификации
			if ($bAllPropertiesExists)
			{
				foreach ($aModifications as $oModification)
				{
					$aPrices = $oModification->getPrices();
					$aJSON['items'][] = array(
						'id' => intval($oModification->id),
						'name' => $oModification->name,
						'description' => $oModification->description,
						'text' => $oModification->text,
						'price' => round($aPrices['price_discount']),
						'discount' => round($aPrices['discount'])
					);
				}
			}
		}

		$aPrices = $oShop_Item->getPrices();
		$aJSON['parent'] = array(
			'id' => intval($oShop_Item->id),
			'name' => $oShop_Item->name,
			'description' => $oShop_Item->description,
			'text' => $oShop_Item->text,
			'price' => round($aPrices['price_discount']),
			'discount' => round($aPrices['discount'])
		);
	}

	Core::showJson($aJSON);
}

// Быстрый фильтр
if (Core_Array::getRequest('fast_filter'))
{
	$aJson = array();

	if ($oShop->filter)
	{
		$Shop_Controller_Show->modificationsList(TRUE);

		// В корне выводим из всех групп
		if ($Shop_Controller_Show->group == 0)
		{
			$Shop_Controller_Show->group(FALSE);
		}

		// Запрещаем выбор модификаций при выключенном modificationsList
		!$Shop_Controller_Show->modificationsList && $Shop_Controller_Show->forbidSelectModifications();

		foreach ($_POST as $key => $value)
		{
			if (strpos($key, 'property_') === 0)
			{
				$Shop_Controller_Show->removeFilter('property', substr($key, 9));
			}
			elseif (strpos($key, 'price_') === 0)
			{
				$Shop_Controller_Show->removeFilter('price');
			}
		}

		// Remove all checkboxes
		$aFilterProperties = $Shop_Controller_Show->getFilterProperties();
		foreach ($aFilterProperties as $propertyId => $aTmpProperties)
		{
			if (isset($aTmpProperties[0]) && $aTmpProperties[0][0]->type == 7)
			{
				$Shop_Controller_Show->removeFilter('property', $propertyId);
			}
		}

		// Prices
		$Shop_Controller_Show->setFilterPricesConditions($_POST);

		// Additional properties
		$Shop_Controller_Show->setFilterPropertiesConditions($_POST);

		if (Core_Array::getPost('producer_id'))
		{
			$iProducerId = intval(Core_Array::getPost('producer_id'));
			$Shop_Controller_Show->producer($iProducerId);
		}

		$Shop_Controller_Show->applyItemCondition();

		$Shop_Controller_Show->group !== FALSE && $Shop_Controller_Show->applyGroupCondition();

		$Shop_Controller_Show->applyFilter();

		$Shop_Controller_Show
			->shopItems()
			->queryBuilder()
			->where('shortcut_id', '=', 0)
			->clearGroupBy()
			->clearOrderBy();

		$aJson['count'] = $Shop_Controller_Show->getCount();
		// $aJson['query'] = Core_Database::instance()->getLastQuery();
	}

	Core::showJson($aJson);
}

// Сравнение товаров
if (Core_Array::getRequest('compare'))
{
	$shop_item_id = intval(Core_Array::getRequest('compare'));

	if (Core_Entity::factory('Shop_Item', $shop_item_id)->shop_id == $oShop->id)
	{
		Core_Session::start();
		if (isset($_SESSION['hostcmsCompare'][$oShop->id][$shop_item_id]))
		{
			unset($_SESSION['hostcmsCompare'][$oShop->id][$shop_item_id]);
		}
		else
		{
			$_SESSION['hostcmsCompare'][$oShop->id][$shop_item_id] = 1;
		}
	}

	Core_Page::instance()->response
		->status(200)
		->header('Pragma', "no-cache")
		->header('Cache-Control', "private, no-cache")
		->header('Vary', "Accept")
		->header('Last-Modified', gmdate('D, d M Y H:i:s', time()) . ' GMT')
		->header('X-Powered-By', 'HostCMS')
		->header('Content-Disposition', 'inline; filename="files.json"');

	Core_Page::instance()->response
		->body(json_encode('OK'))
		->header('Content-type', 'application/json; charset=utf-8');

	Core_Page::instance()->response
		->sendHeaders()
		->showBody();

	exit();
}

// Избранное
if (Core_Array::getRequest('favorite'))
{
	$shop_item_id = intval(Core_Array::getRequest('favorite'));

	if (Core_Entity::factory('Shop_Item', $shop_item_id)->shop_id == $oShop->id)
	{
		Core_Session::start();
		Core_Session::setMaxLifeTime(86400 * 30);

		if (isset($_SESSION['hostcmsFavorite'][$oShop->id]) && in_array($shop_item_id, $_SESSION['hostcmsFavorite'][$oShop->id]))
		{
			unset($_SESSION['hostcmsFavorite'][$oShop->id][
				array_search($shop_item_id, $_SESSION['hostcmsFavorite'][$oShop->id])
			]);
		}
		else
		{
			$_SESSION['hostcmsFavorite'][$oShop->id][] = $shop_item_id;
		}
	}

	Core_Page::instance()->response
		->status(200)
		->header('Pragma', "no-cache")
		->header('Cache-Control', "private, no-cache")
		->header('Vary', "Accept")
		->header('Last-Modified', gmdate('D, d M Y H:i:s', time()) . ' GMT')
		->header('X-Powered-By', 'HostCMS')
		->header('Content-Disposition', 'inline; filename="files.json"');

	Core_Page::instance()->response
		->body(json_encode('OK'))
		->header('Content-type', 'application/json; charset=utf-8');

	Core_Page::instance()->response
		->sendHeaders()
		->showBody();

	exit();
}

// Viewed items
if ($Shop_Controller_Show->item && $Shop_Controller_Show->viewed)
{
	// Core_Session::start();
	// Core_Session::setMaxLifeTime(28800, TRUE);

	$Shop_Controller_Show->addIntoViewed();
}

if (!is_null(Core_Array::getGet('vote')))
{
	$oSiteuser = Core_Entity::factory('Siteuser')->getCurrent();
	$entity_id = intval(Core_Array::getGet('id'));

	if ($entity_id && !is_null($oSiteuser))
	{
		$entity_type = strval(Core_Array::getGet('entity_type'));
		$vote = intval(Core_Array::getGet('vote'));

		$oObject = Vote_Controller::instance()->getVotedObject($entity_type, $entity_id);

		if (!is_null($oObject))
		{
			$oVote = $oObject->Votes->getBySiteuser_Id($oSiteuser->id);

			$vote_value = $vote ? 1 : -1;

			$deleteVote = 0;
			// Пользователь не голосовал ранее
			if (is_null($oVote))
			{
				$oVote = Core_Entity::factory('Vote');
				$oVote->siteuser_id = $oSiteuser->id;
				$oVote->value = $vote_value;

				$oObject->add($oVote);
			}
			// Пользователь голосовал ранее, но поставил противоположную оценку
			elseif ($oVote->value != $vote_value)
			{
				$oVote->value = $vote_value;
				$oVote->save();
			}
			// Пользователь голосовал ранее и поставил такую же оценку как и ранее, обнуляем его голосование, как будто он вообще не голосовал
			else
			{
				$deleteVote = 1;
				$oVote->delete();
			}

			Core_Entity::factory('Shop_Item', $entity_id)->clearCache();

			$aVotingStatistic = Vote_Controller::instance()->getRate($entity_type, $entity_id);

			Core_Page::instance()->response
			->body(
				json_encode(array('value' => $oVote->value, 'item' => $oObject->id, 'entity_type' => $entity_type,
					'likes' => $aVotingStatistic['likes'], 'dislikes' => $aVotingStatistic['dislikes'],
					'rate' => $aVotingStatistic['rate'], 'delete_vote' => $deleteVote)
				)
			);
		}
	}

	Core_Page::instance()->response
		->status(200)
		->header('Pragma', "no-cache")
		->header('Cache-Control', "private, no-cache")
		->header('Vary', 'Accept')
		->header('Last-Modified', gmdate('D, d M Y H:i:s', time()) . ' GMT')
		->header('X-Powered-By', 'HostCMS')
		->header('Content-Disposition', 'inline; filename="files.json"');

	if (strpos(Core_Array::get($_SERVER, 'HTTP_ACCEPT', ''), 'application/json') !== FALSE)
	{
		Core_Page::instance()->response->header('Content-type', 'application/json; charset=utf-8');
	}
	else
	{
		Core_Page::instance()->response
			->header('X-Content-Type-Options', 'nosniff')
			->header('Content-type', 'text/plain; charset=utf-8');
	}

	if(Core_Array::getRequest('_'))
	{
		Core_Page::instance()->response
			->sendHeaders()
			->showBody();
		exit();
	}
}

if (isset($Shop_Controller_Show->item) && $Shop_Controller_Show->item)
{
	Core_Page::instance()->template(
		Core_Entity::factory('Template', 8)
	);
}


Core_Page::instance()->object = $Shop_Controller_Show;