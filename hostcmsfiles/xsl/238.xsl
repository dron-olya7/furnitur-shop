<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:template match="/form">
		<p style="margin-bottom: 40px"><img src="/admin/images/logo.gif" alt="(^) HostCMS" title="HostCMS"/></p>

		<h1><xsl:value-of select="name"/>, № <xsl:value-of select="form_fill/@id"/></h1>

		<xsl:if test="count(form_fill_field[form_field_dir_id = 0][value != ''])">
			<h2>Основной раздел</h2>

			<table cellspacing="2" cellpadding="5" border="0">
				<xsl:apply-templates select="form_fill_field[form_field_dir_id = 0][value != '']"/>
			</table>
		</xsl:if>

		<xsl:apply-templates select="form_field_dir"/>

		<table cellspacing="2" cellpadding="5" border="0">
			<tr>
				<td>Дата заполнения:</td>
				<td><strong><xsl:value-of select="form_fill/datetime"/></strong></td>
			</tr>
			<tr>
				<td>IP:</td>
				<td><strong><xsl:value-of select="form_fill/ip"/></strong></td>
			</tr>

			<xsl:if test="form_fill/source/node()">
				<xsl:apply-templates select="form_fill/source"/>
			</xsl:if>
		</table>
	</xsl:template>

	<xsl:template match="form_field_dir">
		<xsl:variable name="id" select="@id" />

		<xsl:if test="count(//form_fill_field[form_field_dir_id = $id][value != ''])">
			<h2><xsl:value-of select="name"/></h2>

			<table cellspacing="2" cellpadding="5" border="0">
				<xsl:apply-templates select="//form_fill_field[form_field_dir_id = $id][value != '']"/>
			</table>
		</xsl:if>
	</xsl:template>

	<xsl:template match="form_fill_field">
		<xsl:variable name="form_field_id" select="form_field_id" />
		<tr>
			<td><xsl:value-of select="//form_field[@id = $form_field_id]/caption"/>:</td>
			<td><strong><xsl:value-of select="value"/></strong></td>
		</tr>
	</xsl:template>

	<xsl:template match="source">
		<xsl:if test="service !=''">
			<tr>
				<td>Рекламный сервис:</td>
				<td><strong><xsl:value-of select="service"/></strong></td>
			</tr>
		</xsl:if>

		<xsl:if test="campaign !=''">
			<tr>
				<td>Название рекламной кампании:</td>
				<td><strong><xsl:value-of select="campaign"/></strong></td>
			</tr>
		</xsl:if>

		<xsl:if test="ad !=''">
			<tr>
				<td>Рекламное объявление:</td>
				<td><strong><xsl:value-of select="ad"/></strong></td>
			</tr>
		</xsl:if>

		<xsl:if test="source !=''">
			<tr>
				<td>Место размещения:</td>
				<td><strong><xsl:value-of select="source"/></strong></td>
			</tr>
		</xsl:if>

		<xsl:if test="medium !=''">
			<tr>
				<td>Средство маркетинга:</td>
				<td><strong><xsl:value-of select="medium"/></strong></td>
			</tr>
		</xsl:if>

		<xsl:if test="content !=''">
			<tr>
				<td>Дополнительная информация:</td>
				<td><strong><xsl:value-of select="content"/></strong></td>
			</tr>
		</xsl:if>

		<xsl:if test="term !=''">
			<tr>
				<td>Ключевые слова:</td>
				<td><strong><xsl:value-of select="term"/></strong></td>
			</tr>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>