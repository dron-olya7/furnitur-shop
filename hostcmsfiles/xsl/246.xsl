<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>
	
	<xsl:template match="/site">
		<div class="navbar navbar-expand-lg">
			<div id="navbar-nav-lists" class="d-none d-lg-block">
			<a href="#" class="popup-close d-none"><xsl:text disable-output-escaping="yes">&amp;</xsl:text>times;</a>
				
				<ul class="navbar-nav">
					<xsl:apply-templates select="structure[type != 3][show = 1]" mode="main" />
					
					<!-- Узлы с типом "Ссылка" -->
					<xsl:if test="count(structure[type = 3][url != ''][show = 1])">
						<li class="divider divider-min"></li>
						<xsl:apply-templates select="structure[type = 3][url != ''][show = 1]" mode="min" />
					</xsl:if>
				</ul>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="structure" mode="main">
		<li class="nav-item">
			<xsl:choose>
				<xsl:when test="shop_group/node()">
					<xsl:attribute name="class">nav-item dropdown</xsl:attribute>
					
					<a class="navbar-nav-link dropdown-toggle" data-toggle="dropdown" aria-expanded="false" href="{link}" title="{name}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="structure">
						<i class="fa fa-bars mr-1"></i> <xsl:value-of select="name"/>
					</a>
					
					<div class="dropdown-menu">
						<!-- Группы -->
						<xsl:apply-templates select="shop_group" />
						
						<a href="/shop/" class="dropdown-item font-weight-bold">Все категории</a>
						<div class="dropdown-divider"></div>
						
						
						<!-- <a href="/shop/price/" class="dropdown-item">Прайс-лист</a> -->
						<xsl:apply-templates select="structure[show = 1]" />
						<div class="dropdown-menu-triangle"></div>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<a class="navbar-nav-link" href="{link}" title="{name}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="structure">
						<xsl:value-of select="name"/>
					</a>
				</xsl:otherwise>
			</xsl:choose>
		</li>
	</xsl:template>
	
	<xsl:template match="shop_group">
		<xsl:if test="shop_group/node()">
			<xsl:text disable-output-escaping="yes">&lt;div class="dropdown-submenu"&gt;</xsl:text>
		</xsl:if>
		
		<a class="dropdown-item" href="{link}">
			<xsl:if test="shop_group/node()">
				<xsl:attribute name="class">dropdown-item dropdown-toggle</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="name"/>
		</a>
		
		<xsl:if test="shop_group/node()">
			<div class="dropdown-menu">
				<!-- Подгруппы -->
				<xsl:apply-templates select="shop_group" />
			</div>
			
			<xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="structure" mode="min">
		<li class="nav-item nav-item-min">
			<a class="navbar-nav-link" href="{url}" title="{name}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="structure">
				<xsl:value-of select="name"/>
			</a>
		</li>
	</xsl:template>
	
	<xsl:template match="structure">
		<a href="{link}" class="dropdown-item"><xsl:value-of select="name"/></a>
	</xsl:template>
</xsl:stylesheet>