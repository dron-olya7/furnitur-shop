<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- ОплатаБезналичнаяОтЮрЛица -->

	<xsl:decimal-format name="my" decimal-separator="." grouping-separator=" "/>

	<xsl:template match="/shop">
		<h1 class="cart-title">Ваш заказ оформлен</h1>

		<div class="alert alert-success fade in alert-cart show">
			Распечатайте <a href="{/shop/url}cart/print/{shop_order/guid}/" target="_blank"><b>бланк счета</b></a><xsl:text> </xsl:text><img src="/hostcmsfiles/images/new_window.gif"/> и передайте его в бухгалтерию.
		</div>

		<!-- <div class="alert alert-info fade in alert-cart show">
			Через некоторое время с Вами свяжется наш менеджер, чтобы согласовать заказанный товар и время доставки.
		</div> -->

		<xsl:apply-templates select="shop_order"/>

		<xsl:choose>
			<xsl:when test="count(shop_order/shop_order_item)">
				<h2>Заказанные товары</h2>

				<div class="table-responsive">
					<table class="table shop-cart">
						<thead>
							<tr>
								<th>Наименование</th>
								<th>Артикул</th>
								<th>Количество</th>
								<th>Цена</th>
								<th>Сумма</th>
							</tr>
						</thead>
						<tbody>
							<xsl:apply-templates select="shop_order/shop_order_item"/>
							<tr class="total">
								<td colspan="4"></td>
								<td>Итого:</td>
							<td><xsl:value-of select="format-number(shop_order/total_amount,'### ##0.00', 'my')"/><xsl:text> </xsl:text><xsl:value-of select="/shop/shop_order/shop_currency/sign"/></td>
							</tr>
						</tbody>
					</table>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div class="alert alert-info fade in alert-cart">
					<p><b>Заказанных товаров нет.</b></p>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Шаблон вывода данных о заказе -->
	<xsl:template match="shop_order">

		<h2>Данные доставки</h2>

		<p>
<b>ФИО:</b><xsl:text> </xsl:text><xsl:value-of select="surname"/><xsl:text> </xsl:text><xsl:value-of select="name"/><xsl:text> </xsl:text><xsl:value-of select="patronymic"/>

		<br /><b>E-mail:</b><xsl:text> </xsl:text><xsl:value-of select="email"/>

			<xsl:if test="phone != ''">
			<br /><b>Телефон:</b><xsl:text> </xsl:text><xsl:value-of select="phone"/>
			</xsl:if>

			<xsl:if test="fax != ''">
			<br /><b>Факс:</b><xsl:text> </xsl:text><xsl:value-of select="fax"/>
			</xsl:if>

			<xsl:variable name="location">, <xsl:value-of select="shop_country/shop_country_location/name"/></xsl:variable>
			<xsl:variable name="city">, <xsl:value-of select="shop_country/shop_country_location/shop_country_location_city/name"/></xsl:variable>
			<xsl:variable name="city_area">, <xsl:value-of select="shop_country/shop_country_location/shop_country_location_city/shop_country_location_city_area/name"/></xsl:variable>
			<xsl:variable name="adres">, <xsl:value-of select="address"/></xsl:variable>

	<br /><b>Адрес доставки:</b><xsl:text> </xsl:text><xsl:if test="postcode != ''"><xsl:value-of select="postcode"/>, </xsl:if>
			<xsl:if test="shop_country/name != ''">
				<xsl:value-of select="shop_country/name"/>
			</xsl:if>
			<xsl:if test="$location != ', '">
				<xsl:value-of select="$location"/>
			</xsl:if>
			<xsl:if test="$city != ', '">
				<xsl:value-of select="$city"/>
			</xsl:if>
			<xsl:if test="$city_area != ', '">
				<xsl:value-of select="$city_area"/>&#xA0;район</xsl:if>
			<xsl:if test="$adres != ', '">
				<xsl:value-of select="$adres"/>
			</xsl:if>

			<xsl:if test="shop_delivery/name != ''">
			<br /><b>Тип доставки:</b><xsl:text> </xsl:text><xsl:value-of select="shop_delivery/name"/>
			</xsl:if>

			<xsl:if test="shop_payment_system/name != ''">
			<br /><b>Способ оплаты:</b><xsl:text> </xsl:text><xsl:value-of select="shop_payment_system/name"/>
			</xsl:if>
		</p>
	</xsl:template>

	<!-- Данные о товарах -->
	<xsl:template match="shop_order/shop_order_item">
		<tr>
			<td class="hidden-xs">
				<xsl:if test="shop_item/image_small != ''">
					<img src="{shop_item/dir}{shop_item/image_small}" alt="" height="150"/>
				</xsl:if>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="shop_item/url != ''">
						<a href="http://{/shop/site/site_alias/name}{shop_item/url}">
							<xsl:value-of select="name"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="name"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:value-of select="marking"/>
			</td>
			<td>
				<xsl:value-of select="quantity"/><xsl:text> </xsl:text><xsl:value-of select="shop_item/shop_measure/name"/>
			</td>
			<td style="white-space: nowrap">
				<xsl:value-of select="format-number(price,'### ##0.00', 'my')"/><xsl:text> </xsl:text><xsl:value-of select="/shop/shop_order/shop_currency/sign" disable-output-escaping="yes" />
			</td>
			<td style="white-space: nowrap">
				<xsl:value-of select="format-number(quantity * price,'### ##0.00', 'my')"/><xsl:text> </xsl:text><xsl:value-of select="/shop/shop_order/shop_currency/sign" disable-output-escaping="yes" />
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>