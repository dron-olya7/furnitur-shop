<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:template match="/shop">
		<div class="tags-row">
			<h2>Теги</h2>
			<div class="tag-list">
				<xsl:apply-templates select="tag" />
			</div>
		</div>
	</xsl:template>

	<xsl:template match="tag">
		<a href="{/shop/url}tag/{urlencode}/">
			<xsl:value-of select="name"/>
		</a>
	</xsl:template>

</xsl:stylesheet>