<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>
	
	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>
	
	<xsl:template match="/shop">
		<xsl:variable name="totalQuantity" select="sum(shop_cart[postpone = 0]/quantity)" />
		<input type="hidden" name="total_quantity" value="{$totalQuantity}"/>
		
		<span class="little-cart-title">Корзина</span>
	<span class="popup-close"><xsl:text disable-output-escaping="yes">&amp;</xsl:text>times;</span>
		
		<ul class="little-cart-list">
			<xsl:apply-templates select="shop_cart[postpone = 0]/shop_item" />
		</ul>
		
		<xsl:choose>
			<!-- В корзине нет ни одного элемента -->
			<xsl:when test="count(shop_cart[postpone = 0]) = 0">
				<div class="alert alert-primary alert-little-cart" role="alert">
					В корзине нет ни одного товара
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div class="mt-5">
					<xsl:if test="count(shop_purchase_discount) or shop_discountcard/node() or apply_bonuses/node()">
						<xsl:apply-templates select="shop_purchase_discount"/>
						<xsl:apply-templates select="shop_discountcard"/>
						<xsl:if test="siteuser_id > 0 and apply_bonuses/node()">
							<span class="little-cart-total">
							Бонусы<xsl:text>: </xsl:text>
								<xsl:apply-templates select="/shop/shop_currency/code">
									<xsl:with-param name="value" select="$available_bonuses * -1" />
								</xsl:apply-templates>
							</span>
						</xsl:if>
					</xsl:if>
					<span class="little-cart-total mt-2">Итого:<xsl:text> </xsl:text><span class="font-weight-bold">
							<xsl:apply-templates select="/shop/shop_currency/code">
								<xsl:with-param name="value" select="total_amount" />
							</xsl:apply-templates>
					</span></span>
					<div class="little-cart-btn">
						<a href="{/shop/url}cart/" class="btn">Перейти в корзину</a>
					</div>
				</div>
			</xsl:otherwise>
		</xsl:choose>
		
		<script>
			<xsl:comment>
				<xsl:text disable-output-escaping="yes">
					<![CDATA[
					if (window.jQuery) {
					$(function(){
					var totalQuantity = parseInt($('input[name=total_quantity]').val());
					if (totalQuantity)
					{
					$('.little-cart-icon .little-cart-icon-badge')
					.text(totalQuantity)
					.removeClass('d-none');
					}
					else
					{
					$('.little-cart-icon .little-cart-icon-badge').addClass('d-none');
					}
					});
					}
					]]>
				</xsl:text>
			</xsl:comment>
		</script>
	</xsl:template>
	
	<!-- Шаблон для скидки от суммы заказа -->
	<xsl:template match="shop_purchase_discount">
		<span class="little-cart-total">
			<xsl:value-of select="name"/><xsl:text>: </xsl:text>
			<b>
				<xsl:apply-templates select="/shop/shop_currency/code">
					<xsl:with-param name="value" select="discount_amount * -1" />
				</xsl:apply-templates>
			</b>
		</span>
	</xsl:template>
	
	<xsl:template match="shop_discountcard">
		<span class="little-cart-total">
		Дисконтная карта <xsl:value-of select="number"/><xsl:text>: </xsl:text>
			<b>
				<xsl:apply-templates select="/shop/shop_currency/code">
					<xsl:with-param name="value" select="discount_amount * -1" />
				</xsl:apply-templates>
			</b>
		</span>
		<br/>
	</xsl:template>
	
	<xsl:template match="shop_item">
		<li id="{@id}" class="little-cart-item">
			<div class="little-cart-item-img">
				<a title="{name}" href="{url}">
					<xsl:choose>
						<xsl:when test="image_small != ''">
							<img alt="{name}" src="{dir}{image_small}" />
						</xsl:when>
						<!-- Картинка родительского товара -->
						<xsl:when test="modification_id and shop_item/image_small != ''">
							<img alt="{name}" src="{shop_item/dir}{shop_item/image_small}" />
						</xsl:when>
						<xsl:otherwise><img src="/hostcmsfiles/assets/images/no-image.svg" alt="{name}"/></xsl:otherwise>
					</xsl:choose>
				</a>
			</div>
			<div class="little-cart-item-content">
				<a href="{url}" class="name"><xsl:value-of select="name"/></a>
				<span class="article"><xsl:value-of select="marking"/></span>
				<span class="price">
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
			<span class="quantity"><xsl:value-of select="../quantity"/><xsl:text> </xsl:text><xsl:value-of select="shop_measure/name"/></span>
				<hr class="m-0 w-50"/>
				<span class="price">
					<xsl:apply-templates select="/shop/shop_currency/code">
						<xsl:with-param name="value" select="../quantity * price" />
					</xsl:apply-templates>
				</span>
			</div>
			<div class="little-cart-item-delete">
			<a onclick="$.deleteLittleCart('{/shop/url}cart/', {@id})"><i class="fa fa-times-circle-o primary"></i></a>
			</div>
		</li>
	</xsl:template>
	
	<!-- Declension of the numerals -->
	<xsl:template name="declension">
		
		<xsl:param name="number" select="number"/>
		
		<!-- Nominative case / Именительный падеж -->
		<xsl:variable name="nominative">
			<xsl:text>товар</xsl:text>
		</xsl:variable>
		
		<!-- Genitive singular / Родительный падеж, единственное число -->
		<xsl:variable name="genitive_singular">
			<xsl:text>товара</xsl:text>
		</xsl:variable>
		
		
		<xsl:variable name="genitive_plural">
			<xsl:text>товаров</xsl:text>
		</xsl:variable>
		
		<xsl:variable name="last_digit">
			<xsl:value-of select="$number mod 10"/>
		</xsl:variable>
		
		<xsl:variable name="last_two_digits">
			<xsl:value-of select="$number mod 100"/>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$last_digit = 1 and $last_two_digits != 11">
				<xsl:value-of select="$nominative"/>
			</xsl:when>
			<xsl:when test="$last_digit = 2 and $last_two_digits != 12     or     $last_digit = 3 and $last_two_digits != 13     or     $last_digit = 4 and $last_two_digits != 14">
				<xsl:value-of select="$genitive_singular"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$genitive_plural"/>
			</xsl:otherwise>
		</xsl:choose>
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