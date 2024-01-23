<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- ПополнениеЛицевогоСчетаРеквизиты -->

	<xsl:template match="/shop">

		<form method="POST">
			<h1>Реквизиты</h1>

			<div class="alert alert-info" role="alert">
				Обратите внимание, что переведенные средства можно будет потратить только на приобретение лицензий и продление периода поддержки. Возврат (вывод) средств из системы невозможен.
			</div>

			<div class="show form shop_address margin-bottom-20">
				<div class="row">
					<div class="form-group col-xs-12 col-sm-3">
						<label>
							Сумма платежа <span class="redSup"> *</span>
						</label>
						<div class="field">
							<input name="amount" type="text" placeholder="{shop_currency/sign}" class="form-control" />
						</div>
					</div>
					<div class="form-group col-xs-12 col-sm-3">
						<label>
							Имя
						</label>
						<div class="field">
							<input name="name" value="{/shop/siteuser/name}" type="text" class="form-control" />
						</div>
					</div>
					<div class="form-group col-xs-12 col-sm-3">
						<label>
							Фамилия
						</label>
						<div class="field">
							<input name="surname" value="{/shop/siteuser/surname}" type="text" class="form-control" />
						</div>
					</div>
					<div class="form-group col-xs-12 col-sm-3">
						<label>
							Отчество
						</label>
						<div class="field">
							<input name="patronymic" value="{/shop/siteuser/patronymic}" type="text" class="form-control" />
						</div>
					</div>
				</div>

				<div class="form-group">
					<label>
						Компания
					</label>
					<div class="field">
						<input name="company" value="{/shop/siteuser/company}" type="text" class="form-control" />
					</div>
				</div>

				<div class="row">
					<div class="form-group col-xs-12 col-sm-6">
						<label>
							Телефон
						</label>
						<div class="field">
							<input name="phone" value="{/shop/siteuser/phone}" type="text" class="form-control" />
						</div>
					</div>
					<div class="form-group col-xs-12 col-sm-6">
						<label>
							E-mail
						</label>
						<div class="field">
							<input name="email" value="{/shop/siteuser/email}" type="text" class="form-control" />
						</div>
					</div>
				</div>

				<div class="row">
					<div class="form-group col-xs-12 col-sm-4">
						<label>
							Страна
						</label>
						<div class="field">
							<select id="shop_country_id" name="shop_country_id" onchange="$.loadLocations('{/shop/url}cart/', $(this).val())" data-search="1" class="wide">
								<option value="0">…</option>
								<xsl:apply-templates select="shop_country" />
							</select>
						</div>
					</div>

					<div class="form-group col-xs-12 col-sm-4">
						<label>
							Область
						</label>
						<div class="field">
							<select name="shop_country_location_id" id="shop_country_location_id" onchange="$.loadCities('{/shop/url}cart/', $(this).val())" data-search="1" class="wide">
								<option value="0">…</option>
								<xsl:apply-templates select="shop_country_location" />
							</select>
						</div>
					</div>

					<div class="form-group col-xs-12 col-sm-4">
						<label>
							Город
						</label>
						<div class="field">
							<select name="shop_country_location_city_id" id="shop_country_location_city_id" onchange="$.loadCityAreas('{/shop/url}cart/', $(this).val())" data-search="1" class="wide">
								<option value="0">…</option>
								<xsl:apply-templates select="shop_country_location_city" />
							</select>
						</div>
					</div>
				</div>

				<div class="row">
					<div class="form-group col-xs-12 col-sm-3">
						<label>
							Индекс
						</label>
						<div class="field">
							<input name="postcode" value="{/shop/siteuser/postcode}" type="text" class="form-control" />
						</div>
					</div>
					<div class="form-group col-xs-12 col-sm-9">
						<label>
							Адрес
						</label>
						<div class="field">
							<input name="address" value="{/shop/siteuser/address}" type="text" class="form-control" />
						</div>
					</div>
				</div>

				<div class="form-group">
					<label>
						Комментарий к заказу
					</label>
					<div class="field">
						<textarea rows="2" class="form-control" name="description"></textarea>
					</div>
				</div>
			</div>

			<!-- Платежные системы -->
			<xsl:choose>
				<xsl:when test="count(shop_payment_system) = 0">
					<div class="alert alert-info fade in alert-cart">
						<b>В данный момент нет доступных платежных систем!</b><br/>
						Оформление заказа невозможно, свяжитесь с администрацией Интернет-магазина.
					</div>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="shop_payment_system"/>

					<input name="apply" value="apply" type="hidden" />
					<button type="submit" value="Продолжить" class="btn mt-4">Продолжить</button>
				</xsl:otherwise>
			</xsl:choose>
		</form>

		<SCRIPT type="text/javascript">
			$(function() {
				$.loadLocations('<xsl:value-of select="/shop/url" />cart/', $('#shop_country_id').val());
			});
		</SCRIPT>

	</xsl:template>

	<xsl:template match="shop_country">
		<option value="{@id}">
			<xsl:if test="/shop/shop_country_id = @id">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="name" />
		</option>
	</xsl:template>

	<xsl:template match="shop_payment_system">
		<div class="margin-bottom-20">
			<div class="pretty p-default p-curve">
				<input type="radio" name="shop_payment_system_id" value="{@id}">
					<xsl:if test="position() = 1">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
				<div class="state p-success-o">
					<label><xsl:value-of select="name"/></label>
				</div>
			</div>

			<div class="pay-description">
				<xsl:value-of disable-output-escaping="yes" select="description"/>
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>