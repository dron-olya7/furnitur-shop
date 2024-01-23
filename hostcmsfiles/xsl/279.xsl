<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>
	
	<xsl:template match="/">
		<div class="row">
			<xsl:apply-templates select="siteuser"/>
		</div>
	</xsl:template>
	
	<xsl:template match="siteuser">
		<div class="col-12">
			<div class="box-user-content">
				<div class="user-licenses">
					<div class="row">
						<div class="col-12">
							<h1 class="title">Движение по лицевому счету</h1>
						</div>
					</div>
					
					<div class="row table-header">
						<div class="hidden-xs col-md-3">
							Дата
						</div>
						<div class="col-4 col-md-2">
							Сумма
						</div>
						<div class="hidden-xs col-md-2">
							В валюте магазина
						</div>
						<div class="col-4 col-md-2">
							Заказ
						</div>
						<div class="col-4 col-md-3">
							Описание
						</div>
					</div>
					
					<xsl:apply-templates select="shop[@id = 1]/shop_siteuser_transaction"/>
					
					<div class="row table-row">
						<div class="col-2">Остаток:</div>
						<div class="col-2 col-offset-2">
							<span class="hostcms-label third white">
								<xsl:value-of select="shop[@id = 1]/transaction_amount"/><xsl:text> </xsl:text><xsl:value-of select="shop/shop_currency/sign"/>
							</span>
						</div>
					</div>
				</div>
			</div>
		</div>
		
	</xsl:template>
	
	<!-- Шаблон для магазина -->
	<xsl:template match="shop_siteuser_transaction">
		<div class="row table-row">
			<div class="hidden-xs col-md-3">
				<xsl:value-of select="datetime" />
			</div>
			<div class="col-4 col-md-2">
				<xsl:value-of select="amount" />
				<xsl:text> </xsl:text>
				<xsl:value-of select="shop_currency/sign" />
			</div>
			<div class="hidden-xs col-md-2">
				<xsl:value-of select="amount_base_currency"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="../shop_currency/sign"/>
			</div>
			<div class="col-4 col-md-2">
				<xsl:choose>
					<xsl:when test="shop_order_id != 0">
						<xsl:value-of select="shop_order/invoice"/>
					</xsl:when>
					<xsl:otherwise>—</xsl:otherwise>
				</xsl:choose>
			</div>
			<div class="col-4 col-md-3">
				<xsl:value-of select="description"/>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>