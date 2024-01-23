<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- ОплатаПоФормеПД4 -->

	<xsl:decimal-format name="my" decimal-separator="." grouping-separator=" "/>

	<xsl:template match="/shop">

		<ul class="shop_navigation">
			<li><span>Адрес доставки</span>→</li>
			<li><span>Способ доставки</span>→</li>
			<li><span>Форма оплаты</span>→</li>
			<li class="shop_navigation_current"><span>Данные доставки</span></li>
		</ul>

		<h1>Ваш заказ оформлен</h1>

		<p>Распечатайте <a href="{/shop/url}cart/print/{shop_order/guid}/" target="_blank"><b>бланк квитанции по форме ПД-4</b></a><xsl:text> </xsl:text><img src="/hostcmsfiles/images/new_window.gif"/>, вырежьте его и оплатите в отделении Сбербанка или другого коммерческого банка.</p>

		<!-- Общая сумма В КОПЕЙКАХ -->
		<xsl:variable name="totalAmout" select="shop_order/total_amount * 100" />

		<div class="row">
			<div class="col-xs-12 col-sm-6">
				<!-- QR-код -->
				<img src="http://decodeit.ru/image.php?type=qr&amp;value=ST00012|Name={company/name}|PersonalAcc={company/current_account}|BankName={company/bank_name}|BIC={company/bic}|CorrespAcc={company/correspondent_account}|PayeeINN={company/tin}|LastName={shop_order/surname}|FirstName={shop_order/name}|MiddleName={shop_order/patronymic}|Purpose=Оплата счета {shop_order/invoice}|РауеrАddress={shop_order/postcode}, {shop_order/address}|Sum={$totalAmout}|Phone={shop_order/phone}" width="400" height="400" border="0" title="QR код" />
			</div>
			<div class="col-xs-12 col-sm-6">
				<h2>Оплата через Сбербанк.Онлайн</h2>
				<p>Запустите приложение Сбербанк.Онлайн, выберите в нижнем меню <b>Платежи</b>, в открывшемся списке <b>Оплата по QR-коду</b>. Наведите камеру на QR-код, размещенный слева от инструкции. На следующем шаге введите свой адрес, а в дополнительной информации укажите "<b>Счет <xsl:value-of select="shop_order/invoice" /></b>".</p>
				<img src=" data:image/png;base64,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" />
			</div>
		</div>

		<xsl:apply-templates select="shop_order"/>

		<xsl:choose>
			<xsl:when test="count(shop_order/shop_order_item)">
				<h2>Заказанные товары</h2>

				<table class="shop_cart">
					<tr>
						<th>Наименование</th>
						<th>Артикул</th>
						<th>Количество</th>
						<th>Цена</th>
						<th>Сумма</th>
					</tr>
					<xsl:apply-templates select="shop_order/shop_order_item"/>
					<tr class="total">
						<td colspan="3"></td>
						<td>Итого:</td>
						<td><xsl:value-of select="format-number(shop_order/total_amount,'### ##0.00', 'my')"/><xsl:text> </xsl:text><xsl:value-of select="/shop/shop_order/shop_currency/sign"/></td>
					</tr>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<p><b>Заказанных товаров нет.</b></p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Order Template -->
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
				<xsl:value-of select="$city_area"/><xsl:text> </xsl:text>район</xsl:if>
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

	<!-- Ordered Item Template -->
	<xsl:template match="shop_order/shop_order_item">
		<tr>
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