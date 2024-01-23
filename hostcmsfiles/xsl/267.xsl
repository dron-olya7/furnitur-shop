<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<xsl:template match="/shop">
		<h1 class="cart-title">Способ доставки</h1>
		<div class="row">
			<div class="col-12">
				<div class="cart">
					<form class="cart-form" action="./" method="post">
						<xsl:choose>
							<xsl:when test="count(shop_delivery) = 0">
								<div class="alert alert-danger">
									<p>По выбранным Вами условиям доставка не возможна, заказ будет оформлен без доставки.</p>
									<p>Уточнить данные о доставке Вы можете, связавшись с представителем нашей компании.</p>
									<input type="hidden" name="shop_delivery_condition_id" value="0"/>
								</div>
							</xsl:when>
							<xsl:otherwise>
								<div class="cart-products">
									<div class="table-responsive">
										<table class="table cart-delivery">
											<thead>
												<tr class="total">
													<th width="20%"></th>
													<th>Описание</th>
													<th width="15%">Цена доставки</th>
													<th width="15%">Стоимость товаров</th>
													<th width="15%">Итого</th>
												</tr>
											</thead>
											<tbody>
												<xsl:apply-templates select="shop_delivery"/>
											</tbody>
										</table>
									 </div>
								</div>
							</xsl:otherwise>
						</xsl:choose>
						<div class="cart-buttons">
							<div></div>
							<div>
								<input name="step" value="3" type="hidden" />
								<button class="btn" type="submit">Продолжить</button>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="shop_delivery">
		<tr>
			<td class="text-align-left">
				<div class="pretty p-default p-curve">
					<input type="radio" value="{shop_delivery_condition/@id}" name="shop_delivery_condition_id">
						<xsl:if test="position() = 1">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<div class="state p-success-o">
						<label><xsl:value-of select="name"/></label>
					</div>
				</div>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="normalize-space(shop_delivery_condition/description) !=''">
						<xsl:value-of disable-output-escaping="yes" select="concat(description,' (',shop_delivery_condition/description,')')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="description"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:if test="shop_delivery_condition/price/node()">
					<xsl:value-of select="format-number(shop_delivery_condition/price, '### ##0,00', 'my')"/><xsl:text> </xsl:text><xsl:value-of select="/shop/shop_currency/sign"/>
				</xsl:if>
			</td>
			<td><xsl:value-of select="format-number(/shop/total_amount, '### ##0,00', 'my')"/><xsl:text> </xsl:text><xsl:value-of select="/shop/shop_currency/sign"/></td>
			<td class="total">
				<xsl:variable name="price">
					<xsl:choose>
						<xsl:when test="shop_delivery_condition/price/node()">
							<xsl:value-of select="shop_delivery_condition/price"/>
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:value-of select="format-number(/shop/total_amount + $price, '### ##0,00', 'my')"/><xsl:text> </xsl:text><xsl:value-of select="/shop/shop_currency/sign"/>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>