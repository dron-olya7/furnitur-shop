<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml" />

	<!-- ОтобразитьФорму -->

	<xsl:template match="/">
		<section class="main-contacts">
			<div class="row">
				<div class="col-12 margin-top-30">
					<h2>Обратная связь</h2>
					<xsl:apply-templates select="form" />
				</div>
			</div>
		</section>
	</xsl:template>

	<xsl:template match="/form">
		<!-- Проверка формы -->
		<SCRIPT type="text/javascript">
			$(document).ready(function() {
				$("#form<xsl:value-of select="@id" />").validate({
					rules: {
						fio: "required",
						email: {
							required: true,
							email: true
						}
					},
					messages: {
						fio: "Введите ФИО!",
						email: {
							required: "Введите e-mail!",
							email: "Адрес должен быть вида name@domain.com"
						}
					},
					focusInvalid: true,
					errorClass: "input_error"
				})
			});
		</SCRIPT>

		<xsl:choose>
			<xsl:when test="success/node() and success = 1">
				<div class="alert alert-info alert-cart" role="alert">
					Спасибо! Запрос получен, в ближайшее время Вам будет дан ответ.
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<!-- Выводим ошибку (error), если она была передана через внешний параметр -->
					<xsl:when test="error != ''">
						<div class="alert alert-danger alert-cart" role="alert">
							<xsl:value-of disable-output-escaping="yes" select="error" />
						</div>
					</xsl:when>
					<xsl:when test="errorId/node()">
						<div class="alert alert-danger alert-cart">
							<xsl:choose>
								<xsl:when test="errorId = 0">
									Вы неверно ввели число подтверждения отправки формы!
								</xsl:when>
								<xsl:when test="errorId = 1">
									Заполните все обязательные поля!
								</xsl:when>
								<xsl:when test="errorId = 2">
									Прошло слишком мало времени с момента последней отправки Вами формы!
								</xsl:when>
							</xsl:choose>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="description" />
					</xsl:otherwise>
				</xsl:choose>

				<form name="form{@id}" id="form{@id}" class="contacts validate" action="./" method="post" enctype="multipart/form-data">
					<!-- Вывод списка полей формы 0-го уровня -->
					<xsl:apply-templates select="form_field" />

					<!-- Обработка CAPTCHA -->
					<xsl:if test="//captcha_id != 0 and use_captcha = 1">
						<div class="row contacts-captcha">
							<div class="form-group col-12 col-md-6">
								<!-- <label for="textarea_text"></label> -->
								<div class="captcha captcha-refresh">
									<img id="formCaptcha_{/form/@id}_{/form/captcha_id}" data-src="/captcha.php?id={captcha_id}&amp;height=30&amp;width=100"  class="captcha lazyload" title="Контрольное число" name="captcha"/>
									<img src="/images/refresh.png" />
									<span onclick="$('#formCaptcha_{/form/@id}_{/form/captcha_id}').updateCaptcha('{/form/captcha_id}', 30); return false">Показать другое число</span>
								</div>
							</div>
							<div class="form-group col-12 col-md-6">
								<label for="captcha">Контрольное число<sup><font color="red">*</font></sup></label>
								<div class="field">
									<input type="hidden" name="captcha_id" value="{/form/captcha_id}"/>
									<input type="text" name="captcha" size="15" class="form-control" minlength="4" title="Введите число, которое указано выше."/>
								</div>
							</div>
						</div>
					</xsl:if>

					<button value="submit" name="{button_name}" type="submit" class="btn">Отправить</button>
				</form>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="form_field">
		<!-- Не скрытое поле и не надпись -->
		<xsl:if test="type != 7 and type != 8">
			<div class="form-group">
				<xsl:choose>
					<!-- Радиокнопки -->
					<xsl:when test="type = 3 or type = 9">
						<xsl:apply-templates select="list/list_item" />
					</xsl:when>

					<!-- Checkbox -->
					<xsl:when test="type = 4">
						<div class="pretty p-default p-pulse">
							<input type="checkbox" name="{name}">
								<xsl:if test="checked = 1 or value = 1">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>

							<div class="state p-danger-o">
								<label><xsl:value-of select="value" /></label>
							</div>
						</div>
					</xsl:when>

					<!-- Textarea -->
					<xsl:when test="type = 5">
						<textarea class="form-control" name="{name}" cols="{cols}" rows="{rows}" wrap="off" placeholder="{caption}">
							<xsl:if test="obligatory = 1">
								<xsl:attribute name="class">form-control required</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="value" />
						</textarea>
					</xsl:when>

					<!-- Список -->
					<xsl:when test="type = 6">
						<select name="{name}" class="wide">
							<xsl:if test="obligatory = 1">
								<xsl:attribute name="class">wide required</xsl:attribute>
								<xsl:attribute name="title"><xsl:value-of select="caption" /></xsl:attribute>
							</xsl:if>
							<option value="">...</option>
							<xsl:apply-templates select="list/list_item" />
						</select>
					</xsl:when>

					<!-- Текстовые поля -->
					<xsl:otherwise>
						<input class="form-control" type="text" name="{name}" value="{value}" size="{size}" placeholder="{caption}">
							<xsl:choose>
								<!-- Поле для ввода пароля -->
								<xsl:when test="type = 1">
									<xsl:attribute name="type">password</xsl:attribute>
								</xsl:when>
								<!-- Поле загрузки файла -->
								<xsl:when test="type = 2">
									<xsl:attribute name="type">file</xsl:attribute>
								</xsl:when>
								<!-- HTML5: Дата -->
								<xsl:when test="type = 10">
									<xsl:attribute name="type">date</xsl:attribute>
								</xsl:when>
								<!-- HTML5: Цвет -->
								<xsl:when test="type = 11">
									<xsl:attribute name="type">color</xsl:attribute>
								</xsl:when>
								<!-- HTML5: Месяц -->
								<xsl:when test="type = 12">
									<xsl:attribute name="type">month</xsl:attribute>
								</xsl:when>
								<!-- HTML5: Неделя -->
								<xsl:when test="type = 13">
									<xsl:attribute name="type">week</xsl:attribute>
								</xsl:when>
								<!-- HTML5: Время -->
								<xsl:when test="type = 14">
									<xsl:attribute name="type">time</xsl:attribute>
								</xsl:when>
								<!-- HTML5: Дата-Время -->
								<xsl:when test="type = 15">
									<xsl:attribute name="type">datetime</xsl:attribute>
								</xsl:when>
								<!-- HTML5: E-mail -->
								<xsl:when test="type = 16">
									<xsl:attribute name="type">email</xsl:attribute>
								</xsl:when>
								<!-- HTML5: Поиск -->
								<xsl:when test="type = 17">
									<xsl:attribute name="type">search</xsl:attribute>
								</xsl:when>
								<!-- HTML5: Телефон -->
								<xsl:when test="type = 18">
									<xsl:attribute name="type">tel</xsl:attribute>
								</xsl:when>
								<!-- HTML5: URL -->
								<xsl:when test="type = 19">
									<xsl:attribute name="type">url</xsl:attribute>
								</xsl:when>
								<!-- Текстовое поле -->
								<xsl:otherwise>
									<xsl:attribute name="type">text</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="obligatory = 1">
								<xsl:attribute name="class">form-control required</xsl:attribute>
							</xsl:if>
						</input>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</xsl:if>

		<!-- скрытое поле -->
		<xsl:if test="type = 7">
			<input type="hidden" name="{name}" value="{value}" />
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>