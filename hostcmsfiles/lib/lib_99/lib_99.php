<?php
$oShop = Core_Entity::factory('Shop', Core_Array::get(Core_Page::instance()->widgetParams, 'shopId'));
$newXsl = Core_Array::get(Core_Page::instance()->widgetParams, 'newXsl');
$recomendedXsl = Core_Array::get(Core_Page::instance()->widgetParams, 'recomendedXsl');
$discountXsl = Core_Array::get(Core_Page::instance()->widgetParams, 'discountXsl');

if (Core::moduleIsActive('shop'))
{
	?>
	<div class="catalog-main">
		<div class="container">
			<nav>
				<div class="nav nav-tabs" id="nav-tab" role="tablist">
					<a class="nav-link nav-link-new active" id="nav-new-tab" data-toggle="tab" href="#nav-new" role="tab" aria-controls="nav-new" aria-selected="true">Новинки</a>
					<a class="nav-link nav-link-recommended" id="nav-recommended-tab" data-toggle="tab" href="#nav-recommended" role="tab" aria-controls="nav-recommended" aria-selected="false">Рекомендуем</a>
					<a class="nav-link nav-link-discount" id="nav-discount-tab" data-toggle="tab" href="#nav-discount" role="tab" aria-controls="nav-discount" aria-selected="false">Скидки</a>
				</div>
			</nav>
			<div class="tab-content" id="nav-tabContent">
				<div class="tab-pane fade show active" id="nav-new" role="tabpanel" aria-labelledby="nav-new-tab">
					<?php
					// Новинки
					$Shop_Controller_Show = new Shop_Controller_Show(
						Core_Entity::factory('Shop', $oShop->id)
					);

					$Shop_Controller_Show
						->xsl(
							Core_Entity::factory('Xsl')->getByName($newXsl)
						)
						->groupsMode('none')
						->group(FALSE)
						->viewed(FALSE)
						->commentsRating(TRUE)
						->itemsPropertiesList(FALSE)
						->itemsProperties(FALSE)
						->limit(8)
						->itemsForbiddenTags(array('text', 'description'));

					$Shop_Controller_Show
						->shopItems()
						->queryBuilder()
						->where('shop_items.modification_id', '=', 0)
						->where('shop_items.shortcut_id', '=', 0)
						->clearOrderBy()
						->orderBy('shop_items.id', 'DESC');

					$Shop_Controller_Show->show();
					?>
				</div>
				<div class="tab-pane fade" id="nav-recommended" role="tabpanel" aria-labelledby="nav-recommended-tab">
					<?php
					// Рекомендуем
					$Shop_Controller_Show = new Shop_Controller_Show(
						Core_Entity::factory('Shop', $oShop->id)
					);

					$Shop_Controller_Show
						->xsl(
							Core_Entity::factory('Xsl')->getByName($recomendedXsl)
						)
						->groupsMode('none')
						->group(FALSE)
						->viewed(FALSE)
						->commentsRating(TRUE)
						->itemsPropertiesList(FALSE)
						->itemsProperties(FALSE)
						->limit(8)
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
						->where('shop_item_properties.property_id', '=', 13) // Доп.свойство "Рекомендуем"
						->where('property_value_ints.value', '=', 1)
						->groupBy('shop_items.id')
						->having(Core_Querybuilder::expression('COUNT(DISTINCT `shop_item_properties`.`property_id`)'), '=', 1);

					$Shop_Controller_Show->show();
					?>
				</div>
				<div class="tab-pane fade" id="nav-discount" role="tabpanel" aria-labelledby="nav-discount-tab">
					<?php
					// Скидки
					$Shop_Controller_Show = new Shop_Controller_Show(
						Core_Entity::factory('Shop', $oShop->id)
					);

					$Shop_Controller_Show
						->xsl(
							Core_Entity::factory('Xsl')->getByName($discountXsl)
						)
						->groupsMode('none')
						->group(FALSE)
						->viewed(FALSE)
						->commentsRating(TRUE)
						->itemsPropertiesList(FALSE)
						->itemsProperties(FALSE)
						->limit(8)
						->itemsForbiddenTags(array('text', 'description'));

					$Shop_Controller_Show
						->shopItems()
						->queryBuilder()
						->join('shop_item_discounts', 'shop_item_discounts.shop_item_id', '=', 'shop_items.id')
						->join('shop_discounts', 'shop_discounts.id', '=', 'shop_item_discounts.shop_discount_id')
						->where('shop_discounts.active', '=', 1)
						->where('shop_discounts.start_datetime', '<', Core_Date::timestamp2sql(time()))
						->where('shop_discounts.end_datetime', '>', Core_Date::timestamp2sql(time()))
						->where('shop_discounts.deleted', '=', 0)
						->where('shop_items.modification_id', '=', 0)
						->groupBy('shop_items.id')
						->clearOrderBy()
						->orderBy('RAND()');

					$Shop_Controller_Show->show();
					?>
				</div>
			</div>
		</div>
	</div>
	<?php
}