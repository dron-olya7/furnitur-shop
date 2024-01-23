<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:template match="/informationsystem">
		<div class="news-main">
			<div class="container">
				<div class="section-title">
					<span class="h2">Новости</span>
					<a href="{url}">Все новости</a>
				</div>
				<ul class="news-list">
					<xsl:apply-templates select="informationsystem_item[active=1]" />
				</ul>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="informationsystem_item">
		<li class="news-list-item">
			<div class="img">
				<a href="{url}">
					<xsl:choose>
						<xsl:when test="image_small != ''">
							<img class="img-fluid" alt="{name}" src="{dir}{image_small}" />
						</xsl:when>
						<xsl:otherwise><img class="img-fluid lazyload" data-src="/hostcmsfiles/assets/images/no-image.svg" alt="{name}"/></xsl:otherwise>
					</xsl:choose>
				</a>

				<div class="info">
					<xsl:if test="count(/informationsystem//informationsystem_group[@id = $group_id])">
						<span class="group-name"><a href="{/informationsystem//informationsystem_group[@id = $group_id]/url}"><xsl:value-of select="/informationsystem//informationsystem_group[@id = $group_id]/name" /></a></span>
					</xsl:if>

					<span class="showed"><i class="fa fa-eye"></i><xsl:value-of select="showed"/></span>

					<span class="comments"><i class="fa fa-comments-o"></i><xsl:value-of select="comments_count"/></span>
				</div>
			</div>
			<span class="date">
				<xsl:value-of select="substring-before(date, '.')"/>
				<xsl:variable name="month_year" select="substring-after(date, '.')"/>
				<xsl:variable name="month" select="substring-before($month_year, '.')"/>
				<xsl:choose>
					<xsl:when test="$month = 1"> января </xsl:when>
					<xsl:when test="$month = 2"> февраля </xsl:when>
					<xsl:when test="$month = 3"> марта </xsl:when>
					<xsl:when test="$month = 4"> апреля </xsl:when>
					<xsl:when test="$month = 5"> мая </xsl:when>
					<xsl:when test="$month = 6"> июня </xsl:when>
					<xsl:when test="$month = 7"> июля </xsl:when>
					<xsl:when test="$month = 8"> августа </xsl:when>
					<xsl:when test="$month = 9"> сентября </xsl:when>
					<xsl:when test="$month = 10"> октября </xsl:when>
					<xsl:when test="$month = 11"> ноября </xsl:when>
					<xsl:otherwise> декабря </xsl:otherwise>
				</xsl:choose>
				<xsl:value-of select="substring-after($month_year, '.')"/><xsl:text> г.</xsl:text>
			</span>
			<span class="title"><a href="{url}"><xsl:value-of select="name" /></a></span>
			<!-- <span class="text"><xsl:value-of disable-output-escaping="yes" select="description" /></span> -->
		</li>
	</xsl:template>
</xsl:stylesheet>