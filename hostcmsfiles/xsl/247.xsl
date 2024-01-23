<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:template match="/shop">
		<div class="wishlist">
			<span class="wishlist-title primary">
				<i class="fa fa-heart primary"></i> Избранное
			</span>

			<xsl:choose>
				<xsl:when test="count(shop_favorite)">
					<ul class="wishlist-list">
						<xsl:apply-templates select="shop_favorite[position() &lt; 4]/shop_item" />
					</ul>

					<a class="primary" href="/shop/favorite/">Все избранные</a><span class="badge wishlist-count"><xsl:value-of select="total"/></span>
				</xsl:when>
				<xsl:otherwise>
					<span class="wishlist-empty-text primary">
						<span>В избранном ничего нет.</span>
					</span>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="shop_item">
		<li class="wishlist-list-item">
			<div class="wishlist-item-img">
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
			<div class="wishlist-item-content">
				<a href="{url}" class="name"><xsl:value-of select="name"/></a>
				<span class="article"><xsl:value-of select="marking"/></span>
				<span class="price"><xsl:value-of select="price"/> ₽</span>
			</div>
			<div class="wishlist-item-delete">
				<a onclick="return $.addFavorite('/shop/favorite/', {@id}, this)"><i class="fa fa-times-circle-o primary"></i></a>
			</div>
		</li>
	</xsl:template>
</xsl:stylesheet>