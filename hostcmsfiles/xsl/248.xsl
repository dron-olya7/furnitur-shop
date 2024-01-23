<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>
	
	<xsl:template match="/shop">
		<div class="compare">
			<span class="compare-title third">
				<i class="fa fa-balance-scale third"></i> Сравнение
			</span>
			
			<xsl:choose>
				<xsl:when test="count(shop_compare)">
					<ul class="compare-list">
						<xsl:apply-templates select="shop_compare[position() &lt; 4]/shop_item" />
					</ul>
					
				<a class="third" href="{url}compare/">Сравнить</a><span class="badge compare-count"><xsl:value-of select="total"/></span>
				</xsl:when>
				<xsl:otherwise>
					<span class="compare-empty-text third">
						<span>Нет товаров для сравнения.</span>
					</span>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	
	<xsl:template match="shop_item">
		<li class="compare-list-item">
			<div class="compare-item-img">
				<a href="{url}">
					<xsl:choose>
						<xsl:when test="image_small !=''">
							<img src="{dir}{image_small}" alt="{name}"/>
						</xsl:when>
						<xsl:otherwise>
							<img src="/hostcmsfiles/assets/images/no-image.svg" alt="{name}"/>
						</xsl:otherwise>
					</xsl:choose>
				</a>
			</div>
			<div class="compare-item-content">
				<a href="{url}" class="name"><xsl:value-of select="name"/></a>
				<span class="article"><xsl:value-of select="marking"/></span>
				<span class="price"><xsl:value-of select="price"/> ₽</span>
			</div>
			<div class="compare-item-delete">
			<a onclick="return $.addCompare('{/shop/url}compare/', {@id}, this)"><i class="fa fa-times-circle-o primary"></i></a>
			</div>
		</li>
	</xsl:template>
</xsl:stylesheet>