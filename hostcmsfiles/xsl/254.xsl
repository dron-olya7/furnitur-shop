<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:template match="/informationsystem">
		<div class="services-main">
			<div class="container">
				<h2 class="title"><xsl:value-of select="name"/></h2>

				<xsl:apply-templates select="informationsystem_item" />
			</div>
		</div>
	</xsl:template>

	<xsl:template match="informationsystem_item">
		<div class="services-block">
			<xsl:if test="position() mod 2 = 0">
				<xsl:attribute name="class">services-block services-block-right</xsl:attribute>
			</xsl:if>
			<div class="image">
				<a href="{url}" title="{name}">
					<xsl:choose>
						<xsl:when test="image_small != ''">
							<img alt="{name}" class="lazyload" data-src="{dir}{image_small}" />
						</xsl:when>
						<xsl:otherwise><img data-src="/hostcmsfiles/assets/images/no-image.svg" class="lazyload" alt="{name}"/></xsl:otherwise>
					</xsl:choose>
				</a>
			</div>
			<div class="details">
				<h3 class="title"><a href="{url}"><xsl:value-of select="name"/></a></h3>
				<span><xsl:value-of disable-output-escaping="yes" select="description"/></span>
				<a href="{url}" class="btn btn-sm">Подробнее</a>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>