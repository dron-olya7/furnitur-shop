<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:template match="/">
		<xsl:apply-templates select="siteuser" />
	</xsl:template>

	<xsl:template match="siteuser">
		<h1>Дисконтные карты</h1>

		<table class="discountcard-table">
			<thead>
				<tr>
					<th>Номер</th>
					<th>Выдана</th>
					<th>Сумма</th>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates select="//shop_discountcard" />
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="shop_discountcard">
		<tr>
			<td><xsl:value-of select="number" /></td>
			<td><xsl:value-of select="date" /></td>
			<td><xsl:value-of select="amount" /><xsl:text> </xsl:text><xsl:value-of select="../shop_currency/sign" /></td>
		</tr>

		<xsl:if test="bonuses/node() and bonuses/@max">
			<tr>
				<td colspan="3">
					<div class="bonuses-wrapper">
						<xsl:for-each select="bonuses/day">
							<xsl:variable name="bonus_value" select="."/>
							<xsl:variable name="height" select="round($bonus_value * 100 div ../@max)"/>

							<div class="bonuses-container">
								<div class="bonuses-bar series-none" style="flex-basis: {100 - $height}%"></div>
								<div class="bonuses-bar series-bonuses" style="flex-basis: {$height}%">
									<xsl:if test="$bonus_value">
										<div class="bonuses-value"><xsl:value-of select="$bonus_value" /></div>
									</xsl:if>
								</div>

								<div class="date"><xsl:value-of select="@date" /></div>
							</div>
						</xsl:for-each>
					</div>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>