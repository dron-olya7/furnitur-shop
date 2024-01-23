<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:template match="/site">
		<xsl:variable name="deal_template_id" select="deal_template_id"/>

		<h1>Добавление сделки</h1>

		<div class="comment">
			<form action="{path}" method="post" enctype="multipart/form-data">
				<div class="row">
					<div class="caption">Название</div>
					<div class="field">
						<input name="name" type="text" value="" size="40"/> *
					</div>
				</div>

				<div class="row">
					<div class="caption">Описание</div>
					<div class="field">
						<textarea name="description" type="text" value=""/>
					</div>
				</div>

				<!-- Внешние параметры -->
				<xsl:if test="count(deal_templates/deal_template[@id = $deal_template_id]/deal_properties/property[type != 2])">
					<xsl:apply-templates select="deal_templates/deal_template[@id = $deal_template_id]/deal_properties/property[type != 2]"/>
				</xsl:if>

				<input type="hidden" name="deal_template_id" value="{$deal_template_id}"/>

				<div class="row">
					<div class="caption"></div>
					<div class="field">
						<input name="add" value="Добавить" type="submit" class="button" />
					</div>
				</div>
			</form>
		</div>
	</xsl:template>

	<!-- Внешние свойства -->
	<xsl:template match="deal_properties/property">

		<xsl:if test="type != 10">
			<xsl:variable name="id" select="@id" />
			<!-- <xsl:variable name="property_value" select="/siteuser/property_value[property_id=$id]" /> -->

			<div class="row">
				<div class="caption"><xsl:value-of select="name" /></div>
				<div class="field">

					<xsl:choose>
						<!-- Отображаем поле ввода -->
						<xsl:when test="type = 0 or type=1">
							<br/>
							<input type="text" name="property_{@id}" value="" size="40" />
						</xsl:when>
						<!-- Отображаем файл -->
						<xsl:when test="type = 2">
							<br/>
							<input type="file" name="property_{@id}" size="35" />
						</xsl:when>
						<!-- Отображаем список -->
						<xsl:when test="type = 3">
							<br/>
							<select name="property_{@id}">
								<option value="0">...</option>
								<xsl:apply-templates select="list/list_item"/>
							</select>
						</xsl:when>
						<!-- Большое текстовое поле, Визуальный редактор -->
						<xsl:when test="type = 4 or type = 6">
							<br/>
							<textarea name="property_{@id}" size="40"/>
						</xsl:when>
						<!-- Флажок -->
						<xsl:when test="type = 7">
							<br/>
							<input type="checkbox" name="property_{@id}">
							</input>
						</xsl:when>
					</xsl:choose>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="list/list_item">
		<!-- Отображаем список -->
		<xsl:variable name="id" select="../../@id" />
		<option value="{@id}">
			<xsl:value-of disable-output-escaping="yes" select="value"/>
		</option>
	</xsl:template>
</xsl:stylesheet>