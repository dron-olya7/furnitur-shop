<?php

if (Core::moduleIsActive('search'))
{
	// Autocomplete
	if (!is_null(Core_Array::getGet('autocomplete')) && !is_null(Core_Array::getGet('query')))
	{
		//$iShopId = 1;
		$sQuery = Core_Str::stripTags(strval(Core_Array::getGet('query')));

		$aJSON = array();
		$aJSON['query'] = $sQuery;
		$aJSON['suggestions'] = array();

		$oShop_Items = Core_Entity::factory('Shop_Item');
		$oShop_Items->queryBuilder()
			->select('shop_items.*')
			->join('shops', 'shop_items.shop_id', '=', 'shops.id')
			//->join('shop_groups', 'shop_items.shop_group_id', '=', 'shop_groups.id')
			->where('shops.site_id', '=', CURRENT_SITE)
			//->where('shop_groups.active', '=', 1)
			->where('shop_items.active', '=', 1)
			->where('shop_items.indexing', '=', 1)
			->where('shop_items.name', 'LIKE', '%' . $sQuery . '%')
			->limit(10)
			->clearOrderBy();

		$aShop_Items = $oShop_Items->findAll(FALSE);

		foreach ($aShop_Items as $oShop_Item)
		{
			$path = $oShop_Item->Shop->Structure->getPath() . $oShop_Item->getPath();
			$aJSON['suggestions'][] = array(
				'value' => $oShop_Item->name,
				'price' => $oShop_Item->price,
				'data' => $oShop_Item->id,
				'path' => $path
			);
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
			->body(json_encode($aJSON))
			->header('Content-type', 'application/json; charset=utf-8');

		Core_Page::instance()->response
			->sendHeaders()
			->showBody();

		exit();
	}

	$oSite = Core_Entity::factory('Site', CURRENT_SITE);

	$Search_Controller_Show = new Search_Controller_Show($oSite);

	$Search_Controller_Show
		->limit(Core_Page::instance()->libParams['itemsOnPage'])
		->parseUrl()
		->len(Core_Page::instance()->libParams['maxlen'])
		->query(Core_Array::getGet('text'));

	$text = Core_Array::getGet('text');
	if (!is_null($text))
	{
		Core_Page::instance()->title(
			Core::_('Search.frontend_title', $text)
		);
	}

	Core_Page::instance()->object = $Search_Controller_Show;
}