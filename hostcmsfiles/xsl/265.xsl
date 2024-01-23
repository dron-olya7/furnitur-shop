<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<xsl:template match="/siteuser">
		<xsl:choose>
			<xsl:when test="@id > 0">
				<h1 class="title">Пользователь <xsl:value-of select="login" /></h1>

				<div class="box-user-content">
					<div class="user-orders">
						<div class="row">
							<div class="col-6 col-md-4">
								<h2>Заказы</h2>
							</div>
							<div class="col-6 col-md-8 user-orders-link">
								<a class="btn btn-secondary btn-sm" href="/users/order/">Список заказов</a>
							</div>
						</div>

						<xsl:choose>
							<xsl:when test="shop_order/node()">
								<div class="row table-header d-none d-sm-flex">
									<div class="col-4 col-md-3">
										Номер
									</div>
									<div class="d-none d-sm-block col-md-2">
										Дата
									</div>
									<div class="col-4 col-md-3">
										Сумма
									</div>
									<div class="col-4 col-md-2">
										Статус
									</div>
									<div class="d-none d-sm-block col-md-2"></div>
								</div>

								<xsl:apply-templates select="shop_order"/>
							</xsl:when>
							<xsl:otherwise>
								<div class="alert alert-info" role="alert">
									Список заказов пуст.
								</div>
							</xsl:otherwise>
						</xsl:choose>
					</div>

					<div class="user-tickets">
						<div class="row">
							<div class="col-6 col-md-4">
								<h2>Служба поддержки</h2>
							</div>
							<div class="col-6 col-md-8 user-tickets-add-link">
								<a class="btn btn-third btn-sm" href="/users/helpdesk/"><i class="fa fa-plus"></i>Направить запрос</a>
							</div>
						</div>

						<xsl:choose>
							<xsl:when test="helpdesk_tickets/helpdesk_ticket/node()">
								<div class="row table-header d-none d-sm-flex">
									<div class="col-md-2">
										Номер
									</div>
									<div class="col-md-5">
										Тема
									</div>
									<div class="col-md-2">
										Обработано
									</div>
									<div class="col-md-3">
										Дата
									</div>
								</div>

								<xsl:apply-templates select="helpdesk_tickets/helpdesk_ticket"/>
							</xsl:when>
							<xsl:otherwise>
								<div class="alert alert-info" role="alert">
									Список запросов пуст.
								</div>
							</xsl:otherwise>
						</xsl:choose>
					</div>

					<div class="user-maillists">
						<div class="row">
							<div class="col-12">
								<h2>Почтовые рассылки</h2>
							</div>
						</div>

						<xsl:choose>
							<xsl:when test="maillists/maillist/node()">
								<xsl:apply-templates select="maillists/maillist"/>
							</xsl:when>
							<xsl:otherwise>
								<div class="alert alert-info" role="alert">
									Почтовые рассылки отсутсвуют
								</div>
							</xsl:otherwise>
						</xsl:choose>
					</div>

					<xsl:if test="count(site/siteuser_identity_provider[image != ''][type = 1])">
						<div class="user-maillists">
							<div class="row">
								<div class="col-12">
									<h2>Cоциальные сети</h2>
								</div>
								<div class="col-12 mt-2">
									<xsl:for-each select="site/siteuser_identity_provider[image != ''][type = 1]">
										<xsl:variable name="id" select="@id" />
										<xsl:variable name="bConnected">
											<xsl:choose>
												<xsl:when test="/siteuser/siteuser_identities/siteuser_identity[siteuser_identity_provider_id = $id]">1</xsl:when>
												<xsl:otherwise>0</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<xsl:variable name="class">
											<xsl:choose>
												<xsl:when test="$bConnected = 1">connected</xsl:when>
												<xsl:otherwise>not-connected</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>

										<xsl:element name="a">
											<xsl:if test="$bConnected = 0">
												<xsl:attribute name="href">/users/?oauth_provider=<xsl:value-of select="@id"/><xsl:if test="/siteuser/location/node()">&amp;location=<xsl:value-of select="/siteuser/location"/></xsl:if></xsl:attribute>
											</xsl:if>
											<xsl:attribute name="class">social-icon identity-provider-social-icon</xsl:attribute>
											<span class="identity-provider-wrapper {$class}">
												<img src="{dir}{image}" alt="{name}" title="{name}" width="40" height="40"/>
												<span class="identity-provider-dot"><i class="fa fa-circle"></i></span>
											</span>
										</xsl:element><xsl:text> </xsl:text>
									</xsl:for-each>
								</div>
							</div>
						</div>
					</xsl:if>
				</div>
			</xsl:when>
			<!-- Неавторизованный пользователь -->
			<xsl:otherwise>
				<div class="login-wrapper">
					<div>
						<div class="authorize">
							<h2 class="account-header">Личный кабинет</h2>

							<!-- Выводим ошибку, если она была передана через внешний параметр -->
							<xsl:if test="error/node()">
								<div class="alert alert-danger">
									<xsl:value-of select="error"/>
								</div>
							</xsl:if>

							<form action="/users/" enctype="multipart/form-data" method="POST">
								<div class="row">
									<div class="col-12">
										<div class="input-box">
											<input type="text" name="login" placeholder="Логин" />
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-12">
										<div class="input-box input-box-password">
											<input type="password" name="password" placeholder="Пароль"/>
											<a href="/users/restore_password/">Забыли?</a>
										</div>
									</div>
								</div>
								<div class="pretty p-default p-pulse mb-3">
									<input id="remember" name="remember" type="checkbox" />
									<div class="state p-primary-o">
										<label class="fifth">Запомнить меня на сайте</label>
									</div>
								</div>
								<div class="text-center"><button class="btn btn-secondary w-50" type="submit" name="apply" value="apply">Войти</button></div>

								<!-- Page Redirect after login -->
								<xsl:if test="location/node()">
									<input name="location" type="hidden" value="{location}" />
								</xsl:if>
							</form>
						</div>
					</div>
					<div>
						<div class="authorize">
							<h2 class="account-header">Новый пользователь</h2>
							<form action="/users/registration/" enctype="multipart/form-data" method="POST">
								<div class="row">
									<div class="col-6">
										<div class="input-box">
											<input type="text" name="login" value="{login}" placeholder="Логин"/>
										</div>
									</div>
									<div class="col-6">
										<div class="input-box">
											<input type="password" name="password" placeholder="Пароль"/>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-12">
										<div class="input-box">
											<input type="text" name="email" value="{email}" placeholder="E-mail"/>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-12 col-md-6">
										<div class="input-box">
											<input type="hidden" name="captcha_id" value="{captcha_id}"/>
											<input type="text" name="captcha" size="15" minlength="4" placeholder="Контрольное число"/>
										</div>
									</div>
									<div class="col-12 col-md-6 captcha-refresh" style="margin-bottom: 15px;">
										<img id="registerUser" src="/captcha.php?id={captcha_id}&amp;height=40" class="captcha" name="captcha" />
										<i class="fa fa-refresh" onclick="$('#registerUser').updateCaptcha('{captcha_id}', 40); return false"></i>
									</div>
								</div>
								<!-- <div class="row">
									<div class="col-6">
										<div class="input-box">
											<input type="hidden" name="captcha_id" value="{captcha_id}"/>
											<input type="text" name="captcha" size="15" minlength="4" placeholder="Контрольное число"/>
										</div>
									</div>
								</div>-->

								<!-- Страница редиректа после авторизации -->
								<xsl:if test="location/node()">
									<input name="location" type="hidden" value="{location}" />
								</xsl:if>

								<div class="text-center"><button class="btn btn-secondary" type="submit" name="apply" value="apply">Зарегистрироваться</button></div>
							</form>
						</div>
					</div>
				</div>

				<xsl:if test="count(site/siteuser_identity_provider[image != '' and type = 1])">
					<div class="row">
						<div class="col-12 text-center mt-4">
							<div class="social-authorization">
								<h2 class="account-header">Войти через социальную сеть</h2>
								<div class="mt-2 mb-4">
									<xsl:for-each select="site/siteuser_identity_provider[image != '' and type = 1]">
										<xsl:element name="a">
											<xsl:attribute name="href">/users/?oauth_provider=<xsl:value-of select="@id"/><xsl:if test="/siteuser/location/node()">&amp;location=<xsl:value-of select="/siteuser/location"/></xsl:if></xsl:attribute>
											<xsl:attribute name="class">social-icon</xsl:attribute>
											<img src="{dir}{image}" alt="{name}" title="{name}" />
										</xsl:element><xsl:text> </xsl:text>
									</xsl:for-each>
								</div>
							</div>
						</div>
					</div>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="shop_order">
		<div class="row table-row">
			<div class="col-4 col-md-3">
				<xsl:text>Заказ № </xsl:text><xsl:choose><xsl:when test="invoice != ''"><xsl:value-of select="invoice"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="@id"/></xsl:otherwise></xsl:choose>
			</div>
			<div class="d-none d-sm-block col-md-2">
				<xsl:value-of select="date"/><xsl:text> г.</xsl:text>
			</div>
			<div class="col-4 col-md-3">
				<xsl:value-of select="sum"/>
			</div>
			<div class="col-4 col-md-2">
				<xsl:choose>
					<xsl:when test="paid = 0 and canceled = 0">
						Не оплачен
						<span class="hostcms-label bg-third white"><a href="/shop/cart/print/{guid}/" target="_blank">Оплатить</a></span>
					</xsl:when>
					<xsl:when test="paid = 1">
						Оплачен
					</xsl:when>
					<xsl:when test="canceled = 1">
						Отменен
					</xsl:when>
				</xsl:choose>
			</div>
			<div class="d-none d-sm-block col-md-2">
				<div class="user-order-more"><span class="hostcms-label bg-fifth white"><a href="#" data-toggle="modal" data-target="#modal_{@id}">Подробнее</a></span></div>
			</div>
		</div>

		<!-- Modal -->
		<div class="modal fade" id="modal_{@id}" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
			<div class="modal-dialog modal-lg" role="document">
				<div class="modal-content">
					<div class="modal-header more-order-header">
						<h2 class="modal-title" id="myModalLabel"><xsl:text>Заказ № </xsl:text>
							<xsl:choose>
								<xsl:when test="invoice != ''">
									<xsl:value-of select="invoice"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@id"/>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:text> от </xsl:text><xsl:value-of select="date"/><xsl:text> г.</xsl:text>
						</h2>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true"><i class="fa fa-times"></i></span></button>
					</div>

					<div class="modal-body">
						<xsl:if test="shop_order_status/node()">
							<div class="user-order-status">
								Статус:&#xA0;<b><xsl:value-of select="shop_order_status/name"/></b><xsl:if test="status_datetime != '0000-00-00 00:00:00'">, <xsl:value-of select="status_datetime"/></xsl:if>.
							</div>

							<!-- <xsl:choose>
								<xsl:when test="paid = 0 and canceled = 0">
									<div class="databox-state bg-azure" title="Принят">
										<i class="fa fa-plus"></i>
									</div>
								</xsl:when>
								<xsl:when test="paid = 1">
									<div class="databox-state bg-third" title="Оплачен">
										<i class="fa fa-check"></i>
									</div>
								</xsl:when>
								<xsl:when test="canceled = 1">
									<div class="databox-state bg-red" title="Отменен">
										<i class="fa fa-times"></i>
									</div>
								</xsl:when>
							</xsl:choose>-->
						</xsl:if>
						<div class="row user-order-modal">
							<div class="user-orders">
								<div class="col-12">
									<div class="row table-header">
										<div class="col-1">
											#
										</div>
										<div class="col-1"></div>
										<div class="col-3">
											Название
										</div>
										<div class="col-2">
											Цена
										</div>
										<div class="col-2">
											Количество
										</div>
										<div class="col-2">
											Сумма
										</div>
									</div>
									<xsl:apply-templates select="shop_order_item" mode="shop_order"/>
								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-12 mt-2">
								<span class="order-total">Итого:<xsl:text> </xsl:text><xsl:value-of select="sum"/></span>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="shop_order_item" mode="shop_order">
		<div class="row table-row">
			<div class="col-1">
				<span class="item-position"><xsl:value-of select="position()"/></span>
			</div>
			<div class="col-1">
				<xsl:if test="shop_item/image_small != ''">
					<img width="30" src="{shop_item/dir}{shop_item/image_small}" title="{shop_item/name}" alt="{shop_item/name}"/>
				</xsl:if>
			</div>
			<div class="col-3">
				<xsl:value-of select="name"/>
			</div>
			<div class="col-2">
				<xsl:value-of select="format-number(price,'### ##0,00', 'my')"/>
				<!-- If show currency -->
				<xsl:if test="../shop_currency/sign != ''"><xsl:text> </xsl:text><xsl:value-of select="../shop_currency/sign" disable-output-escaping="yes"/></xsl:if>
			</div>
			<div class="col-2">
				<xsl:value-of select="quantity"/>
			</div>
			<div class="col-2">
				<xsl:value-of select="format-number(price * quantity,'### ##0,00', 'my')"/><xsl:text> </xsl:text><xsl:value-of select="../shop_currency/sign" disable-output-escaping="yes"/>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="helpdesk_tickets/helpdesk_ticket">
		<div class="row table-row">
			<div class="col-xs-12 col-md-2">
				<span><a href="/users/helpdesk/ticket-{@id}/"><xsl:value-of select="number"/></a></span>
			</div>
			<div class="col-xs-12 col-md-5">
				<xsl:choose>
					<xsl:when test="helpdesk_ticket_subject != ''">
						<xsl:value-of select="helpdesk_ticket_subject"/>
					</xsl:when>
					<xsl:otherwise><xsl:text>[Без темы]</xsl:text></xsl:otherwise>
				</xsl:choose>

				<xsl:if test="open = 0">
					<i class="fa fa-lock" title="Закрыт"></i>
				</xsl:if>
			</div>
			<div class="d-none d-sm-block col-md-2">
				<span class="hostcms-label fifth"><xsl:value-of select="processed_messages_count"/><xsl:text>/</xsl:text><xsl:value-of select="messages_count"/></span>
			</div>
			<div class="d-none d-sm-block col-md-3">
				<xsl:value-of select="datetime"/>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="maillist">
		<div class="row user-maillist-row align-items-center">
			<div class="col-12 col-sm-4 col-md-4 col-lg-4 user-maillists-name">
				<xsl:value-of select="name"/>
			</div>
			<div class="col-6 col-sm-4 col-md-4 col-lg-4">
				<select name="type_{@id}" id="type_{@id}" class="wide">
					<xsl:if test="maillist_siteuser/node()">
						<xsl:attribute name="disabled">disabled</xsl:attribute>
					</xsl:if>

					<option value="0">
						<xsl:if test="maillist_siteuser/node() and maillist_siteuser/type = 0">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						Текст
					</option>
					<option value="1">
						<xsl:if test="maillist_siteuser/node() and maillist_siteuser/type = 1">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						HTML
					</option>
				</select>
			</div>
			<div class="col-6 col-sm-4 col-md-4 col-lg-4 user-maillist-buttons">
				<xsl:choose>
					<xsl:when test="maillist_siteuser/node()">
						<span class="btn btn-sm ">Подписан</span>
					</xsl:when>
					<xsl:otherwise>
						<span id="subscribed_{@id}" class="btn btn-sm hidden">Подписан</span>
						<a id="subscribe_{@id}" class="btn btn-sm" onclick="$.subscribeMaillist('maillist/', '{@id}', $('#type_{@id}').val())">Подписаться</a>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>