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
		<!-- Right block -->
		<div class="col-12">
			<div class="box-user-content">
				<div class="user-licenses">
					<div class="row">
						<div class="col-12">
							<h1 class="title">Лицевой счет</h1>
						</div>
					</div>
					<div class="row table-header">
						<div class="col-6 col-md-2">
							Сумма
						</div>
						<div class="col-6 col-md-4">
							Магазин
						</div>
						<div class="d-none d-sm-block col-md-3"></div>
						<div class="d-none d-sm-block col-md-3"></div>
					</div>

					<xsl:apply-templates select="shop"/>
				</div>
			</div>
		</div>
	</xsl:template>

	<!-- Шаблон для магазина -->
	<xsl:template match="shop">
		<div class="row table-row">
			<div class="col-6 col-md-2">
				<xsl:value-of select="transaction_amount"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="shop_currency/sign" disable-output-escaping="yes"/>
			</div>
			<div class="col-6 col-md-4">
				<xsl:value-of select="name"/>
			</div>
			<div class="col-6 col-md-3 mt-2 mt-md-0">
				<a href="pay/{@id}/" class="hostcms-label secondary white">Пополнить счет</a>
			</div>
			<div class="col-6 col-md-3 mt-2 mt-md-0">
				<a href="shop-{@id}/" class="hostcms-label third white">История</a>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>