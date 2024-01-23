<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<xsl:template match="/shop">
		<div class="promos">
			<div class="promo-row two-col">
				<xsl:apply-templates select="shop_item">
					<xsl:sort select="property_value[tag_name = 'promo_img']/file_description" data-type="number" order="ascending" />
				</xsl:apply-templates>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="shop_item">
		<div>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="position() = 1">promo left-top</xsl:when>
					<xsl:when test="position() = 2">promo right-bottom</xsl:when>
					<xsl:when test="position() = 3">promo right-center</xsl:when>
					<xsl:when test="position() = 4">promo right-top</xsl:when>
					<xsl:when test="position() = 5">promo left-center</xsl:when>
				</xsl:choose>
			</xsl:attribute>

			<xsl:if test="image_small != ''">
				<a href="{url}">
					<xsl:choose>
						<xsl:when test="property_value[tag_name = 'promo_img']/file != ''">
							<img data-src="{dir}{property_value[tag_name = 'promo_img']/file}" class="lazyload" alt="{name}" title="{name}"/>
						</xsl:when>
						<xsl:otherwise>
							<img data-src="{dir}{image_small}" class="lazyload"/>
						</xsl:otherwise>
					</xsl:choose>
				</a>
			</xsl:if>

			<div class="caption">
				<div class="title"><a href="{url}"><xsl:value-of select="name"/></a></div>
				<div class="marking"><xsl:value-of select="marking"/></div>
				<div class="price">
					<xsl:variable name="price">
						<xsl:choose>
							<xsl:when test="discount != 0"><xsl:value-of select="price + discount" /></xsl:when>
							<xsl:otherwise><xsl:value-of select="price" /></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:apply-templates select="/shop/shop_currency/code">
						<xsl:with-param name="value" select="$price" />
					</xsl:apply-templates>
				</div>
			</div>
		</div>

		<xsl:if test="position() = 2 and position() != last()">
			<xsl:text disable-output-escaping="yes">
				&lt;/div&gt;
				&lt;div class="promo-row three-col"&gt;
			</xsl:text>
		</xsl:if>
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