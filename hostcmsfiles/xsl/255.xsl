<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:template match="/shop">
		<xsl:if test="count(shop_producer[image_small != ''])">
			<div class="brands-main">
				<div class="container">
					<div class="brands-slider js-slider-brands">
						<xsl:apply-templates select="shop_producer[image_small != '']" />
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="shop_producer">
		<div class="brands-slider-item">
			<a title="{name}" href="{/shop/url}producers/{path}/">
				<img data-src="{dir}{image_small}" class="lazyload" alt="{name}" />
			</a>
		</div>
	</xsl:template>
</xsl:stylesheet>