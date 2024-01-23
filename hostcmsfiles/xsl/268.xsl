<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:template match="/shop">
		<h1 class="cart-title">Форма оплаты</h1>

		<div class="row">
			<div class="col-12">
				<div class="cart">
					<form class="cart-form" action="./" method="post">
						<xsl:choose>
							<xsl:when test="count(shop_payment_system) = 0">
								<div class="alert alert-danger">
									<p>В данный момент нет доступных платежных систем!</p>
									<p>Оформление заказа невозможно, свяжитесь с администрацией Интернет-магазина.</p>
								</div>
							</xsl:when>
							<xsl:otherwise>
								<div class="cart-products">
									<div class="table-responsive">
										<table class="table cart-delivery">
											<thead>
												<tr class="total">
													<th width="20%"></th>
													<th>Описание</th>
												</tr>
											</thead>
											<tbody>
												<xsl:apply-templates select="shop_payment_system"/>

												<xsl:if test="siteuser/transaction_amount/node() and siteuser/transaction_amount &gt; 0">
													<tr>
														<td colspan="2">
															<div class="pretty p-default p-pulse mb-3">
																<input name="partial_payment_by_personal_account" type="checkbox" />
																<div class="state p-danger-o">
																	<label>Частично оплатить с лицевого счета, на счету <strong><xsl:value-of select="siteuser/transaction_amount" /><xsl:text> </xsl:text><xsl:value-of select="shop_currency/sign" /></strong></label>
																</div>
															</div>
														</td>
													</tr>
												</xsl:if>
											</tbody>
										</table>
									 </div>
								</div>
							</xsl:otherwise>
						</xsl:choose>
						<div class="cart-buttons">
							<div></div>
							<div>
								<input name="step" value="4" type="hidden" />
								<button class="btn" type="submit">Продолжить</button>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="shop_payment_system">
		<tr>
			<td class="text-align-left">
				<div class="pretty p-default p-curve">
					<input type="radio" value="{@id}" name="shop_payment_system_id">
						<xsl:if test="position() = 1">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<div class="state p-success-o">
						<label><xsl:value-of select="name"/></label>
					</div>
				</div>
			</td>
			<td>
				<xsl:value-of disable-output-escaping="yes" select="description"/>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>