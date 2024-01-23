<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "lang://237">
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- МагазинИзбранноеКраткое -->

	<xsl:template match="/shop">
		<div id="little_favorite">
			<xsl:choose>
				<!-- Cart is empty -->
				<xsl:when test="count(shop_favorite) = 0">
					<div class="h1 cartTitle">
						<a href="{/shop/url}favorite/">Избранные товары отсутствуют!</a>
					</div>
					<p>Выберите товар и добавьте его в избранное</p>
				</xsl:when>
				<xsl:otherwise>
					<div class="h1 cartTitle">
						<a href="{/shop/url}favorite/">Избранное</a>
					</div>

					<xsl:variable name="totalQuantity" select="count(//shop_favorite)" />

					<p>
						В избранном <b><xsl:value-of select="$totalQuantity"/></b><xsl:text> </xsl:text>
						<xsl:call-template name="declension">
							<xsl:with-param name="number" select="$totalQuantity"/>
						</xsl:call-template>
					</p>

					<p><a href="{/shop/url}favorite/">Перейти в избранное →</a></p>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<!-- Declension of the numerals -->
	<xsl:template name="declension">

		<xsl:param name="number" select="number"/>

		<!-- Nominative case / Именительный падеж -->
		<xsl:variable name="nominative">
			<xsl:text>товар</xsl:text>
		</xsl:variable>

		<!-- Genitive singular / Родительный падеж, единственное число -->
		<xsl:variable name="genitive_singular">
			<xsl:text>товара</xsl:text>
		</xsl:variable>

		<xsl:variable name="genitive_plural">
			<xsl:text>товаров</xsl:text>
		</xsl:variable>

		<xsl:variable name="last_digit">
			<xsl:value-of select="$number mod 10"/>
		</xsl:variable>

		<xsl:variable name="last_two_digits">
			<xsl:value-of select="$number mod 100"/>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$last_digit = 1 and $last_two_digits != 11">
				<xsl:value-of select="$nominative"/>
			</xsl:when>
			<xsl:when test="$last_digit = 2 and $last_two_digits != 12 or $last_digit = 3 and $last_two_digits != 13 or $last_digit = 4 and $last_two_digits != 14">
				<xsl:value-of select="$genitive_singular"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$genitive_plural"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>