<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<xsl:template match="/shop">
		<xsl:choose>
			<xsl:when test="count(shop_cart) = 0">
				<div class="alert alert-info" role="alert">Товары в корзине отсутствуют!</div>
			</xsl:when>
			<xsl:otherwise>
				<h1 class="cart-title">Оформление заказа</h1>
				<div class="row">
					<div class="col-12">
						<div class="cart">
							<form class="cart-form" action="{/shop/url}cart/" method="post">
								<xsl:variable name="available_bonuses">
									<xsl:choose>
										<xsl:when test="apply_bonuses/node()">
											<xsl:value-of select="apply_bonuses" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="available_bonuses" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>

								<div class="cart-products">
									<!-- Если есть товары -->
									<xsl:if test="count(shop_cart[postpone = 0])">
										<table class="table-responsive cart-table">
											<tbody>
												<xsl:apply-templates select="shop_cart[postpone = 0]" />
											</tbody>
										</table>

										<div class="cart-meta">
											<div></div>
											<div class="cart-sum">
												<xsl:if test="count(shop_purchase_discount) or shop_discountcard/node() or apply_bonuses/node()">
													<xsl:apply-templates select="shop_purchase_discount"/>
													<xsl:apply-templates select="shop_discountcard"/>
													<xsl:if test="siteuser_id > 0 and apply_bonuses/node()">
														<span class="cart-sum-text">
															Бонусы<xsl:text>: </xsl:text>
															<xsl:apply-templates select="/shop/shop_currency/code">
																<xsl:with-param name="value" select="$available_bonuses * -1" />
															</xsl:apply-templates>
														</span>
													</xsl:if>
												</xsl:if>
												<span class="cart-sum-text"><b>
													Итого:
													<xsl:apply-templates select="/shop/shop_currency/code">
														<xsl:with-param name="value" select="total_amount" />
													</xsl:apply-templates>
													</b>
												</span>
											</div>
										</div>
									</xsl:if>

									<!-- Если есть отложенные товары -->
									<xsl:if test="count(shop_cart[postpone = 1])">
										<h2 class="postpone-header">Отложенные товары</h2>
										<table class="table-responsive cart-table">
											<tbody>
												<xsl:apply-templates select="shop_cart[postpone = 1]" />
											</tbody>
										</table>
									</xsl:if>
								</div>
								<div class="cart-meta">
									<div class="d-flex">
										<div class="coupon-wrapper">
											<div>Купон</div>
											<div class="input-box">
												<input type="text" name="coupon_text" value="{coupon_text}" placeholder="Введите код купона" />
											</div>
										</div>
										<xsl:if test="siteuser_id > 0 and available_bonuses/node()">
											<div class="bonus-wrapper ml-5">
												<div>Бонусы</div>
												<xsl:variable name="apply_bonuses">
													<xsl:choose>
														<xsl:when test="apply_bonuses/node()">
															<xsl:value-of select="apply_bonuses" />
														</xsl:when>
														<xsl:otherwise>
															0
														</xsl:otherwise>
													</xsl:choose>
												</xsl:variable>

												<div class="input-box-wrapper">
													<div class="input-box">
														<input type="text" name="bonuses" value="{floor($available_bonuses)}" />
													</div>
													<div class="input-box-description">Бонусы, доступно <b><xsl:value-of select="floor(available_bonuses - $apply_bonuses)"/></b></div>
												</div>
											</div>
										</xsl:if>
									</div>

									<!-- <div class="cart-tabs">
										<ul class="nav nav-tabs" id="myTab" role="tablist">
											<li class="nav-item" role="presentation">
												<a class="nav-link active" id="coupon-tab" data-toggle="tab" href="#coupon" role="tab" aria-controls="coupon" aria-selected="true">Купон</a>
											</li>
											<xsl:if test="siteuser_id > 0 and available_bonuses/node()">
												<li class="nav-item" role="presentation">
													<a class="nav-link" id="bonus-tab" data-toggle="tab" href="#bonus" role="tab" aria-controls="bonus" aria-selected="false">Бонусы</a>
												</li>
											</xsl:if>
										</ul>
										<div class="tab-content">
											<div class="tab-pane active" id="coupon" role="tabpanel">
												<div class="input-box">
													<input type="text" name="coupon_text" placeholder="Введите код купона" />
												</div>
											</div>
											<xsl:if test="siteuser_id > 0 and available_bonuses/node()">
												<xsl:variable name="apply_bonuses">
													<xsl:choose>
														<xsl:when test="apply_bonuses/node()">
															<xsl:value-of select="apply_bonuses" />
														</xsl:when>
														<xsl:otherwise>
															0
														</xsl:otherwise>
													</xsl:choose>
												</xsl:variable>

												<div class="tab-pane" id="bonus" role="tabpanel">
													<div class="input-box-wrapper">
														<div class="input-box">
															<input type="text" name="bonuses" value="{floor($available_bonuses)}" />
														</div>
														<div class="input-box-description">Бонусы, доступно <b><xsl:value-of select="floor(available_bonuses - $apply_bonuses)"/></b></div>
													</div>
												</div>
											</xsl:if>
										</div>
									</div>-->
								</div>
								<div class="cart-buttons">
									<div class="d-none d-md-block"><a href="{/shop/url}" class="btn btn-transparent" type="submit">Вернуться в магазин</a></div>
									<div>
										<button class="btn btn-transparent mr-4" type="submit" name="recount" value="recount">Пересчитать</button>
										<!-- Пользователь авторизован или модуль пользователей сайта отсутствует -->
										<xsl:if test="count(shop_cart[postpone = 0]) and (siteuser_id > 0 or siteuser_exists = 0)">
											<input name="step" value="1" type="hidden" />
											<button class="btn process-order" type="submit">
												<span><i class="fa fa-check"></i></span>
												<span>Оформить</span>
											</button>
										</xsl:if>
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Шаблон для скидки от суммы заказа -->
	<xsl:template match="shop_purchase_discount">
		<span class="cart-sum-text">
			<xsl:value-of select="name"/><xsl:text>: </xsl:text>
			<b>
			<xsl:apply-templates select="/shop/shop_currency/code">
				<xsl:with-param name="value" select="discount_amount * -1" />
			</xsl:apply-templates>
			</b>
		</span>
		<br/>
	</xsl:template>

	<xsl:template match="shop_discountcard">
		<span class="cart-sum-text">
			Дисконтная карта <xsl:value-of select="number"/><xsl:text>: </xsl:text>
			<b>
			<xsl:apply-templates select="/shop/shop_currency/code">
				<xsl:with-param name="value" select="discount_amount * -1" />
			</xsl:apply-templates>
			</b>
		</span>
		<br/>
	</xsl:template>

	<xsl:template match="shop_cart">
		<xsl:variable name="url">
			<xsl:choose>
				<xsl:when test="shop_item/shop_item/node()">
					<xsl:value-of select="shop_item/shop_item/url"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="shop_item/url"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<tr class="cart-table-row">
			<td class="cart-table-photo">
				<a href="{$url}" class="cart__photo">
					<xsl:choose>
						<xsl:when test="shop_item/image_small != ''">
							<img src="{shop_item/dir}{shop_item/image_small}" class="lazyload" />
						</xsl:when>
						<xsl:when test="shop_item/shop_item/image_small != ''">
							<img src="{shop_item/shop_item/dir}{shop_item/shop_item/image_small}" class="lazyload" />
						</xsl:when>
						<xsl:otherwise>
							<img src="/hostcmsfiles/assets/images/no-image.svg" class="lazyload" />
						</xsl:otherwise>
					</xsl:choose>
				</a>
			</td>
			<td class="cart-table-name">
				<a href="{$url}" class="cart__product-name">
					<xsl:value-of disable-output-escaping="yes" select="shop_item/name"/>
				</a>
			</td>
			<td class="cart-table-discount">
				<span class="cart-discount">
					<xsl:value-of disable-output-escaping="yes" select="shop_item/marking"/><br/>
				</span>
			</td>
			<td class="cart-table-price">
				<span class="cart-price">
					<xsl:apply-templates select="/shop/shop_currency/code">
						<xsl:with-param name="value" select="shop_item/price" />
					</xsl:apply-templates>
				</span>
			</td>
			<td class="input-spinner">
				<div class="spinner-wrap">
					<input class="spinner" type="text" size="3" name="quantity_{shop_item/@id}" id="quantity_{shop_item/@id}" value="{quantity}"/>
				</div>
			</td>
			<td class="cart-table-price-total">
				<span class="cart-price-total" title="Всего">
					<xsl:apply-templates select="/shop/shop_currency/code">
						<xsl:with-param name="value" select="shop_item/price * quantity" />
					</xsl:apply-templates>
				</span>
			</td>
			<td class="cart-table-delete">
				<a class="cart-postpone" data-id="{shop_item/@id}" data-postpone="{postpone}" title="Отложить">
					<i class="fa fa-calendar-plus-o secondary">
						<xsl:if test="postpone = 1">
							<xsl:attribute name="class">fa fa-calendar-plus-o fifth</xsl:attribute>
						</xsl:if>
					</i>
				</a>
				<input type="hidden" name="postpone_{shop_item/@id}" value="{postpone}"/>
				<a href="?delete={shop_item/@id}" onclick="return confirm('Вы уверены, что хотите удалить?')" class="cart-delete" title="Удалить"><i class="fa fa-times-circle-o primary"></i></a>
			</td>
		</tr>
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