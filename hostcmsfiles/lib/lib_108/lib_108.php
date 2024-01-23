<?php
if (Core::moduleIsActive('shop'))
{
	$xsl = Core_Array::get(Core_Page::instance()->widgetParams, 'xsl');

	$bShop = Core::moduleIsActive('shop') && isset(Core_Page::instance()->widgetParams['shopId'])
		&& is_object(Core_Page::instance()->object)
		&& get_class(Core_Page::instance()->object) == 'Shop_Controller_Show';

	$bItem = $bShop && Core_Page::instance()->object->item;

	if ($bShop && !$bItem && Core_Page::instance()->object->group)
	{
		$oShop = Core_Entity::factory('Shop', Core_Page::instance()->widgetParams['shopId']);
		$Shop_Controller_Show = new Shop_Controller_Show($oShop);
		$Shop_Controller_Show
			->xsl(
				Core_Entity::factory('Xsl')->getByName($xsl)
			)
			->groupsMode('tree')
			->limit(0)
			->viewed(FALSE)
			->itemsProperties(TRUE);

		if (is_object(Core_Page::instance()->object)
		&& get_class(Core_Page::instance()->object) == 'Shop_Controller_Show')
		{
			$mCurrentShopGroup = Core_Page::instance()->object->group;

			$Shop_Controller_Show->setFilterProperties(Core_Page::instance()->object->getFilterProperties());
			$Shop_Controller_Show->setFilterPrices(Core_Page::instance()->object->getFilterPrices());
			$Shop_Controller_Show->setFilterMainProperties(Core_Page::instance()->object->getFilterMainProperties());

			Core_Page::instance()->object->producer
				&& $Shop_Controller_Show->producer(Core_Page::instance()->object->producer);

			!is_null(Core_Page::instance()->object->tag)
				&& $Shop_Controller_Show->tag(Core_Page::instance()->object->tag);
		}
		else
		{
			$mCurrentShopGroup = 0;
		}

		$Shop_Controller_Show
			->group($mCurrentShopGroup)
			->subgroups(Core_Page::instance()->object->subgroups)
			->applyGroupCondition();

		/*if ($Shop_Controller_Show->group == 0)
		{
			$Shop_Controller_Show->group(FALSE);
		}*/

		//Sorting
		if (Core_Array::getGet('sorting'))
		{
			$sorting = intval(Core_Array::getGet('sorting'));
			$Shop_Controller_Show->addEntity(
				Core::factory('Core_Xml_Entity')
					->name('sorting')->value($sorting)
			);
			$Shop_Controller_Show->addCacheSignature('sorting=' . $sorting);
		}

		/* Количество */
		$on_page = intval(Core_Array::getGet('on_page'));
		if ($on_page > 0 && $on_page < 150)
		{
			$Shop_Controller_Show->addEntity(
				Core::factory('Core_Xml_Entity')
					->name('on_page')->value($on_page)
			);
		}

		$Shop_Controller_Show
			//Фильтровать по ярлыкам
			//->filterShortcuts(TRUE)
			->modificationsList(TRUE)
			->favorite(FALSE)
			->viewed(FALSE)
			->addProducers()
			->filterCounts(TRUE)
			->addMinMaxPrice()
			->show();
	}
}