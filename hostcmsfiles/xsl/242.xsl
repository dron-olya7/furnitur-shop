<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:template match="/site">
		<script type="text/javascript">
			<xsl:comment>
				<xsl:text disable-output-escaping="yes">
				<![CDATA[
					$(function() {
						$('.add_deal').on('click', function(){
							window.location.href = '/users/deals/addDeal/' + $('select[name = "deal_template_id"]').val();
						});
					});
				]]>
				</xsl:text>
			</xsl:comment>
		</script>

		<div class="comment">
			<div style="text-align: center;">
				<select name="deal_template_id">
					<xsl:apply-templates select="/site/deal_templates/deal_template" />
				</select>

				<p class="button add_deal">Добавить</p>
			</div>
		</div>

		<xsl:apply-templates select="deal" />
	</xsl:template>

	<xsl:template match="deal">
		<div>
			<h1><xsl:value-of select="name" /></h1>

			<xsl:if test="description != ''">
				<div class="tags"><xsl:value-of disable-output-escaping="yes" select="description" /></div>
			</xsl:if>
		</div>

		<xsl:if test="deal_template_id &gt; 0">
			<xsl:variable name="deal_template_id" select="deal_template_id" />
			<xsl:variable name="deal_template" select="/site/deal_templates//deal_template[@id = $deal_template_id]" />

			<div style="color: {$deal_template/color}">Тип: <xsl:value-of select="$deal_template/name" /></div>

			<xsl:if test="deal_template_step_id &gt; 0">
				<xsl:variable name="deal_template_step_id" select="deal_template_step_id" />
				<xsl:variable name="deal_template_step" select="$deal_template//deal_template_step[@id = $deal_template_step_id]" />

				<div style="color: {$deal_template_step/color}">Этап: <xsl:value-of select="$deal_template_step/name" /></div>
			</xsl:if>
		</xsl:if>

		<xsl:if test="count(deal_attachment)">
			<div>
				<h3>Загруженные файлы</h3>
				<xsl:apply-templates select="deal_attachment" />
			</div>
		</xsl:if>

		<hr/>
	</xsl:template>

	<xsl:template match="deal_attachment">
		<p><img src="/images/li2.gif"/><xsl:text> </xsl:text><xsl:value-of select="file_path" /></p>
	</xsl:template>

	<xsl:template match="deal_template">
		<option value="{@id}"><xsl:value-of select="name" /></option>
	</xsl:template>

</xsl:stylesheet>