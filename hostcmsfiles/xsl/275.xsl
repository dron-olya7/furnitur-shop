<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- Запишем в константу ID структуры, данные для которой будут выводиться пользователю -->
	<xsl:variable name="current_structure_id" select="/site/current_structure_id"/>

	<xsl:template match="/site">
		<!-- Выбираем узлы структуры первого уровня -->
		<div class="account-menu">
			<ul>
				<xsl:apply-templates select="structure[show=1]" />
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="structure">
		<li>
			<!--
			Выделяем текущую страницу добавлением к li класса current,
			если это текущая страница, либо у нее есть ребенок с атрибутом id, равным текущей группе.
			-->
			<xsl:if test="$current_structure_id = @id or count(.//structure[@id=$current_structure_id]) = 1">
				<xsl:attribute name="class">active</xsl:attribute>
			</xsl:if>

			<!-- Set $link variable -->
			<xsl:variable name="link">
				<xsl:choose>
					<!-- External link -->
					<xsl:when test="type = 3 and url != ''">
						<xsl:value-of disable-output-escaping="yes" select="url"/>
					</xsl:when>
					<!-- Internal link -->
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="link"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<a href="{$link}" title="{name}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="structure"><xsl:value-of select="name"/></a>
		</li>
	</xsl:template>
</xsl:stylesheet>