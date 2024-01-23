<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:template match="/shop">
		<span class="footer-lists-item-title"><a href="#">Каталог</a></span>
		<ul class="flex">
			<xsl:apply-templates select="shop_group[active = 1][position() &lt; 10]" />
			<li><a href="{url}" class="footer-link">Все категории</a></li>
	   </ul>
	</xsl:template>

	<xsl:template match="shop_group">
		<li><a href="{url}" class="footer-link"><xsl:value-of select="name" /></a></li>
	</xsl:template>
</xsl:stylesheet>