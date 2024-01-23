<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "lang://236">
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<xsl:template match="/">
		<xsl:apply-templates select="shop"/>
	</xsl:template>

	<xsl:variable name="n" select="number(3)"/>

	<xsl:template match="shop">
		<xsl:choose>
			<xsl:when test="count(shop_favorite) &gt; 0">
				<div class="shop_block">
					<div class="shop_table">
						<!-- Выводим товары магазина -->
						<xsl:apply-templates select="shop_favorite" />
					</div>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<p class="h2">Избранные товары отсутствуют!</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Шаблон для товара -->
	<xsl:template match="shop_favorite">
		<div class="shop_item">
			<div class="shop_table_item">
				<div class="image_row">
					<div class="image_cell">
						<a href="{shop_item/url}">
							<xsl:choose>
								<xsl:when test="shop_item/image_small != ''">
									<img src="{shop_item/dir}{shop_item/image_small}" alt="{shop_item/name}" title="{shop_item/name}"/>
								</xsl:when>
								<xsl:otherwise>
									<img src="/images/no-image.png" alt="{shop_item/name}" title="{shop_item/name}"/>
								</xsl:otherwise>
							</xsl:choose>
						</a>
					</div>
				</div>
				<div class="description_row">
					<div class="description_sell">
						<p>
							<a href="{shop_item/url}" title="{shop_item/name}" hostcms:id="{shop_item/@id}" hostcms:field="name" hostcms:entity="shop_item">
								<xsl:value-of disable-output-escaping="yes" select="shop_item/name"/>
							</a>
						</p>
						<div class="price">
							<xsl:value-of select="format-number(shop_item/price, '### ##0,00', 'my')"/><xsl:text> </xsl:text><xsl:value-of select="shop_item/currency"/><xsl:text> </xsl:text>

							<xsl:if test="count(shop_item/shop_bonuses/shop_bonus)">
								<div class="item-bonuses">
									+<xsl:value-of select="shop_item/shop_bonuses/total" /> бонусов
								</div>
							</xsl:if>

							<!-- Ссылку на добавление в корзины выводим, если:
							type = 0 - простой тип товара
							type = 1 - электронный товар, при этом остаток на складе больше 0 или -1,
							что означает неограниченное количество -->
							<xsl:if test="shop_item/type = 0 or (shop_item/type = 1 and (shop_item/digitals > 0 or shop_item/digitals = -1)) or shop_item/type = 2">
								<div style="margin: 5px 0 15px 0">
										<a href="{/shop/url}cart/?add={@id}" onclick="return $.addIntoCart('{/shop/url}cart/', {@id}, 1)" class="button2 white medium">
											Купить →
										</a>
								</div>
							</xsl:if>
						</div>
					</div>
				</div>
			</div>
		</div>

		<xsl:if test="position() mod 3 = 0 and position() != last()">
			<span class="table_row"></span>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>