<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "lang://276">
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<xsl:template match="/siteuser">
		<div class="account-info">
			<ul>
				<li>
					<i class="fa fa-envelope fa-fw" title="E-mail"></i>
					<xsl:choose>
						<xsl:when test="email != ''"><xsl:value-of select="email"/></xsl:when>
						<xsl:otherwise>—</xsl:otherwise>
					</xsl:choose>
				</li>
				<li>
					<i class="fa fa-phone fa-fw" title="Телефон"></i>
					<xsl:choose>
						<xsl:when test="phone != ''"><xsl:value-of select="phone"/></xsl:when>
						<xsl:otherwise>—</xsl:otherwise>
					</xsl:choose>
				</li>
				<li>
					<i class="fa fa-user-o fa-fw" title="Дата регистрации"></i><xsl:value-of select="date"/><xsl:text> г.</xsl:text>
				</li>
				<li>
					<i class="fa fa-usd fa-fw" title="Баланс"></i>
					<xsl:choose>
						<xsl:when test="account/shop/node()">
							<xsl:value-of select="account/shop/transaction_amount"/><xsl:text> </xsl:text><xsl:value-of select="account/shop/shop_currency/sign"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="account/transaction_amount"/><xsl:text> </xsl:text><xsl:value-of select="/shop/shop_currency/sign"/>
						</xsl:otherwise>
					</xsl:choose>
				</li>
				<li>
					<i class="fa fa-credit-card fa-fw" title="Бонусы"></i>
					<a href="/users/discountcards/">
						<xsl:choose>
							<xsl:when test="account/shop/node()">
								<xsl:value-of select="account/shop/bonuses_amount"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="account/bonuses_amount"/>
							</xsl:otherwise>
						</xsl:choose>
					</a>
				</li>
			</ul>
		</div>
		<a href="/users/?action=exit" class="btn btn-transparent">Выход</a>
	</xsl:template>
</xsl:stylesheet>