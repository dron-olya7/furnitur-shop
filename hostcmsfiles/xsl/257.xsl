<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- <xsl:include href="import://251"/> -->

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<xsl:template match="/shop">
		<xsl:if test="favorite/node()">
			<div class="favorite-main">
				<div class="container">
					<div class="section-title">
						<span class="h2">Избранное</span>
					</div>
					<div class="row">
						<div class="col-12">
							<div class="favorite-slider js-slider-favorite products-row">
								<xsl:if test="count(favorite//shop_item) &gt; 4">
									<xsl:attribute name="class">favorite-slider js-slider-favorite products-row four</xsl:attribute>
								</xsl:if>
								<xsl:apply-templates select="favorite/shop_item" />
							</div>
						</div>
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="shop_item">
		<xsl:variable name="id" select="@id" />
		<div class="product">
			<xsl:if test="discount != 0 or round(rest) = 0">
				<div class="product-labels">
					<xsl:if test="discount != 0">
						<div class="label label-discount">
							Скидка
							<xsl:choose>
								<xsl:when test="shop_discount/percent">
									<xsl:value-of disable-output-escaping="yes" select="round(shop_discount/percent)"/>%
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="shop_discount/value"/>
									<xsl:apply-templates select="/shop/shop_currency/code">
										<xsl:with-param name="value" select="price + discount" />
									</xsl:apply-templates>
								</xsl:otherwise>
							</xsl:choose>
						</div>
					</xsl:if>

					<xsl:if test="round(rest) = 0">
						<div class="label label-no-rest">Нет в наличии</div>
					</xsl:if>
				</div>
			</xsl:if>
			<div class="product-icons">
				<div id="wishlist{@id}" class="icon icon-favorite" onclick="return $.addFavorite('/shop/favorite/', {@id}, this)">
					<xsl:if test="/shop/favorite/shop_item[@id = $id]/node()">
						<xsl:attribute name="class">icon icon-favorite active</xsl:attribute>
					</xsl:if>
					<i class="fa fa-heart" title="Избранное"></i>
				</div>
			</div>
			<div class="product-img">
				<a title="{name}" href="{url}">
					<xsl:choose>
						<xsl:when test="image_small != ''">
							<img alt="{name}" src="{dir}{image_small}" />
						</xsl:when>
						<!-- Картинка родительского товара -->
						<xsl:when test="modification_id and shop_item/image_small != ''">
							<img alt="{name}" class="lazyload" data-src="{shop_item/dir}{shop_item/image_small}" />
						</xsl:when>
						<xsl:otherwise>
							<img data-src="/hostcmsfiles/assets/images/no-image.svg" class="lazyload" alt="{name}"/>
						</xsl:otherwise>
					</xsl:choose>
				</a>
			</div>
			<div class="product-description">
				<xsl:if test="comments_average_grade/node()">
					<div class="five-stars-container">
						<span class="five-stars" style="width: {comments_average_grade * 20}%"></span>
					</div>
				</xsl:if>
				<a href="{url}"><xsl:value-of select="name"/></a>
				<div class="clearfix"></div>
				<span class="product-price">
					<xsl:apply-templates select="/shop/shop_currency/code">
						<xsl:with-param name="value" select="price" />
					</xsl:apply-templates>
					<xsl:if test="discount != 0">
						<span class="old-price small">
							<xsl:apply-templates select="/shop/shop_currency/code">
								<xsl:with-param name="value" select="price + discount" />
							</xsl:apply-templates>
						</span>
					</xsl:if>
				</span>
			</div>
			<div class="product-cart">
				<a class="btn" onclick="return $.bootstrapAddIntoCart('{/shop/url}cart/', {@id}, 1)">В корзину</a>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="shop_currency/code">
		<xsl:param name="value" />

		<xsl:variable name="spaced" select="format-number($value, '# ###', 'my')" />

		<xsl:choose>
			<xsl:when test=". = 'USD'">$<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'EUR'">€<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'GBP'">£<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'RUB'"><xsl:value-of select="$spaced"/> ₽</xsl:when>
			<xsl:when test=". = 'AUD'">AU$<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'CNY'"><xsl:value-of select="$spaced"/>元</xsl:when>
			<xsl:when test=". = 'JPY'"><xsl:value-of select="$spaced"/>¥</xsl:when>
			<xsl:when test=". = 'KRW'"><xsl:value-of select="$spaced"/>₩</xsl:when>
			<xsl:when test=". = 'PHP'"><xsl:value-of select="$spaced"/>₱</xsl:when>
			<xsl:when test=". = 'THB'"><xsl:value-of select="$spaced"/>฿</xsl:when>
			<xsl:when test=". = 'BRL'">R$<xsl:value-of select="$spaced"/></xsl:when>
		<xsl:when test=". = 'INR'"><xsl:value-of select="$spaced"/><i class="fa fa-inr"></i></xsl:when>
		<xsl:when test=". = 'TRY'"><xsl:value-of select="$spaced"/><i class="fa fa-try"></i></xsl:when>
		<xsl:when test=". = 'ILS'"><xsl:value-of select="$spaced"/><i class="fa fa-ils"></i></xsl:when>
			<xsl:otherwise><xsl:value-of select="$spaced"/> <xsl:value-of select="." /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>