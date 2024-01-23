<?php
$oShop = Core_Entity::factory('Shop', Core_Array::get(Core_Page::instance()->widgetParams, 'shopId'));
$xsl = Core_Array::get(Core_Page::instance()->widgetParams, 'xsl');
?>
<div class="catalog-main">
	<div class="container">
		<?php
			$Shop_Controller_Show = new Shop_Controller_Show(
				Core_Entity::factory('Shop', $oShop->id)
			);

			$property_id = 18;

			$Shop_Controller_Show
				->xsl(
					Core_Entity::factory('Xsl')->getByName($xsl)
				)
				->groupsMode('none')
				->group(FALSE)
				->viewed(FALSE)
				->favorite(FALSE)
				->comparing(FALSE)
				->itemsPropertiesList(FALSE)
				->itemsProperties(array($property_id))
				->commentsPropertiesList(FALSE)
				->limit(5)
				->itemsForbiddenTags(array('text', 'description'));

				$Shop_Controller_Show
					->shopItems()
					->queryBuilder()
					->leftJoin('shop_item_properties', 'shop_items.shop_id', '=', 'shop_item_properties.shop_id')
					->leftJoin('property_value_ints', 'shop_items.id', '=', 'property_value_ints.entity_id',
						array(
						  array('AND' => array('shop_item_properties.property_id', '=', Core_QueryBuilder::expression('`property_value_ints`.`property_id`')))
						)
					)
					->where('shop_item_properties.property_id', '=', 17) // Доп.свойство "Промо"
					->where('property_value_ints.value', '=', 1)
					->groupBy('shop_items.id')
					->having(Core_Querybuilder::expression('COUNT(DISTINCT `shop_item_properties`.`property_id`)'), '=', 1);

				$Shop_Controller_Show->show();
		?>
	</div>
</div>