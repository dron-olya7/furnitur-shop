<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<!-- Основной шаблон, формирующий таблицу сравнения -->
	<xsl:template match="/shop">

		<h1 class="title">Сравнение товаров</h1>

		<xsl:if test="count(shop_compare)">
			<div class="table-responsive">
				<table class="table compare-table">
					<tr>
						<th class="success">Название</th>
						<xsl:apply-templates select="shop_compare/shop_item" mode="name"/>
					</tr>
					<tr>
						<!-- <th>Фото</th> -->
						<th></th>
						<xsl:apply-templates select="shop_compare/shop_item" mode="image"/>
					</tr>
					<tr>
						<th class="danger">Цена</th>
						<xsl:apply-templates select="shop_compare/shop_item" mode="price"/>
					</tr>
					<tr>
						<th>Вес</th>
						<xsl:apply-templates select="shop_compare/shop_item" mode="weight"/>
					</tr>
					<tr>
						<th>Производитель</th>
						<xsl:apply-templates select="shop_compare/shop_item" mode="shop_producer"/>
					</tr>
					<tr>
						<th>Описание</th>
						<xsl:apply-templates select="shop_compare/shop_item" mode="text"/>
					</tr>
					<xsl:apply-templates select="shop_item_properties//property[type != 10]"/>
					<!-- <tr> -->
						<!-- <th></th> -->
						<!-- <xsl:apply-templates select="shop_compare/shop_item" mode="shop_compare"/> -->
					<!-- </tr> -->
				</table>
			</div>
		</xsl:if>

		<xsl:variable name="class">
			<xsl:choose>
				<xsl:when test="count(shop_compare)">d-none</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<div class="alert alert-warning compare-alert {$class}" role="alert">
			Нет товаров для сравнения!
		</div>

		<input type="hidden" class="compare-items" name="count_items" value="{count(shop_compare)}"/>
	</xsl:template>

	<!-- Шаблон, формирующий свойства -->
	<xsl:template match="property">
		<!-- Есть хотя бы одно значение свойства -->
		<xsl:variable name="property_id" select="@id" />
		<xsl:if test="count(/shop/shop_compare/shop_item/property_value[property_id=$property_id][not(file/node()) and value != '' or file != ''])">
			<tr>
				<th>
					<xsl:value-of select="name"/>
				</th>
				<xsl:apply-templates select="/shop/shop_compare/shop_item" mode="property">
					<!-- Передаем через параметр ID свойства -->
					<xsl:with-param name="property_id" select="@id"/>
				</xsl:apply-templates>
			</tr>
		</xsl:if>
	</xsl:template>

	<!-- Шаблон, формирующий значения свойств -->
	<xsl:template match="shop_item" mode="property">
		<!-- Принимаем параметр - ID свойства -->
		<xsl:param name="property_id"/>
		<td class="compare{@id}">
			<xsl:choose>
				<xsl:when test="count(property_value[property_id=$property_id])">
					<xsl:apply-templates select="property_value[property_id=$property_id]" />
				</xsl:when>
				<xsl:otherwise>—</xsl:otherwise>
			</xsl:choose>
		</td>
	</xsl:template>

	<!-- Шаблон вывода значений свойств -->
	<xsl:template match="property_value">
		<xsl:variable name="property_id" select="property_id" />
		<xsl:variable name="type" select="/shop/shop_item_properties//property[@id=$property_id]/type" />

		<xsl:choose>
			<!-- File -->
			<xsl:when test="$type = 2">
				<a target="_blank" href="{../dir}{file}"><xsl:value-of select="file_name"/></a>
			</xsl:when>
			<!-- Wysiwyg -->
			<xsl:when test="$type = 6">
				<xsl:value-of disable-output-escaping="yes" select="value"/>
			</xsl:when>
			<!-- Checkbox -->
			<xsl:when test="$type = 7">
				<xsl:choose>
					<xsl:when test="value = 1">✓</xsl:when>
					<xsl:otherwise>—</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!-- Other types -->
			<xsl:otherwise>
				<xsl:value-of select="value"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="position() != last()">, </xsl:if>
	</xsl:template>

	<!-- Шаблон, формирующий названия товаров -->
	<xsl:template match="shop_compare/shop_item" mode="name">
		<td class="compare{@id} success">
			<div class="d-flex align-items-center justify-content-between">
				<div>
					<a href="{url}" class="compare-name">
						<xsl:value-of select="name"/>
					</a>
				</div>
				<div>
					<i class="fa fa-times-circle-o primary" onclick="$('.compare{@id}').hide('slow'); var count =  $('.compare-items').val(); $('.compare-items').val(count - 1); return $.addCompare('{/shop/url}compare/', {@id}, this);" style="cursor: pointer;"></i>
				</div>
			</div>
		</td>
	</xsl:template>

	<!-- Шаблон, формирующий изображения товаров -->
	<xsl:template match="shop_compare/shop_item" mode="image">
		<td class="compare{@id} text-center">
			<!-- Изображение для товара, если есть -->
			<xsl:choose>
				<xsl:when test="image_small != ''">
					<img class="img-fluid" src="{dir}{image_small}" alt="{name}" title="{name}"/>
				</xsl:when>
				<xsl:otherwise>
					<img class="img-fluid" src="/images/no-image.png" alt="{name}" title="{name}"/>
				</xsl:otherwise>
			</xsl:choose>
		</td>
	</xsl:template>

	<!-- Шаблон, формирующий цены товаров -->
	<xsl:template match="shop_compare/shop_item" mode="price">
		<th class="compare{@id} font-weight-bold danger">
			<xsl:apply-templates select="/shop/shop_currency/code">
				<xsl:with-param name="value" select="price" />
			</xsl:apply-templates>
		</th>
	</xsl:template>

	<!-- Шаблон, формирующий вес товаров -->
	<xsl:template match="shop_compare/shop_item" mode="weight">
		<td class="compare{@id}">
			<xsl:if test="weight > 0">
				<xsl:value-of select="weight"/><xsl:text> </xsl:text><xsl:value-of select="/shop/shop_measure/name"/>
			</xsl:if>
		</td>
	</xsl:template>

	<!-- Шаблон, формирующий производителей товаров -->
	<xsl:template match="shop_compare/shop_item" mode="shop_producer">
		<td class="compare{@id}">
			<xsl:value-of select="shop_producer/name"/>
		</td>
	</xsl:template>

	<!-- Шаблон, формирующий подробную информацию о товаре -->
	<xsl:template match="shop_compare/shop_item" mode="text">
		<td class="compare{@id}">
			<xsl:value-of select="description" disable-output-escaping="yes" />
		</td>
	</xsl:template>

	<!-- Шаблон, отображающий ссылки на удаление из списка сравнения -->
	<xsl:template match="shop_compare/shop_item" mode="shop_compare">
		<td class="compare{@id}">
			<button class="btn" type="button" onclick="$('.compare{@id}').hide('slow'); return $.addCompare('{/shop/url}compare/', {@id}, this);">Удалить</button>
		</td>
	</xsl:template>

	<xsl:template match="shop_currency/code">
		<xsl:param name="value" />

		<xsl:variable name="spaced" select="format-number($value, '# ###', 'my')" />

		<xsl:choose>
			<xsl:when test=". = 'USD'">$<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'EUR'">€<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'GBP'">£<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'RUB'"><xsl:value-of select="$spaced"/> ₽</xsl:when>
			<xsl:when test=". = 'AUD'">AU$<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'CNY'"><xsl:value-of select="$spaced"/>元</xsl:when>
			<xsl:when test=". = 'JPY'"><xsl:value-of select="$spaced"/>¥</xsl:when>
			<xsl:when test=". = 'KRW'"><xsl:value-of select="$spaced"/>₩</xsl:when>
			<xsl:when test=". = 'PHP'"><xsl:value-of select="$spaced"/>₱</xsl:when>
			<xsl:when test=". = 'THB'"><xsl:value-of select="$spaced"/>฿</xsl:when>
			<xsl:when test=". = 'BRL'">R$<xsl:value-of select="$spaced"/></xsl:when>
		<xsl:when test=". = 'INR'"><xsl:value-of select="$spaced"/><i class="fa fa-inr"></i></xsl:when>
		<xsl:when test=". = 'TRY'"><xsl:value-of select="$spaced"/><i class="fa fa-try"></i></xsl:when>
		<xsl:when test=". = 'ILS'"><xsl:value-of select="$spaced"/><i class="fa fa-ils"></i></xsl:when>
			<xsl:otherwise><xsl:value-of select="$spaced"/> <xsl:value-of select="." /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>