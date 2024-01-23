<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- МагазинКупитьВОдинШаг -->

	<xsl:template match="/shop">
		<script language="JavaScript">
			<xsl:comment>
				<xsl:text disable-output-escaping="yes">
					<![CDATA[
					$(function() {
						// add the rule here
						$.validator.addMethod("valueNotEquals", function(value, element, arg){
							return arg != value;
						}, "Value must not equal arg.");

						$(".validate").validate({
							rules: {
								surname: "required",
								name: "required",
								shop_delivery_condition_id: { valueNotEquals: "0" },
								shop_payment_system_id: { valueNotEquals: "0" },
								email: {
									required: true,
									email: true
								}
							},
							messages: {
								surname: "Введите фамилию!",
								name: "Введите имя!",
								shop_delivery_condition_id: { valueNotEquals: "Выберите способ доставки!" },
								shop_payment_system_id: { valueNotEquals: "Выберите платежную систему!" },
								email: {
									required: "Введите e-mail!",
									email: "Адрес должен быть вида name@domain.com"
								}
							},
							focusInvalid: true,
							errorClass: "input_error"
						});

						$('select:not([name = grade])').niceSelect();

						$.extend({
							updateSelects: function()
							{
								setTimeout(function(){
									$('#shop_country_location_city_id').niceSelect('update');
									$('#shop_country_location_city_area_id').niceSelect('update');
									$('#shop_delivery_condition_id').niceSelect('update');
									$('#shop_payment_system_id').niceSelect('update');
								}, 1000);
							}
						});
					});
					]]>
				</xsl:text>
			</xsl:comment>
		</script>

		<xsl:apply-templates select="shop_item" />
	</xsl:template>

	<xsl:template match="shop_item">
		<!-- Modal Div -->
		<div class="modal fade" id="oneStepCheckout" tabindex="-1" aria-labelledby="cityModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-xl modal-dialog-centered">
				<div class="modal-content">
					<form method="post" action="{/shop/url}cart/" class="validate">
						<div class="modal-header modal-header-background">
							<h5 class="modal-title" id="myModalLabel">Купить<xsl:text> </xsl:text><xsl:value-of select="name"/></h5>
							<button type="button" class="close" data-dismiss="modal" aria-label="Close">
								<span aria-hidden="true"><i class="fa fa-times-circle"></i></span>
							</button>
						</div>
						<div class="modal-body">
							<div class="row">
								<div class="col-12 col-md-4">
									<input type="text" id="recipient-name" class="form-control" name="name" value="{/shop/siteuser/name}" placeholder="Имя"/>
								</div>
								<div class="col-12 col-md-4">
									<input type="text" id="recipient-surname" class="form-control" name="surname" value="{/shop/siteuser/surname}" placeholder="Фамилия"/>
								</div>
								<div class="col-12 col-md-4">
									<input type="text" id="recipient-patronymic" class="form-control" name="patronymic" value="{/shop/siteuser/patronymic}" placeholder="Отчество"/>
								</div>
							</div>
							<div class="row">
								<div class="col-12 col-md-6">
									<select class="nice-select wide" data-search="1" id="shop_country_id" name="shop_country_id" placeholder="Выберите страну" onchange="$.loadLocations('{/shop/url}cart/', $(this).val()); $.getOnestepDeliveryList('{/shop/url}cart/', {@id}, $(this).closest('form'))">
										<option value="0">…</option>
										<xsl:apply-templates select="/shop/shop_country" />
									</select>
								</div>
								<div class="col-12 col-md-6">
									<select class="nice-select wide" data-search="1" name="shop_country_location_id" id="shop_country_location_id" placeholder="Выберите область" onchange="$.loadCities('{/shop/url}cart/', $(this).val()); $.getOnestepDeliveryList('{/shop/url}cart/', {@id}, $(this).closest('form')); $.updateSelects();">
										<option value="0" selected="selected">…</option>
										<xsl:apply-templates select="/shop/shop_country_location" />
									</select>
								</div>
							</div>
							<div class="row">
								<div class="col-12 col-md-6">
									<select class="nice-select wide" data-search="1" name="shop_country_location_city_id" id="shop_country_location_city_id" placeholder="Выберите город" onchange="$.loadCityAreas('{/shop/url}cart/', $(this).val()); $.getOnestepDeliveryList('{/shop/url}cart/', {@id}, $(this).closest('form')); $.updateSelects();">
										<option value="0" selected="selected">…</option>
										<xsl:apply-templates select="/shop/shop_country_location_city" />
									</select>
								</div>
								<div class="col-12 col-md-6">
									<select class="nice-select wide" data-search="1" name="shop_country_location_city_area_id" id="shop_country_location_city_area_id" placeholder="Выберите район города" onchange="$.getOnestepDeliveryList('{/shop/url}cart/', {@id}, $(this).closest('form')); $.updateSelects();">
										<option value="0" selected="selected">…</option>
									</select>
								</div>
							</div>
							<div class="row">
								<div class="col-12 col-md-6">
									<select class="nice-select wide" name="shop_delivery_condition_id" id="shop_delivery_condition_id" placeholder="Выберите способ доставки" onchange="$.getOnestepPaymentSystemList('{/shop/url}cart/', $(this).closest('form')); $.updateSelects();">
										<option value="0" selected="selected">…</option>
									</select>
								</div>
								<div class="col-12 col-md-6">
									<select class="nice-select wide" name="shop_payment_system_id" id="shop_payment_system_id" placeholder="Выберите способ оплаты">
										<option value="0" selected="selected">…</option>
									</select>
								</div>
							</div>
							<div class="row">
								<div class="col-12 col-md-3">
									<input type="text" id="recipient-postcode" class="form-control" name="postcode" value="{/shop/siteuser/postcode}" placeholder="Индекс"/>
								</div>
								<div class="col-12 col-md-9">
									<input type="text" id="recipient-address" class="form-control" name="address" value="{/shop/siteuser/address}" placeholder="Адрес"/>
								</div>
							</div>
							<div class="row">
								<div class="col-12 col-md-3">
									<input type="text" id="recipient-phone" class="form-control" name="phone" value="{/shop/siteuser/phone}" placeholder="Телефон"/>
								</div>
								<div class="col-12 col-md-9">
									<input type="text" id="recipient-email" class="form-control" name="email" value="{/shop/siteuser/email}" placeholder="E-mail"/>
								</div>
							</div>
							<div class="row">
								<div class="col-12">
									<textarea id="message-text" class="form-control" name="description" placeholder="Комментарий к заказу"></textarea>
								</div>
							</div>

							<!-- Дополнительные свойства заказа -->
							<xsl:if test="count(/shop/shop_order_properties//property[display != 0 and (type != 2 )])">
								<xsl:apply-templates select="/shop/shop_order_properties//property[display != 0 and (type != 2 )]" mode="propertyList"/>
							</xsl:if>

							<div class="row">
								<div class="col-12">
									<div class="pretty p-default p-pulse">
										<input type="checkbox" class="personal-data" name="personal_data" />
										<div class="state p-danger-o">
											<label>Я соглашаюсь на обработку персональных данных для возможности оформления Заказа.</label>
										</div>
									</div>
								</div>
							</div>

							<xsl:if test="not(/shop/current_shop_country_location_id/node())">
								<SCRIPT type="text/javascript">
									$(function() {
										$.loadLocations('<xsl:value-of select="/shop/url" />cart/', $('#shop_country_id').val());
										$.getOnestepDeliveryList('<xsl:value-of select="/shop/url" />cart/', '<xsl:value-of select="@id" />', $('#shop_country_id').closest('form'));

										$('.personal-data').on('click', function(){
											document.querySelector('button.btn-fast-order').toggleAttribute('disabled');
										});
									});
								</SCRIPT>
							</xsl:if>
						</div>

						<div class="modal-footer">
							<input type="hidden" value="1" name="oneStepCheckout" />
							<input type="hidden" value="{@id}" name="shop_item_id" />
							<input type="hidden" value="{/shop/count}" name="count" />
							<button class="btn btn-fast-order" disabled="disabled" value="submit" name="submit" type="submit">Оформить заказ</button>
						</div>
					</form>
				</div>
			</div>
		</div>
		<SCRIPT type="text/javascript">
			$(function() {
				setTimeout (function(){
					$('#shop_country_location_id').niceSelect('update');
				}, 1000);
			});
		</SCRIPT>
	</xsl:template>

	<!-- Шаблон для фильтра дополнительных свойств заказа -->
	<xsl:template match="property" mode="propertyList">
		<xsl:variable name="nodename">property_<xsl:value-of select="@id"/></xsl:variable>

		<div class="form-group">
			<label for="" class="control-label">
				<xsl:if test="display != 5">
					<xsl:value-of select="name"/>:
				</xsl:if>
			</label>

			<xsl:choose>
				<!-- Отображаем поле ввода -->
				<xsl:when test="display = 1">
					<input type="text" size="30" name="property_{@id}" class="form-control">
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
					<select name="property_{@id}" class="form-control">
						<option value="0">...</option>
						<xsl:apply-templates select="list/list_item"/>
					</select>
				</xsl:when>
				<!-- Отображаем переключатели -->
				<xsl:when test="display = 3">
					<input type="radio" name="property_{@id}" value="0" id="id_prop_radio_{@id}_0" class="form-control"></input>
					<label for="id_prop_radio_{@id}_0">Любой вариант</label>
					<xsl:apply-templates select="list/list_item"/>
				</xsl:when>
				<!-- Отображаем флажки -->
				<xsl:when test="display = 4">
					<xsl:apply-templates select="list/list_item"/>
				</xsl:when>
				<!-- Отображаем флажок -->
				<xsl:when test="display = 5">
					<input type="checkbox" name="property_{@id}" id="property_{@id}" style="padding-top:4px" class="form-control">
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
					<select name="property_{@id}[]" multiple="multiple" class="form-control">
						<xsl:apply-templates select="list/list_item"/>
					</select>
				</xsl:when>
				<!-- Отображаем большое текстовое поле -->
				<xsl:when test="display = 8">
					<textarea type="text" size="30" form-groups="5" name="property_{@id}" class="form-control">
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
			<input type="checkbox" value="{@id}" name="property_{../../@id}[]" id="property_{../../@id}_{@id}" class="form-control">
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