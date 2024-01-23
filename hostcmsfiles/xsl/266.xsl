<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:template match="/shop">
		<h1 class="cart-title">Адрес доставки</h1>

		<xsl:if test="error != ''">
			<div class="alert alert-danger alert-cart" role="alert">
				<xsl:value-of disable-output-escaping="yes" select="error" />
			</div>
		</xsl:if>

		<div class="row">
			<div class="col-12">
				<div class="cart">
					<xsl:if test="/shop/siteuser/node()">
						<xsl:apply-templates select="/shop/siteuser"/>
					</xsl:if>

					<form class="cart-form" action="./" method="post">
						<div class="cart-products address">
							<div class="row">
								<div class="col-12 col-sm-4"><input name="surname" value="{/shop/siteuser/surname}" class="form-control" placeholder="Фамилия"/></div>
								<div class="col-12 col-sm-4"><input name="name" value="{/shop/siteuser/name}" class="form-control" placeholder="Имя"/></div>
								<div class="col-12 col-sm-4"><input name="patronymic" value="{/shop/siteuser/patronymic}" class="form-control" placeholder="Отчество"/></div>
							</div>
							<div class="row">
								<div class="col-12"><input name="company" value="{/shop/siteuser/company}" class="form-control" placeholder="Компания"/></div>
							</div>
							<div class="row">
								<div class="col-12 col-sm-6"><input name="phone" value="{/shop/siteuser/phone}" class="form-control" placeholder="Телефон"/></div>
								<div class="col-12 col-sm-6"><input name="email" value="{/shop/siteuser/email}" class="form-control" placeholder="E-mail"/></div>
							</div>
							<div class="row">
								<div class="col-12 col-sm-6 col-md-3">
									<select id="shop_country_id" name="shop_country_id" data-search="1" onchange="$.loadLocations('{/shop/url}cart/', $(this).val())" class="nice-select wide" placeholder="Страна">
										<option value="0">…</option>
										<xsl:apply-templates select="shop_country" />
									</select>
								</div>
								<div class="col-12 col-sm-6 col-md-3">
									<select name="shop_country_location_id" id="shop_country_location_id" data-search="1" onchange="$('#shop_country_location_id').niceSelect('update'); $.loadCities('{/shop/url}cart/', $(this).val())" class="nice-select wide" placeholder="Выберите область">
										<option value="0" selected="selected">…</option>
										<xsl:apply-templates select="shop_country_location" />
									</select>
								</div>
								<div class="col-12 col-sm-6 col-md-3">
									<select name="shop_country_location_city_id" id="shop_country_location_city_id" data-search="1" onchange="$('#shop_country_location_city_id').niceSelect('update'); $.loadCityAreas('{/shop/url}cart/', $(this).val())" class="nice-select wide" placeholder="Выберите город">
										<option value="0" selected="selected">…</option>
										<xsl:apply-templates select="shop_country_location_city" />
									</select>
								</div>
								<div class="col-12 col-sm-6 col-md-3">
									<select name="shop_country_location_city_area_id" id="shop_country_location_city_area_id" data-search="1" onchange="$('#shop_country_location_city_area_id').niceSelect('update');" class="nice-select wide" placeholder="Выберите район города" >
										<option value="0" selected="selected">…</option>
									</select>
								</div>
							</div>
							<div class="row">
								<div class="col-12 col-sm-3"><input name="postcode" value="{/shop/siteuser/postcode}" class="form-control" placeholder="Индекс"/></div>
								<div class="col-12 col-sm-9"><input name="address" value="{/shop/siteuser/address}" class="form-control" placeholder="Адрес"/></div>
							</div>
							<div class="row">
								<div class="col-12"><textarea name="description" class="form-control" placeholder="Комментарий к заказу"/></div>
							</div>
						</div>
						<div class="cart-buttons">
							<div></div>
							<div>
								<input name="step" value="2" type="hidden" />
								<button class="btn" type="submit">Продолжить</button>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
		<SCRIPT type="text/javascript">
			$(function() {
				$.loadLocations('<xsl:value-of select="/shop/url" />cart/', $('#shop_country_id').val(), function(){
					$('#shop_country_location_id').niceSelect('update');
				});
			});
		</SCRIPT>
	</xsl:template>

	<xsl:template match="siteuser">
		<div class="row margin-bottom-20 cart-siteuser-list">
			<xsl:if test="siteuser_person/node()">
				<xsl:apply-templates select="siteuser_person"/>
			</xsl:if>

			<xsl:if test="siteuser_company/node()">
				<xsl:apply-templates select="siteuser_company"/>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="siteuser_person">
		<div class="col-12 col-md-4">
			<div class="cart-siteuser-field">
				<div class="row">
					<div class="col-12">
						<span class="cart-name"><xsl:value-of select="name"/></span><xsl:text> </xsl:text><span class="cart-patronymic"><xsl:value-of select="patronymic"/></span><xsl:text> </xsl:text><span class="cart-surname"><xsl:value-of select="surname"/></span>
					</div>
					<div class="col-12">
						<span class="cart-postcode"><xsl:value-of select="postcode"/></span><span class="cart-country"><xsl:value-of select="country"/></span><span class="cart-city"><xsl:value-of select="city"/></span><span class="cart-address"><xsl:value-of select="address"/></span>
					</div>
					<div class="col-12">
						<span class="cart-phone"><xsl:value-of select="directory_phone[value!='']/value"/></span>
					</div>
				</div>
				<i class="fa fa-check-circle-o" onclick="$.cartSelectSiteuser(this, '{/shop/url}cart/')"></i>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="siteuser_company">
		<div class="col-12 col-md-4">
			<div class="cart-siteuser-field">
				<div class="row">
					<div class="col-12">
						<span class="cart-company-name"><xsl:value-of select="name"/></span>
					</div>
					<div class="col-12">
						<span class="cart-postcode"><xsl:value-of select="directory_address[value!='']/postcode"/></span><span class="cart-country"><xsl:value-of select="directory_address[value!='']/country"/></span><span class="cart-city"><xsl:value-of select="directory_address[value!='']/city"/></span><span class="cart-address"><xsl:value-of select="directory_address[value!='']/value"/></span>
					</div>
					<div class="col-12">
						<span class="cart-phone"><xsl:value-of select="directory_phone[value!='']/value"/></span>
					</div>
				</div>
				<i class="fa fa-check-circle-o" onclick="$.cartSelectSiteuser(this, '{/shop/url}cart/')"></i>
			</div>
		</div>
	</xsl:template>

	<!-- Шаблон для фильтра дополнительных свойств заказа -->
	<xsl:template match="property" mode="propertyList">
		<xsl:variable name="nodename">property_<xsl:value-of select="@id"/></xsl:variable>

		<div class="row">
			<div class="caption">
				<xsl:if test="display != 5">
					<xsl:value-of select="name"/>:
				</xsl:if>
			</div>
			<div class="field">
				<xsl:choose>
					<!-- Отображаем поле ввода -->
					<xsl:when test="display = 1">
						<input type="text" size="30" name="property_{@id}" class="width2">
							<xsl:choose>
								<xsl:when test="/shop/*[name()=$nodename] != ''">
									<xsl:attribute name="value"><xsl:value-of select="/shop/*[name()=$nodename]"/></xsl:attribute>
								</xsl:when>
							<xsl:otherwise><xsl:attribute name="value"><xsl:value-of select="default_value"/></xsl:attribute></xsl:otherwise>
							</xsl:choose>
						</input>
					</xsl:when>
					<!-- Отображаем список -->
					<xsl:when test="display = 2">
						<select name="property_{@id}">
							<option value="0">...</option>
							<xsl:apply-templates select="list/list_item"/>
						</select>
					</xsl:when>
					<!-- Отображаем переключатели -->
					<xsl:when test="display = 3">
						<div class="propertyInput">
							<input type="radio" name="property_{@id}" value="0" id="id_prop_radio_{@id}_0"></input>
							<label for="id_prop_radio_{@id}_0">Любой вариант</label>
							<xsl:apply-templates select="list/list_item"/>
						</div>
					</xsl:when>
					<!-- Отображаем флажки -->
					<xsl:when test="display = 4">
						<div class="propertyInput">
							<xsl:apply-templates select="list/list_item"/>
						</div>
					</xsl:when>
					<!-- Отображаем флажок -->
					<xsl:when test="display = 5">
						<input type="checkbox" name="property_{@id}" id="property_{@id}" style="padding-top:4px">
							<xsl:if test="/shop/*[name()=$nodename] != ''">
								<xsl:attribute name="checked"><xsl:value-of select="/shop/*[name()=$nodename]"/></xsl:attribute>
							</xsl:if>
						</input>
						<label for="property_{@id}">
							<xsl:value-of select="name"/><xsl:text> </xsl:text>
						</label>
					</xsl:when>
					<!-- Отображаем список с множественным выбором-->
					<xsl:when test="display = 7">
						<select name="property_{@id}[]" multiple="multiple">
							<xsl:apply-templates select="list/list_item"/>
						</select>
					</xsl:when>
					<!-- Отображаем большое текстовое поле -->
					<xsl:when test="display = 8">
						<textarea type="text" size="30" rows="5" name="property_{@id}" class="width2">
							<xsl:choose>
								<xsl:when test="/shop/*[name()=$nodename] != ''">
									<xsl:value-of select="/shop/*[name()=$nodename]"/>
								</xsl:when>
								<xsl:otherwise><xsl:value-of select="default_value"/></xsl:otherwise>
							</xsl:choose>
						</textarea>
					</xsl:when>
				</xsl:choose>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="list/list_item">
		<xsl:if test="../../display = 2">
			<!-- Отображаем список -->
			<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
			<option value="{@id}">
			<xsl:if test="/shop/*[name()=$nodename] = @id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				<xsl:value-of disable-output-escaping="yes" select="value"/>
			</option>
		</xsl:if>
		<xsl:if test="../../display = 3">
			<!-- Отображаем переключатели -->
			<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
			<br/>
			<input type="radio" name="property_{../../@id}" value="{@id}" id="id_property_{../../@id}_{@id}">
				<xsl:if test="/shop/*[name()=$nodename] = @id">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
				<label for="id_property_{../../@id}_{@id}">
					<xsl:value-of disable-output-escaping="yes" select="value"/>
				</label>
			</input>
		</xsl:if>
		<xsl:if test="../../display = 4">
			<!-- Отображаем флажки -->
			<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
			<br/>
			<input type="checkbox" value="{@id}" name="property_{../../@id}[]" id="property_{../../@id}_{@id}">
				<xsl:if test="/shop/*[name()=$nodename] = @id">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
				<label for="property_{../../@id}_{@id}">
					<xsl:value-of disable-output-escaping="yes" select="value"/>
				</label>
			</input>
		</xsl:if>
		<xsl:if test="../../display = 7">
			<!-- Отображаем список -->
			<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
			<option value="{@id}">
				<xsl:if test="/shop/*[name()=$nodename] = @id">
					<xsl:attribute name="selected">
					</xsl:attribute>
				</xsl:if>
				<xsl:value-of disable-output-escaping="yes" select="value"/>
			</option>
		</xsl:if>
	</xsl:template>

	<xsl:template match="shop_country">
		<option value="{@id}">
			<xsl:if test="/shop/current_shop_country_id = @id or not(/shop/current_shop_country_id/node()) and /shop/shop_country_id = @id">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="name" />
		</option>
	</xsl:template>

	<xsl:template match="shop_country_location">
		<option value="{@id}">
			<xsl:if test="/shop/current_shop_country_location_id = @id">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="name" />
		</option>
	</xsl:template>

	<xsl:template match="shop_country_location_city">
		<option value="{@id}">
			<xsl:if test="/shop/current_shop_country_location_city_id = @id">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="name" />
		</option>
	</xsl:template>
</xsl:stylesheet>