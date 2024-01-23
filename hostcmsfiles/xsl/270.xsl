<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:template match="/siteuser">
		<SCRIPT type="text/javascript">
			<xsl:comment>
				<xsl:text disable-output-escaping="yes">
					<![CDATA[
					jQuery(function($) {
						$('[data-toggle=popover]').popover();
					});
					]]>
				</xsl:text>
			</xsl:comment>
		</SCRIPT>

		<h1 class="title">
			<xsl:choose>
				<xsl:when test="@id > 0">Анкетные данные</xsl:when>
				<xsl:when test="/siteuser/fastRegistration/node()">Быстрая регистрация</xsl:when>
				<xsl:otherwise>Регистрация нового пользователя</xsl:otherwise>
			</xsl:choose>
		</h1>

		<!-- Выводим ошибку, если она была передана через внешний параметр -->
		<xsl:if test="error/node()">
			<div class="alert alert-danger" role="alert">
				<xsl:value-of select="error"/>
			</div>
		</xsl:if>

		<div class="alert alert-info" role="alert">
			<b>Обратите внимание, введенные контактные данные будут доступны на странице пользователя неограниченному кругу лиц.</b>
			<br />Не вносите контактные данные, если не желаете их публикации на странице пользователя.
			<br />Обязательные поля отмечены *.
		</div>

		<form action="/users/registration/" method="POST" enctype="multipart/form-data">
			<xsl:if test="/siteuser/fastRegistration/node()">
				<input name="fast" value="" type="hidden" />
			</xsl:if>

			<div class="row">
				<div class="form-group col-12">
					<label class="required">Логин</label>
					<input class="form-control" name="login" value="{login}" />
				</div>
			</div>

			<div class="row">
				<div class="form-group col-12 col-md-6">
					<label class="required">Пароль</label>
					<input class="form-control" name="password" type="password" autocomplete="off">
						<!-- Для авторизированного пользователя заполнять пароль при редактировании данных необязательно -->
						<xsl:if test="@id = ''">
							<xsl:attribute name="required">required</xsl:attribute>
						</xsl:if>
					</input>
				</div>

				<xsl:if test="not(/siteuser/fastRegistration/node())">
					<div class="form-group col-12 col-md-6">
						<label class="required">Повтор пароля</label>
						<input class="form-control" name="password2" type="password" autocomplete="off">
							<!-- Для авторизированного пользователя заполнять пароль при редактировании данных необязательно -->
							<xsl:if test="@id = ''">
								<xsl:attribute name="required">required</xsl:attribute>
							</xsl:if>
						</input>
					</div>
				</xsl:if>
			</div>

			<div class="row">
				<div class="form-group col-12">
					<label class="required">E-mail</label>
					<input name="email" value="{email}" type="email" class="form-control" required="required" />
				</div>
			</div>

			<!-- Не показываются при быстрой регистрации -->
			<xsl:if test="not(/siteuser/fastRegistration/node())">
				<h5>Компания</h5>
				<xsl:choose>
					<xsl:when test="count(siteuser_company)">
						<xsl:apply-templates select="siteuser_company"></xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="siteuser_company"></xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>

				<h5>Представитель</h5>
				<xsl:choose>
					<xsl:when test="count(siteuser_person)">
						<xsl:apply-templates select="siteuser_person"></xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="siteuser_person"></xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>

				<!-- Внешние параметры -->
				<xsl:if test="count(properties/property[type != 10])">
					<xsl:apply-templates select="properties/property[type != 10]"/>
				</xsl:if>
			</xsl:if>

			<xsl:if test="@id > 0 and count(maillist)">
				<h2>Почтовые рассылки</h2>
				<xsl:apply-templates select="maillist" />
			</xsl:if>

			<xsl:if test="@id = ''">
				<div class="row">
					<div class="form-group col-sm-6">
						<label for="captcha-input" class="required">
							Контрольное число
						</label>
						<input type="hidden" name="captcha_id" value="{captcha_id}"/>

						<input id="captcha-input" type="text" name="captcha" size="15" class="form-control" minlength="4" required="required" title="Введите контрольное число"/>
					</div>
					<div class="form-group col-sm-6 margin-top-30">
						<label for="captcha"></label>

						<img id="registerUser" src="/captcha.php?id={captcha_id}&amp;height=40&amp;width=100" class="captcha" name="captcha" />

						<i class="fa fa-refresh" onclick="$('#registerUser').updateCaptcha('{captcha_id}', 40); return false"></i>
					</div>
				</div>
			</xsl:if>

			<!-- Страница редиректа после авторизации -->
			<xsl:if test="location/node()">
				<input name="location" type="hidden" value="{location}" />
			</xsl:if>

			<!-- Определяем имя кнопки -->
			<xsl:variable name="buttonName"><xsl:choose>
				<xsl:when test="@id != ''">Изменить</xsl:when>
				<xsl:otherwise>Зарегистрироваться</xsl:otherwise>
			</xsl:choose></xsl:variable>

			<button class="btn btn-secondary" type="submit" value="{$buttonName}" name="apply"><xsl:value-of disable-output-escaping="yes" select="$buttonName" /></button>
		</form>
	</xsl:template>

	<xsl:template match="maillist">
		<xsl:variable name="id" select="@id" />
		<xsl:variable name="maillist_siteuser" select="/siteuser/maillist_siteuser[maillist_id = $id]" />

		<div class="row align-items-center mb-4">
			<div class="col-8">
				<div class="pretty p-default p-pulse">
					<input type="checkbox" id="maillist_{@id}" name="maillist_{@id}" value="1">
						<xsl:if test="$maillist_siteuser/node()" ><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
					</input>
					<div class="state p-primary-o">
						<label><xsl:value-of select="name"/></label>
					</div>
				</div>
			</div>
			<div class="col-4">
				<select class="wide" name="type_{@id}" >
					<option value="0">
						<xsl:if test="$maillist_siteuser/node() and $maillist_siteuser/type = 0"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
						Текст
					</option>

					<option value="1">
						<xsl:if test="$maillist_siteuser/node() and $maillist_siteuser/type = 1"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
						HTML
					</option>
				</select>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="property_values_show">
		<xsl:param name="property" />
		<xsl:param name="node" select="''"/>

		<xsl:variable name="name"><xsl:choose>
			<xsl:when test="string-length($node) &gt; 0">property_<xsl:value-of select="$property/@id" />_<xsl:value-of select="$node/@id" /></xsl:when>
			<xsl:otherwise>property_<xsl:value-of select="$property/@id" />[]</xsl:otherwise>
		</xsl:choose></xsl:variable>

		<xsl:variable name="value"><xsl:choose>
			<xsl:when test="string-length($node) &gt; 0">
				<xsl:value-of select="$node/value" />
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose></xsl:variable>

		<!-- form-group или checkbox -->
		<div class="row">
			<div class="form-group col-12">
				<xsl:choose>
					<!-- Флажок -->
					<xsl:when test="$property/type = 7">
						<!-- <div class="checkbox">
							<label>
								<input type="checkbox" name="{$name}" class="property-row">
									<xsl:if test="$value = 1">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>

								<xsl:value-of select="$property/name" />
							</label>
						</div> -->

						<div class="pretty p-default p-pulse">
							<input type="checkbox" name="{$name}" class="property-row">
								<xsl:if test="$value = 1">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>
							<div class="state p-primary-o">
								<label><xsl:value-of select="$property/name" /></label>
							</div>
						</div>
					</xsl:when>
					<!-- Остальные поля -->
					<xsl:otherwise>
						<div class="form-group">
							<xsl:choose>
								<xsl:when test="string-length($node) &gt; 0 and position() = 1">
									<label>
										<xsl:value-of select="$property/name" />
									</label>
								</xsl:when>
								<xsl:when test="string-length($node) = 0">
									<label>
										<xsl:value-of select="$property/name" />
									</label>
								</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
							<div class="field">
								<div class="input-group full-width">
									<xsl:choose>
										<!-- Отображаем поле ввода -->
										<xsl:when test="$property/type = 0 or $property/type = 1">
											<input type="text" name="{$name}" value="{$value}" class="form-control property-row" />
										</xsl:when>
										<!-- Отображаем файл -->
										<xsl:when test="$property/type = 2">
												<label for="file-upload-{position()}" class="custom-file-upload form-control">
													<input id="file-upload-{position()}" class="property-row" type="file" name="{$name}"/>
												</label>

												<xsl:if test="string-length($node) &gt; 0 and $node/file != ''">
													<a class="input-group-addon green-text" href="{/siteuser/dir}{$node/file}" target="_blank">
														<i class="fa fa-fw fa-picture-o"></i>
													</a>

													<a class="input-group-addon red-text" href="?delete_property_value={$node/@id}" onclick="return confirm('Вы уверены, что хотите удалить?')">
														<i class="fa fa-fw fa-trash"></i>
													</a>
												</xsl:if>
										</xsl:when>
										<!-- Отображаем список -->
										<xsl:when test="$property/type = 3">
											<select name="{$name}" class="wide property-row">
												<option value="0">...</option>
												<xsl:apply-templates select="$property/list/list_item"/>
											</select>
										</xsl:when>
										<!-- Большое текстовое поле, Визуальный редактор -->
										<xsl:when test="$property/type = 4 or $property/type = 6">
											<textarea name="{$name}" class="form-control property-row"><xsl:value-of select="$value" /></textarea>
										</xsl:when>
									</xsl:choose>

									<xsl:if test="$property/multiple = 1 and position() = last()">
										<div class="directory-actions">
											<span onclick="$.addDirectoryRow(this, {$property/type})">
												<i class="fa fa-plus fa-fw"></i>
											</span>
										</div>
										<!-- <a class="input-group-addon gray-text" onclick="$.addPropertyRow(this, {$property/type})">
											<i class="fa fa-fw fa-plus"></i>
										</a>-->
									</xsl:if>
								</div>
							</div>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</div>
	</xsl:template>

	<!-- Внешние свойства -->
	<xsl:template match="properties/property">
		<xsl:if test="type != 10">
			<xsl:variable name="id" select="@id" />
			<xsl:variable name="property" select="." />
			<xsl:variable name="property_value" select="/siteuser/property_value[property_id = $id]" />

			<xsl:choose>
				<xsl:when test="count($property_value)">
					<xsl:for-each select="$property_value">
						<xsl:call-template name="property_values_show">
							<xsl:with-param name="property" select="$property" />
							<xsl:with-param name="node" select="." />
						</xsl:call-template>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="property_values_show">
						<xsl:with-param name="property" select="$property" />
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="list/list_item">
		<!-- Отображаем список -->
		<xsl:variable name="id" select="../../@id" />
		<option value="{@id}">
		<xsl:if test="/siteuser/property_value[property_id=$id]/value = value"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			<xsl:value-of disable-output-escaping="yes" select="value"/>
		</option>
	</xsl:template>

	<xsl:template name="siteuser_company" match="siteuser_company">
		<xsl:variable name="suffix"><xsl:choose><xsl:when test="@id > 0 and name(.) = 'siteuser_company'"><xsl:value-of select="@id" /></xsl:when><xsl:otherwise>[]</xsl:otherwise></xsl:choose></xsl:variable>
		<xsl:variable name="entity_id"><xsl:choose><xsl:when test="@id > 0"><xsl:value-of select="@id" /></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:variable>

		<div style="margin-bottom: 15px;">
			<div class="row">
				<div class="form-group col-12">
					<label>Название</label>
					<div class="field">
						<xsl:variable name="name">
							<xsl:choose>
								<xsl:when test="$entity_id > 0"><xsl:value-of select="name" /></xsl:when>
								<xsl:otherwise><xsl:value-of select="company/company_name" /></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<input type="text" name="company_name{$suffix}" value="{$name}" class="form-control" />
					</div>
				</div>
			</div>

			<div class="row">
				<div class="form-group col-12 col-md-4">
					<label>Индекс</label>
					<div class="field">
						<xsl:variable name="postcode">
							<xsl:choose>
								<xsl:when test="$entity_id > 0"><xsl:value-of select="directory_address/postcode" /></xsl:when>
								<xsl:otherwise><xsl:value-of select="company/company_postcode" /></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<input type="text" name="company_postcode{$suffix}" value="{$postcode}" class="form-control" />
					</div>
				</div>
				<div class="form-group col-12 col-md-4">
					<label>Страна</label>
					<div class="field">
						<xsl:variable name="country">
							<xsl:choose>
								<xsl:when test="$entity_id > 0"><xsl:value-of select="directory_address/country" /></xsl:when>
								<xsl:otherwise><xsl:value-of select="company/company_country" /></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<input type="text" name="company_country{$suffix}" value="{$country}" class="form-control" />
					</div>
				</div>
				<div class="form-group col-12 col-md-4">
					<label>Город</label>
					<div class="field">
						<xsl:variable name="city">
							<xsl:choose>
								<xsl:when test="$entity_id > 0"><xsl:value-of select="directory_address/city" /></xsl:when>
								<xsl:otherwise><xsl:value-of select="company/company_city" /></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<input type="text" name="company_city{$suffix}" value="{$city}" class="form-control" />
					</div>
				</div>
			</div>

			<div class="row">
				<div class="form-group col-12">
					<label>Адрес</label>
					<div class="field">
						<xsl:variable name="address">
							<xsl:choose>
								<xsl:when test="$entity_id > 0"><xsl:value-of select="directory_address/value" /></xsl:when>
								<xsl:otherwise><xsl:value-of select="company/company_address" /></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<input type="text" name="company_address{$suffix}" value="{$address}" class="form-control" />
					</div>
				</div>
			</div>

			<div class="row">
				<div class="form-group col-12">
					<div class="field">
						<fieldset class="account-fieldset">
							<legend>Телефоны</legend>
							<xsl:choose>
								<xsl:when test="count(directory_phone)">
									<xsl:for-each select="directory_phone">
										<xsl:call-template name="siteuser_directory_phone">
											<xsl:with-param name="entity_id" select="../@id" />
											<xsl:with-param name="directory_phone_id" select="@id" />
											<xsl:with-param name="prefix" select="'company'" />
										</xsl:call-template>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="siteuser_directory_phone">
										<xsl:with-param name="entity_id" select="$entity_id" />
										<xsl:with-param name="directory_phone_id" select="'[]'" />
										<xsl:with-param name="prefix" select="'company'" />
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</fieldset>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="form-group col-12">
					<div class="field">
						<fieldset class="account-fieldset">
							<legend>E-mail</legend>
							<xsl:choose>
								<xsl:when test="count(directory_email)">
									<xsl:for-each select="directory_email">
										<xsl:call-template name="siteuser_directory_email">
											<xsl:with-param name="entity_id" select="../@id" />
											<xsl:with-param name="directory_email_id" select="@id" />
											<xsl:with-param name="prefix" select="'company'" />
										</xsl:call-template>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="siteuser_directory_email">
										<xsl:with-param name="entity_id" select="$entity_id" />
										<xsl:with-param name="directory_email_id" select="'[]'" />
										<xsl:with-param name="prefix" select="'company'" />
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</fieldset>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="form-group col-12">
					<div class="field">
						<fieldset class="account-fieldset">
							<legend>Социальные сети</legend>
							<xsl:choose>
								<xsl:when test="count(directory_social)">
									<xsl:for-each select="directory_social">
										<xsl:call-template name="siteuser_directory_social">
											<xsl:with-param name="entity_id" select="../@id" />
											<xsl:with-param name="directory_social_id" select="@id" />
											<xsl:with-param name="prefix" select="'company'" />
										</xsl:call-template>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="siteuser_directory_social">
										<xsl:with-param name="entity_id" select="$entity_id" />
										<xsl:with-param name="directory_social_id" select="'[]'" />
										<xsl:with-param name="prefix" select="'company'" />
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</fieldset>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="form-group col-12">
					<div class="field">
						<fieldset class="account-fieldset">
							<legend>Мессенджеры</legend>
							<xsl:choose>
								<xsl:when test="count(directory_messenger)">
									<xsl:for-each select="directory_messenger">
										<xsl:call-template name="siteuser_directory_messenger">
											<xsl:with-param name="entity_id" select="../@id" />
											<xsl:with-param name="directory_messenger_id" select="@id" />
											<xsl:with-param name="prefix" select="'company'" />
										</xsl:call-template>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="siteuser_directory_messenger">
										<xsl:with-param name="entity_id" select="$entity_id" />
										<xsl:with-param name="directory_messenger_id" select="'[]'" />
										<xsl:with-param name="prefix" select="'company'" />
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</fieldset>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="form-group col-12">
					<div class="field">
						<fieldset class="account-fieldset">
							<legend>Сайты</legend>
							<xsl:choose>
								<xsl:when test="count(directory_website)">
									<xsl:for-each select="directory_website">
										<xsl:call-template name="siteuser_directory_website">
											<xsl:with-param name="entity_id" select="../@id" />
											<xsl:with-param name="directory_website_id" select="@id" />
											<xsl:with-param name="prefix" select="'company'" />
										</xsl:call-template>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="siteuser_directory_website">
										<xsl:with-param name="entity_id" select="$entity_id" />
										<xsl:with-param name="directory_website_id" select="'[]'" />
										<xsl:with-param name="prefix" select="'company'" />
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</fieldset>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="form-group col-12">
					<label>Изображение</label>
					<div class="field">
						<div class="input-group full-width">
							<label for="company-file-upload-{position()}" class="custom-file-upload form-control">
								<input id="company-file-upload-{position()}" class="property-row" type="file" name="company_image{$suffix}"/>
							</label>

							<xsl:if test="image != ''">
								<a id="company-image-popover-{@id}" class="input-group-addon green-text" href="{dir}{image}" target="_blank"  data-trigger="hover" data-placement="top" data-content="&lt;img src='{dir}{image}' /&gt;" data-toggle="popover" data-html="true">
									<i class="fa fa-fw fa-picture-o"></i>
								</a>
							</xsl:if>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="siteuser_person" match="siteuser_person">
		<xsl:variable name="suffix"><xsl:choose><xsl:when test="@id > 0 and name(.) = 'siteuser_person'"><xsl:value-of select="@id" /></xsl:when><xsl:otherwise>[]</xsl:otherwise></xsl:choose></xsl:variable>
		<xsl:variable name="entity_id"><xsl:choose><xsl:when test="@id > 0"><xsl:value-of select="@id" /></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:variable>

		<div style="margin-bottom: 15px;">
			<div class="row">
				<div class="form-group col-12 col-md-4">
					<label>
						Имя
					</label>
					<div class="field">
						<xsl:variable name="name">
							<xsl:choose>
								<xsl:when test="$entity_id > 0"><xsl:value-of select="name" /></xsl:when>
								<xsl:otherwise><xsl:value-of select="person/person_name" /></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<input type="text" name="person_name{$suffix}" value="{$name}" class="form-control" />
					</div>
				</div>
				<div class="form-group col-12 col-md-4">
					<label>
						Фамилия
					</label>
					<div class="field">
						<xsl:variable name="surname">
							<xsl:choose>
								<xsl:when test="$entity_id > 0"><xsl:value-of select="surname" /></xsl:when>
								<xsl:otherwise><xsl:value-of select="person/person_surname" /></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<input type="text" name="person_surname{$suffix}" value="{$surname}" class="form-control" />
					</div>
				</div>
				<div class="form-group col-12 col-md-4">
					<label>
						Отчество
					</label>
					<div class="field">
						<xsl:variable name="patronymic">
							<xsl:choose>
								<xsl:when test="$entity_id > 0"><xsl:value-of select="patronymic" /></xsl:when>
								<xsl:otherwise><xsl:value-of select="person/person_patronymic" /></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<input type="text" name="person_patronymic{$suffix}" value="{$patronymic}" class="form-control" />
					</div>
				</div>
			</div>
			<div class="row">
				<div class="form-group col-12 col-md-4">
					<label>
						Индекс
					</label>
					<div class="field">
						<xsl:variable name="postcode">
							<xsl:choose>
								<xsl:when test="$entity_id > 0"><xsl:value-of select="postcode" /></xsl:when>
								<xsl:otherwise><xsl:value-of select="person/person_postcode" /></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<input type="text" name="person_postcode{$suffix}" value="{$postcode}" class="form-control" />
					</div>
				</div>
				<div class="form-group col-12 col-md-4">
					<label>
						Страна
					</label>
					<div class="field">
						<xsl:variable name="country">
							<xsl:choose>
								<xsl:when test="$entity_id > 0"><xsl:value-of select="country" /></xsl:when>
								<xsl:otherwise><xsl:value-of select="person/person_country" /></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<input type="text" name="person_country{$suffix}" value="{$country}" class="form-control" />
					</div>
				</div>
				<div class="form-group col-12 col-md-4">
					<label>
						Город
					</label>
					<div class="field">
						<xsl:variable name="city">
							<xsl:choose>
								<xsl:when test="$entity_id > 0"><xsl:value-of select="city" /></xsl:when>
								<xsl:otherwise><xsl:value-of select="person/person_city" /></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<input type="text" name="person_city{$suffix}" value="{$city}" class="form-control" />
					</div>
				</div>
			</div>
			<div class="row">
				<div class="form-group col-12">
					<label>
						Адрес
					</label>
					<div class="field">
						<xsl:variable name="address">
							<xsl:choose>
								<xsl:when test="$entity_id > 0"><xsl:value-of select="address" /></xsl:when>
								<xsl:otherwise><xsl:value-of select="person/person_address" /></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<input type="text" name="person_address{$suffix}" value="{$address}" class="form-control" />
					</div>
				</div>
			</div>
			<div class="row">
				<div class="form-group col-12">
					<div class="field">
						<fieldset class="account-fieldset">
							<legend>Телефоны</legend>
							<xsl:choose>
								<xsl:when test="count(directory_phone)">
									<xsl:for-each select="directory_phone">
										<xsl:call-template name="siteuser_directory_phone">
											<xsl:with-param name="entity_id" select="../@id" />
											<xsl:with-param name="directory_phone_id" select="@id" />
											<xsl:with-param name="prefix" select="'person'" />
										</xsl:call-template>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="siteuser_directory_phone">
										<xsl:with-param name="entity_id" select="$entity_id" />
										<xsl:with-param name="directory_phone_id" select="'[]'" />
										<xsl:with-param name="prefix" select="'person'" />
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</fieldset>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="form-group col-12">
					<div class="field">
						<fieldset class="account-fieldset">
							<legend>E-mail</legend>
							<xsl:choose>
								<xsl:when test="count(directory_email)">
									<xsl:for-each select="directory_email">
										<xsl:call-template name="siteuser_directory_email">
											<xsl:with-param name="entity_id" select="../@id" />
											<xsl:with-param name="directory_email_id" select="@id" />
											<xsl:with-param name="prefix" select="'person'" />
										</xsl:call-template>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="siteuser_directory_email">
										<xsl:with-param name="entity_id" select="$entity_id" />
										<xsl:with-param name="directory_email_id" select="'[]'" />
										<xsl:with-param name="prefix" select="'person'" />
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</fieldset>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="form-group col-12">
					<div class="field">
						<fieldset class="account-fieldset">
							<legend>Социальные сети</legend>
							<xsl:choose>
								<xsl:when test="count(directory_social)">
									<xsl:for-each select="directory_social">
										<xsl:call-template name="siteuser_directory_social">
											<xsl:with-param name="entity_id" select="../@id" />
											<xsl:with-param name="directory_social_id" select="@id" />
											<xsl:with-param name="prefix" select="'person'" />
										</xsl:call-template>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="siteuser_directory_social">
										<xsl:with-param name="entity_id" select="$entity_id" />
										<xsl:with-param name="directory_social_id" select="'[]'" />
										<xsl:with-param name="prefix" select="'person'" />
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</fieldset>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="form-group col-12">
					<div class="field">
						<fieldset class="account-fieldset">
							<legend>Мессенджеры</legend>
							<xsl:choose>
								<xsl:when test="count(directory_messenger)">
									<xsl:for-each select="directory_messenger">
										<xsl:call-template name="siteuser_directory_messenger">
											<xsl:with-param name="entity_id" select="../@id" />
											<xsl:with-param name="directory_messenger_id" select="@id" />
											<xsl:with-param name="prefix" select="'person'" />
										</xsl:call-template>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="siteuser_directory_messenger">
										<xsl:with-param name="entity_id" select="$entity_id" />
										<xsl:with-param name="directory_messenger_id" select="'[]'" />
										<xsl:with-param name="prefix" select="'person'" />
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</fieldset>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="form-group col-12">
					<div class="field">
						<fieldset class="account-fieldset">
							<legend>Сайты</legend>
							<xsl:choose>
								<xsl:when test="count(directory_website)">
									<xsl:for-each select="directory_website">
										<xsl:call-template name="siteuser_directory_website">
											<xsl:with-param name="entity_id" select="../@id" />
											<xsl:with-param name="directory_website_id" select="@id" />
											<xsl:with-param name="prefix" select="'person'" />
										</xsl:call-template>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="siteuser_directory_website">
										<xsl:with-param name="entity_id" select="$entity_id" />
										<xsl:with-param name="directory_website_id" select="'[]'" />
										<xsl:with-param name="prefix" select="'person'" />
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</fieldset>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="form-group col-12">
					<label>Изображение</label>
					<div class="field">
						<div class="input-group full-width">
							<label for="person-file-upload-{position()}" class="custom-file-upload form-control">
								<input id="person-file-upload-{position()}" class="property-row" type="file" name="person_image{$suffix}"/>
							</label>

							<xsl:if test="image != ''">
								<a id="person-image-popover-{@id}" class="input-group-addon green-text" href="{dir}{image}" target="_blank"  data-trigger="hover" data-placement="top" data-content="&lt;img src='{dir}{image}' /&gt;" data-toggle="popover" data-html="true">
									<i class="fa fa-fw fa-picture-o"></i>
								</a>
							</xsl:if>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="siteuser_directory_phone">
		<xsl:param name="entity_id"/>
		<xsl:param name="directory_phone_id"/>
		<xsl:param name="prefix"/>

		<div class="row directory-row">
			<div class="col-12 col-md-5">
				<div class="field">

					<xsl:variable name="value"><xsl:choose>
						<xsl:when test="value/node()"><xsl:value-of select="value" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="/siteuser/*[name() = $prefix]/*[name() = concat($prefix, '_', $entity_id, '_phone')]" /></xsl:otherwise>
					</xsl:choose></xsl:variable>

					<input type="text" name="{$prefix}_{$entity_id}_phone{$directory_phone_id}" value="{$value}" class="form-control directory-row-input" />
				</div>
			</div>
			<div class="col-12 col-md-3">
				<div class="field">
					<xsl:variable name="directory_phone_type_id"><xsl:choose>
						<xsl:when test="directory_phone_type_id/node()"><xsl:value-of select="directory_phone_type_id" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="/siteuser/*[name() = $prefix]/*[name() = concat($prefix, '_', $entity_id, '_directory_phone_type')]" /></xsl:otherwise>
					</xsl:choose></xsl:variable>

					<select name="{$prefix}_{$entity_id}_directory_phone_type{$directory_phone_id}" class="wide">
						<xsl:apply-templates select="/siteuser/directory_phone_types/directory_phone_type">
							<xsl:with-param name="directory_phone_type_id" select="$directory_phone_type_id" />
						</xsl:apply-templates>
					</select>
				</div>
			</div>
			<div class="col-6 col-sm-6 col-md-3 account-checkbox">
				<div class="field">
					<xsl:variable name="public"><xsl:choose>
						<xsl:when test="public/node()"><xsl:value-of select="public" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="/siteuser/*[name() = $prefix]/*[name() = concat($prefix, '_', $entity_id, '_phone_public')]" /></xsl:otherwise>
					</xsl:choose></xsl:variable>

					<div class="pretty p-default p-pulse">
						<input type="checkbox" name="{$prefix}_{$entity_id}_phone_public{$directory_phone_id}" value="1"><xsl:if test="$public = 1" ><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input>
						<div class="state p-primary-o">
							<label>Отображать на сайте</label>
						</div>
					</div>
				</div>
			</div>
			<xsl:if test="position() = last()">
				<div class="directory-actions">
					<span onclick="$.addDirectoryRow(this)"><i class="fa fa-plus fa-fw"></i></span>
				</div>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="directory_phone_type">
		<xsl:param name="directory_phone_type_id"/>

		<option value="{@id}">
			<xsl:if test="@id = $directory_phone_type_id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			<xsl:value-of select="name"/>
		</option>
	</xsl:template>

	<xsl:template name="siteuser_directory_email">
		<xsl:param name="entity_id"/>
		<xsl:param name="directory_email_id"/>
		<xsl:param name="prefix"/>

		<div class="row directory-row">
			<div class="col-12 col-md-5">
				<div class="field">
					<xsl:variable name="value"><xsl:choose>
						<xsl:when test="value/node()"><xsl:value-of select="value" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="/siteuser/*[name() = $prefix]/*[name() = concat($prefix, '_', $entity_id, '_email')]" /></xsl:otherwise>
					</xsl:choose></xsl:variable>

					<input type="text" name="{$prefix}_{$entity_id}_email{$directory_email_id}" value="{$value}" class="form-control directory-row-input" />
				</div>
			</div>
			<div class="col-12 col-md-3">
				<div class="field">
					<xsl:variable name="directory_email_type_id"><xsl:choose>
						<xsl:when test="directory_email_type_id/node()"><xsl:value-of select="directory_email_type_id" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="/siteuser/*[name() = $prefix]/*[name() = concat($prefix, '_', $entity_id, '_directory_email_type')]" /></xsl:otherwise>
					</xsl:choose></xsl:variable>

					<select name="{$prefix}_{$entity_id}_directory_email_type{$directory_email_id}" class="wide">
						<xsl:apply-templates select="/siteuser/directory_email_types/directory_email_type">
							<xsl:with-param name="directory_email_type_id" select="$directory_email_type_id" />
						</xsl:apply-templates>
					</select>
				</div>
			</div>
			<div class="col-6 col-sm-6 col-md-3 account-checkbox">
				<div class="field">
					<xsl:variable name="public"><xsl:choose>
						<xsl:when test="public/node()"><xsl:value-of select="public" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="/siteuser/*[name() = $prefix]/*[name() = concat($prefix, '_', $entity_id, '_email_public')]" /></xsl:otherwise>
					</xsl:choose></xsl:variable>

					<div class="pretty p-default p-pulse">
						<input type="checkbox" name="{$prefix}_{$entity_id}_email_public{$directory_email_id}" value="1"><xsl:if test="$public = 1" ><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input>
						<div class="state p-primary-o">
							<label>Отображать на сайте</label>
						</div>
					</div>
				</div>
			</div>
			<xsl:if test="position() = last()">
				<div class="directory-actions">
					<span onclick="$.addDirectoryRow(this)"><i class="fa fa-plus fa-fw"></i></span>
				</div>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="directory_email_type">
		<xsl:param name="directory_email_type_id"/>

		<option value="{@id}">
			<xsl:if test="@id = $directory_email_type_id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			<xsl:value-of select="name"/>
		</option>
	</xsl:template>

	<xsl:template name="siteuser_directory_social">
		<xsl:param name="entity_id"/>
		<xsl:param name="directory_social_id"/>
		<xsl:param name="prefix"/>

		<div class="row directory-row">
			<div class="col-12 col-md-5">
				<div class="field">
					<xsl:variable name="value"><xsl:choose>
						<xsl:when test="value/node()"><xsl:value-of select="value" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="/siteuser/*[name() = $prefix]/*[name() = concat($prefix, '_', $entity_id, '_social')]" /></xsl:otherwise>
					</xsl:choose></xsl:variable>

					<input type="text" name="{$prefix}_{$entity_id}_social{$directory_social_id}" value="{$value}" class="form-control directory-row-input" />
				</div>
			</div>
			<div class="col-12 col-md-3">
				<div class="field">
					<xsl:variable name="directory_social_type_id"><xsl:choose>
						<xsl:when test="directory_social_type_id/node()"><xsl:value-of select="directory_social_type_id" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="/siteuser/*[name() = $prefix]/*[name() = concat($prefix, '_', $entity_id, '_directory_social_type')]" /></xsl:otherwise>
					</xsl:choose></xsl:variable>

					<select name="{$prefix}_{$entity_id}_directory_social_type{$directory_social_id}" class="wide">
						<xsl:apply-templates select="/siteuser/directory_social_types/directory_social_type">
							<xsl:with-param name="directory_social_type_id" select="$directory_social_type_id" />
						</xsl:apply-templates>
					</select>
				</div>
			</div>
			<div class="col-6 col-sm-6 col-md-3 account-checkbox">
				<div class="field">
					<xsl:variable name="public"><xsl:choose>
						<xsl:when test="public/node()"><xsl:value-of select="public" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="/siteuser/*[name() = $prefix]/*[name() = concat($prefix, '_', $entity_id, '_social_public')]" /></xsl:otherwise>
					</xsl:choose></xsl:variable>

					<div class="pretty p-default p-pulse">
						<input type="checkbox" name="{$prefix}_{$entity_id}_social_public{$directory_social_id}" value="1"><xsl:if test="$public = 1" ><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input>
						<div class="state p-primary-o">
							<label>Отображать на сайте</label>
						</div>
					</div>
				</div>
			</div>
			<xsl:if test="position() = last()">
				<div class="directory-actions">
					<span onclick="$.addDirectoryRow(this)"><i class="fa fa-plus fa-fw"></i></span>
				</div>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="directory_social_type">
		<xsl:param name="directory_social_type_id"/>

		<option value="{@id}">
			<xsl:if test="@id = $directory_social_type_id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			<xsl:value-of select="name"/>
		</option>
	</xsl:template>

	<xsl:template name="siteuser_directory_messenger">
		<xsl:param name="entity_id"/>
		<xsl:param name="directory_messenger_id"/>
		<xsl:param name="prefix"/>

		<div class="row directory-row">
			<div class="col-12 col-md-5">
				<div class="field">
					<xsl:variable name="value"><xsl:choose>
						<xsl:when test="value/node()"><xsl:value-of select="value" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="/siteuser/*[name() = $prefix]/*[name() = concat($prefix, '_', $entity_id, '_messenger')]" /></xsl:otherwise>
					</xsl:choose></xsl:variable>

					<input type="text" name="{$prefix}_{$entity_id}_messenger{$directory_messenger_id}" value="{$value}" class="form-control directory-row-input" />
				</div>
			</div>
			<div class="col-12 col-md-3">
				<div class="field">
					<xsl:variable name="directory_messenger_type_id"><xsl:choose>
						<xsl:when test="directory_messenger_type_id/node()"><xsl:value-of select="directory_messenger_type_id" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="/siteuser/*[name() = $prefix]/*[name() = concat($prefix, '_', $entity_id, '_directory_messenger_type')]" /></xsl:otherwise>
					</xsl:choose></xsl:variable>

					<select name="{$prefix}_{$entity_id}_directory_messenger_type{$directory_messenger_id}" class="wide">
						<xsl:apply-templates select="/siteuser/directory_messenger_types/directory_messenger_type">
							<xsl:with-param name="directory_messenger_type_id" select="$directory_messenger_type_id" />
						</xsl:apply-templates>
					</select>
				</div>
			</div>
			<div class="col-6 col-sm-6 col-md-3 account-checkbox">
				<div class="field">
					<xsl:variable name="public"><xsl:choose>
						<xsl:when test="public/node()"><xsl:value-of select="public" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="/siteuser/*[name() = $prefix]/*[name() = concat($prefix, '_', $entity_id, '_messenger_public')]" /></xsl:otherwise>
					</xsl:choose></xsl:variable>

					<div class="pretty p-default p-pulse">
						<input type="checkbox" name="{$prefix}_{$entity_id}_messenger_public{$directory_messenger_id}" value="1"><xsl:if test="$public = 1" ><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input>
						<div class="state p-primary-o">
							<label>Отображать на сайте</label>
						</div>
					</div>
				</div>
			</div>
			<xsl:if test="position() = last()">
				<div class="directory-actions">
					<span onclick="$.addDirectoryRow(this)"><i class="fa fa-plus fa-fw"></i></span>
				</div>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="directory_messenger_type">
		<xsl:param name="directory_messenger_type_id"/>

		<option value="{@id}">
			<xsl:if test="@id = $directory_messenger_type_id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			<xsl:value-of select="name"/>
		</option>
	</xsl:template>

	<xsl:template name="siteuser_directory_website">
		<xsl:param name="entity_id"/>
		<xsl:param name="directory_website_id"/>
		<xsl:param name="prefix"/>

		<div class="row">
			<div class="form-group col-12">
				<div class="field">
					<xsl:variable name="value"><xsl:choose>
						<xsl:when test="value/node()"><xsl:value-of select="value" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="/siteuser/*[name() = $prefix]/*[name() = concat($prefix, '_', $entity_id, '_website')]" /></xsl:otherwise>
					</xsl:choose></xsl:variable>

					<input type="text" name="{$prefix}_{$entity_id}_website{$directory_website_id}" value="{$value}" class="form-control" />
				</div>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>