<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>
	
	<xsl:template match="/">
		<div class="row">
			<xsl:apply-templates select="siteuser" />
		</div>
	</xsl:template>
	
	<xsl:template match="siteuser">
		<div class="col-12 margin-bottom-10">
			<h1 class="title">Дисконтные карты</h1>
		</div>
		
		<xsl:choose>
			<xsl:when test="count(//shop_discountcard)">
				<xsl:apply-templates select="//shop_discountcard" />
			</xsl:when>
			<xsl:otherwise>
				<div class="col-12">
					<div class="alert alert-warning">
						Дисконтные карты отсутствуют!
					</div>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="shop_discountcard">
		<div class="col-12">
			<span class="label label-success label-discountcard"><xsl:value-of select="number" /></span>
			<span class="discountcard-date">выдана <xsl:value-of select="date" /> г.</span>
		</div>
		
		<div class="col-12">
		<div class="discountcard-amount">Накоплено: <xsl:value-of select="round(amount)" /><xsl:text> </xsl:text><xsl:value-of select="../shop_currency/sign"/></div>
		</div>
		
		<xsl:variable name="outer-width" select="100 div count(../shop_discountcard_level)" />
		
		<div class="col-12 level-bar-container">
			<xsl:for-each select="../shop_discountcard_level">
				<xsl:variable name="amount">
					<xsl:choose>
						<xsl:when test="following-sibling::shop_discountcard_level[1]/amount &gt; 0">
							<xsl:value-of select="following-sibling::shop_discountcard_level[1]/amount" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="amount * 100" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:variable name="inner-width">
					<xsl:variable name="shop_discountcard" select="../shop_discountcard" />
					<xsl:variable name="id" select="@id" />
					
					<xsl:if test="$amount &gt; 0">
						<xsl:choose>
							<xsl:when test="$shop_discountcard/shop_discountcard_level/@id = $id">
								<xsl:value-of select="(../shop_discountcard/amount * 100) div $amount" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="(../shop_discountcard/amount - amount) * 100 div $amount" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:variable>
				
				<xsl:variable name="width">
					<xsl:choose>
						<xsl:when test="$inner-width &lt; 0">0</xsl:when>
						<xsl:when test="$inner-width &gt; 100">100</xsl:when>
						<xsl:otherwise><xsl:value-of select="$inner-width" /></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<div class="level-bar" style="width: {$outer-width}%">
				<div><xsl:value-of select="round(amount)"/><xsl:text> </xsl:text><xsl:value-of select="../shop_currency/sign"/></div>
					<div class="level-bar-inner" style="background-color: {color}; width: {$width}%;"></div>
					<div style="color: {color}"><xsl:value-of select="name"/></div>
				</div>
			</xsl:for-each>
		</div>
		
		<xsl:if test="bonuses/node() and bonuses/@max">
			<div class="row">
				<div class="col-12">
					<div class="bonuses-wrapper">
						<xsl:for-each select="bonuses/day">
							<xsl:variable name="bonus_value" select="."/>
							<xsl:variable name="height" select="round($bonus_value * 100 div ../@max)"/>
							
							<div class="bonuses-container">
								<div class="bonuses-bar series-none" style="flex-basis: {100 - $height}%"></div>
								<div class="bonuses-bar series-bonuses" style="flex-basis: {$height}%">
									<xsl:if test="$bonus_value &gt; 0">
										<div class="bonuses-value"><xsl:value-of select="$bonus_value" /></div>
									</xsl:if>
								</div>
								
								<div class="date"><xsl:value-of select="@date" /></div>
							</div>
						</xsl:for-each>
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>