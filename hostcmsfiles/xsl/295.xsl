<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<!-- Анкетные данные -->
	<xsl:template match="/siteuser">
		<xsl:choose>
			<!-- Пользователь отсутствует или у него не подтверждена регистрация -->
			<xsl:when test="not(login/node())">
				<h1 class="title">Пользователь не найден</h1>

				<div class="row">
					<div class="col-12 col-md-8 col-md-offset-2">
						<div class="alert alert-warning" role="alert">
							Пользователь незарегистрирован или не подтвердил регистрацию.
						</div>
					</div>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<h1 class="title"><xsl:value-of select="login"/></h1>

				<!-- <div class="clearing"></div> -->

				<!-- ОТКЛЮЧЕНО!!!!! -->
				<xsl:if test="0">
					<xsl:variable name="current_siteuser_id" select="/siteuser/current_siteuser_id" />
					<xsl:choose>
						<xsl:when test="/siteuser/current_siteuser_relation/siteuser_relationship[siteuser_id = $current_siteuser_id]/node() and /siteuser/current_siteuser_relation/siteuser_relationship[recipient_siteuser_id = $current_siteuser_id]/node()">
							<!-- вы взаимные друзья. -->
						<span class="button" onclick="$.clientRequest({{path: '?removeFriend', 'callBack': $.friendOperations, context: $(this)}}); return false">Убрать из друзей</span>
						</xsl:when>
						<xsl:when test="/siteuser/current_siteuser_relation/siteuser_relationship[siteuser_id = $current_siteuser_id]/node()">
							<!-- вы подписчик. -->
						<span class="button" onclick="$.clientRequest({{path: '?removeFriend', 'callBack': $.friendOperations, context: $(this)}}); return false">Отписаться</span>
						</xsl:when>
						<xsl:when test="/siteuser/@id != $current_siteuser_id">
						<span class="button" onclick="$.clientRequest({{path: '?addFriend', 'callBack': $.friendOperations, context: $(this)}}); return false">Добавить в друзья</span>
						</xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>

					<div class="clearing"></div>
				</xsl:if>

				<div class="row">
					<div class="col-12 offset-md-4 col-md-2 text-center">
						<xsl:choose>
							<xsl:when test="property_value[tag_name = 'avatar']/file != ''">
								<!-- Отображаем картинку-аватарку -->
								<img src="{dir}{property_value[tag_name = 'avatar']/file}" alt="" class="userAvatar"/>
							</xsl:when>
							<xsl:otherwise>
								<!-- Отображаем картинку, символизирующую пустую аватарку -->
								<img src="/hostcmsfiles/forum/avatar.gif" alt="" class="userAvatar"/>
							</xsl:otherwise>
						</xsl:choose>
					</div>
					<div class="col-12 col-md-4">
						<div class="siteuser-info">
							<!-- Проверяем, указано ли имя -->
							<xsl:if test="name != ''">
								<p>
									<i class="fa fa-user fa-fw"></i>
									<span><xsl:value-of select="name" /></span>
								</p>
							</xsl:if>

							<!-- E-mail -->
							<xsl:if test="property_value[tag_name = 'public_email']/value != 0">
								<p>
									<i class="fa fa-envelope-o fa-fw"></i>
									<span><a href="mailto:{email}">	<xsl:value-of select="email"/></a></span>
								</p>
							</xsl:if>

							<!-- Страна -->
							<xsl:if test="country != ''">
								<p>
									<i class="fa fa-map-marker fa-fw"></i>
									<span><xsl:value-of select="country" /></span>
								</p>
							</xsl:if>

							<!-- Город -->
							<xsl:if test="city != ''">
								<p>
									<i class="fa fa-map-marker fa-fw"></i>
									<span><xsl:value-of select="city" /></span>
								</p>
							</xsl:if>

							<!-- Компания -->
							<xsl:if test="company != ''">
								<p>
									<i class="fa fa-building-o fa-fw"></i>
									<span><xsl:value-of select="company" /></span>
								</p>
							</xsl:if>

							<!-- Телефон -->
							<xsl:if test="phone != ''">
								<p>
									<i class="fa fa-phone fa-fw"></i>
									<span><xsl:value-of select="phone" /></span>
								</p>
							</xsl:if>

							<!-- Факс -->
							<xsl:if test="fax != ''">
								<p>
									<i class="fa fa-fax fa-fw"></i>
									<span><xsl:value-of select="fax" /></span>
								</p>
							</xsl:if>

							<xsl:variable name="url">
								<xsl:choose>
									<xsl:when test="starts-with(website, 'http://') or starts-with(website, 'https://')"><xsl:value-of select="website"/></xsl:when>
									<xsl:when test="website != ''">http://<xsl:value-of select="website"/></xsl:when>
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							<!-- Сайт -->
							<xsl:if test="$url != ''">
								<p>
									<i class="fa fa-globe fa-fw"></i>
									<span><a href="{$url}" rel="nofollow" target="_blank">	<xsl:value-of select="website"/></a></span>
								</p>
							</xsl:if>

							<!-- ICQ -->
							<!-- <xsl:if test="icq != ''">
								<p>
									<span>ICQ: </span>
									<strong><img src="http://status.icq.com/online.gif?icq={icq}&#38;img=5" alt="Статус ICQ" title="Статус ICQ" style="position: relative; top: 4px;"/> <xsl:value-of select="icq"/></strong>
								</p>
							</xsl:if> -->

							<!-- Зарегистрирован -->
							<xsl:if test="date != ''">
								<p>
									<i class="fa fa-clock-o fa-fw"></i>
									<span><xsl:value-of select="date"/> г.</span>
								</p>
							</xsl:if>
						</div>
					</div>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="siteuser_relationship_type">
		<!-- Вывод просто друзей или в гурппе есть друзья -->
		<xsl:if test="count(siteuser_relationship)">
			<dl>
				<dt>
					<!-- Название группы -->
					<xsl:choose>
						<xsl:when test="@id = 0">Друзья:</xsl:when>
						<xsl:otherwise><xsl:value-of select="name" />:</xsl:otherwise>
					</xsl:choose>
				</dt>
				<dd>
					<xsl:variable name="current_siteuser_id" select="/siteuser/current_siteuser_id" />

					<xsl:if test="0 = 1 and @id = 0">
						<xsl:choose>
							<xsl:when test="/siteuser/current_siteuser_relation/siteuser_relationship[siteuser_id = $current_siteuser_id]/node() and /siteuser/current_siteuser_relation/siteuser_relationship[recipient_siteuser_id = $current_siteuser_id]/node()">
								<!-- вы взаимные друзья. -->
								<a title="Убрать из друзей" onclick="$.clientRequest({{path: '?removeFriend', 'callBack': $.friendOperations, context: $(this)}}); return false">Убрать из друзей</a>
							</xsl:when>
							<xsl:when test="/siteuser/current_siteuser_relation/siteuser_relationship[siteuser_id = $current_siteuser_id]/node()">
								<!-- вы подписчик. -->
								<a title="Отписаться" onclick="$.clientRequest({{path: '?removeFriend', 'callBack': $.friendOperations, context: $(this)}}); return false">Отписаться</a>
							</xsl:when>
							<xsl:when test="/siteuser/@id != $current_siteuser_id">
								<a title="Добавить в друзья" onclick="$.clientRequest({{path: '?addFriend', 'callBack': $.friendOperations, context: $(this)}}); return false">Добавить в друзья</a>
							</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</xsl:if>

					<!-- Друзья -->
					<div>
						<xsl:for-each select="siteuser_relationship">
							<a href="/users/info/{siteuser/path}/"><xsl:value-of select="siteuser/login"/></a>
							<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
						</xsl:for-each>
					</div>
				</dd>
			</dl>
		</xsl:if>
	</xsl:template>

	<xsl:template match="siteuser_relationship_type" mode="friendlist">
		<option value="{@id}">
			<xsl:value-of select="name"/>
		</option>
	</xsl:template>

</xsl:stylesheet>