<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:template match="/shop">
		<div class="categories-row">
			<h2>Категории</h2>

			<ul class="categories-menu">
				<xsl:apply-templates select="shop_group">
					<xsl:with-param name="level" select="1"/>
				</xsl:apply-templates>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="shop_group">
		<xsl:param name="level"/>

		<li>
			<xsl:if test="@id = /shop/current_group_id">
				<xsl:attribute name="class">active</xsl:attribute>
			</xsl:if>

			<a href="{url}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_group" class="categories-menu-link" style="padding-left: {$level * 15}px">
				<span><xsl:text>›</xsl:text></span>
				<span class="text"><xsl:value-of select="name"/></span>

				<xsl:if test="items_count &gt; 0">
					<span class="badge badge-light"><xsl:value-of select="items_total_count"/></span>
				</xsl:if>
			</a>

			<xsl:if test="count(shop_group)">
				<ul class="categories-menu">
					<xsl:apply-templates select="shop_group">
						<xsl:with-param name="level" select="$level + 1"/>
					</xsl:apply-templates>
				</ul>
			</xsl:if>
		</li>
	</xsl:template>
</xsl:stylesheet>