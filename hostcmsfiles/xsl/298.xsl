<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:template match="/shop">
		<div class="navbar navbar-expand-lg categories-navbar">
			<div class="container">
				<div id="navbar-nav-lists" class="">
					<a href="#" class="popup-close d-none"><xsl:text disable-output-escaping="yes">&amp;</xsl:text>times;</a>

					<ul class="navbar-nav">
						<xsl:apply-templates select="shop_group[parent_id = 0][position() &lt; 9]" mode="main"/>
					</ul>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="shop_group" mode="main">
		<xsl:variable name="group" select="/shop/current_group_id" />

		<li class="nav-item">
			<xsl:if test="shop_group/node()">
				<xsl:attribute name="class">nav-item dropdown</xsl:attribute>
			</xsl:if>

			<a class="navbar-nav-link" href="{url}" title="{name}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_group">
				<xsl:attribute name="class">
					<xsl:choose>
						<!-- <xsl:when test="($group = @id and count(.//shop_group[@id = $group]) = 0) and shop_group/node()">1 navbar-nav-link dropdown-toggle</xsl:when> -->
						<xsl:when test="($group = @id or count(.//shop_group[@id = $group]) = 1) and shop_group/node()">2 navbar-nav-link dropdown-toggle current</xsl:when>
						<xsl:when test="$group = @id or count(.//shop_group[@id = $group]) = 1">3 navbar-nav-link current</xsl:when>
						<xsl:when test="shop_group/node()">4 navbar-nav-link dropdown-toggle</xsl:when>
						<xsl:otherwise>navbar-nav-link</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:if test="shop_group/node()">
					<xsl:attribute name="data-toggle">dropdown</xsl:attribute>
					<xsl:attribute name="aria-expanded">false</xsl:attribute>
					<!-- <i class="fa fa-bars mr-1"></i><xsl:text> </xsl:text> -->
				</xsl:if>

				<xsl:value-of select="name"/>
			</a>

			<xsl:if test="shop_group/node()">
				<div class="dropdown-menu">
					<!-- Группы -->
					<xsl:apply-templates select="shop_group" mode="sub"/>
				</div>
			</xsl:if>
		</li>
	</xsl:template>

	<xsl:template match="shop_group" mode="sub">
		<xsl:if test="shop_group/node()">
			<xsl:text disable-output-escaping="yes">&lt;div class="dropdown-submenu"&gt;</xsl:text>
		</xsl:if>

		<a class="dropdown-item" href="{url}">
			<xsl:if test="shop_group/node()">
				<xsl:attribute name="class">dropdown-item dropdown-toggle</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="name"/>
		</a>

		<xsl:if test="shop_group/node()">
			<div class="dropdown-menu">
				<!-- Подгруппы -->
				<xsl:apply-templates select="shop_group" mode="sub" />
			</div>

			<xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>