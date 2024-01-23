<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:template match="/">
		<div class="item-page">
			<xsl:apply-templates select="/informationsystem/informationsystem_item"/>
		</div>
	</xsl:template>

	<xsl:template match="informationsystem_item">
		<h1 class="title text-center"><xsl:value-of select="name"/></h1>

		<div class="date">
			<xsl:call-template name="date_to_str">
				<xsl:with-param name="date" select="date" />
			</xsl:call-template>
		</div>

		<div class="image text-center">
			<!-- <a href="{url}"> -->
				<img class="img-fluid" src="{dir}{image_small}" alt="{name}"/>
			<!-- </a> -->
		</div>

		<div class="text"><xsl:value-of disable-output-escaping="yes" select="text"/></div>

		<xsl:if test="/informationsystem/show_comments/node() and /informationsystem/show_comments = 1">
			<xsl:choose>
				<xsl:when test="count(comment)">
					<div class="reviews">
						<!-- <div class="col-12"> -->
							<xsl:apply-templates select="comment[parent_id = 0]"/>
						<!-- </div> -->
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div class="alert alert-info item-text">Отзывы отсутствуют.</div>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>

		<!-- If allowed to display add comment form,
		1 - Only authorized
		2 - All
		-->
		<xsl:if test="/informationsystem/show_add_comments/node() and ((/informationsystem/show_add_comments = 1 and /informationsystem/siteuser_id &gt; 0)  or /informationsystem/show_add_comments = 2)">
			<div class="action text-center">
				<a class="btn btn-transparent" onclick="$('.action').hide();$('#AddComment').show()">Написать отзыв</a>
			</div>

			<div class="row">
				<div class="col-12">
					<div id="AddComment" class="comment_reply">
						<xsl:call-template name="AddCommentForm"></xsl:call-template>
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template name="AddCommentForm">
		<xsl:param name="id" select="0"/>

		<!-- Заполняем форму -->
		<xsl:variable name="subject">
			<xsl:if test="/informationsystem/comment/parent_id/node() and /informationsystem/comment/parent_id/node() and /informationsystem/comment/parent_id= $id">
				<xsl:value-of select="/informationsystem/comment/subject"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="email">
			<xsl:if test="/informationsystem/comment/email/node() and /informationsystem/comment/parent_id/node() and /informationsystem/comment/parent_id= $id">
				<xsl:value-of select="/informationsystem/comment/email"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="phone">
			<xsl:if test="/informationsystem/comment/parent_id/node() and /informationsystem/comment/parent_id/node() and /informationsystem/comment/parent_id= $id">
				<xsl:value-of select="/informationsystem/form_user_phone"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="text">
			<xsl:if test="/informationsystem/comment/text/node() and /informationsystem/comment/parent_id/node() and /informationsystem/comment/parent_id= $id">
				<xsl:value-of select="/informationsystem/comment/text"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="name">
			<xsl:if test="/informationsystem/comment/author/node() and /informationsystem/comment/parent_id/node() and /informationsystem/comment/parent_id= $id">
				<xsl:value-of select="/informationsystem/comment/author"/>
			</xsl:if>
		</xsl:variable>

		<div class="row">
			<div class="col-12">
				<div class="form-wrapper">
					<form action="{/informationsystem/shop_item/url}" id="review" class="show" name="comment_form_0{$id}" method="post" enctype="multipart/form-data">
						<!-- Авторизированным не показываем -->
						<xsl:if test="/informationsystem/siteuser_id = 0">
							<div class="form-group">
								<label for="name">Имя</label>
								<input name="name" type="text" class="form-control" id="name" value="{$name}"/>
							</div>
							<div class="form-group">
								<label for="email">E-mail</label>
								<input name="email" type="text" class="form-control" id="email" value="{$email}"/>
							</div>
							<div class="form-group">
								<label for="phone">Телефон</label>
								<input name="phone" type="text" class="form-control" id="phone" value="{$phone}"/>
							</div>
						</xsl:if>
						<div class="form-group">
							<label for="subject">Тема</label>
							<input name="subject" type="text" class="form-control" id="subject" value="{$subject}"/>
						</div>
						<div class="form-group">
							<label for="textarea_text">Комментарий</label>
							<textarea rows="5" name="text" class="form-control" id="textarea_text">
								<xsl:value-of select="$text"/>
							</textarea>
						</div>
						<div class="form-group">
							<div class="row">
								<div class="col-12">
									<div class="stars">
										<select name="grade" onchange="alert(1)">
											<option value="1">Poor</option>
											<option value="2">Fair</option>
											<option value="3">Average</option>
											<option value="4">Good</option>
											<option value="5">Excellent</option>
										</select>
									</div>
								</div>
							</div>
						</div>

						<!-- Обработка CAPTCHA -->
						<xsl:if test="//captcha_id != 0 and /informationsystem/siteuser_id = 0">
							<div class="form-group">
								<!-- <label for="textarea_text"></label> -->
								<div class="captcha captcha-refresh">
									<img id="comment_{$id}" class="captcha lazyload" data-src="/captcha.php?id={//captcha_id}{$id}&amp;height=30&amp;width=100" title="Контрольное число" name="captcha"/>
									<img src="/images/refresh.png" />
									<span onclick="$('#comment_{$id}').updateCaptcha('{//captcha_id}{$id}', 30); return false">Показать другое число</span>
								</div>
							</div>
							<div class="row">
								<div class="form-group col-12 col-md-6">
									<label for="captcha">Контрольное число<sup><font color="red">*</font></sup></label>
									<div class="field">
										<input type="hidden" name="captcha_id" value="{//captcha_id}{$id}"/>
										<input type="text" name="captcha" size="15" class="form-control" minlength="4" title="Введите число, которое указано выше."/>
									</div>
								</div>
							</div>
						</xsl:if>

						<div class="form-group">
							<div class="row">
							<div class="col-12 text-center">
								<button id="submit_email{$id}" type="submit" class="btn" name="add_comment" value="add_comment">Опубликовать</button>
							</div>
							</div>
						</div>
						<input type="hidden" name="parent_id" value="{$id}"/>
					</form>
				</div>
			</div>
		</div>
	</xsl:template>

	<!-- Отображение комментариев -->
	<xsl:template match="comment">
		<!-- Отображаем комментарий, если задан текст или тема комментария -->
		<xsl:if test="text != '' or subject != ''">
			<a name="comment{@id}"></a>

			<ul class="media-list">
				<li class="media">
					<xsl:apply-templates select="." mode="comment_node"/>
				</li>
			</ul>
		</xsl:if>
	</xsl:template>

	<xsl:template match="comment" mode="sub_comment">
		<div class="media">
			<xsl:apply-templates select="." mode="comment_node"/>
		</div>
	</xsl:template>

	<xsl:template match="comment" mode="comment_node">
		<div class="media-left">
			<div class="avatar-inner">
				<xsl:choose>
					<xsl:when test="siteuser/property_value[tag_name = 'avatar']/file != ''">
						<img data-src="{siteuser/dir}{siteuser/property_value[tag_name = 'avatar']/file}" class="lazyload" />
					</xsl:when>
					<xsl:otherwise>
						<img alt="{siteuser/login}" data-src="/hostcmsfiles/forum/avatar.gif" class="lazyload"/>
					</xsl:otherwise>
				</xsl:choose>
			</div>
			<div class="rating">
				<xsl:if test="grade != 0">
					<span><xsl:call-template name="show_average_grade">
							<xsl:with-param name="grade" select="grade"/>
							<xsl:with-param name="const_grade" select="5"/>
					</xsl:call-template></span>
				</xsl:if>
			</div>
		</div>
		<div class="media-body">
			<h4 class="media-heading">
				<xsl:choose>
					<xsl:when test="subject != ''">
						<xsl:value-of select="subject"/>
					</xsl:when>
					<xsl:otherwise>Без темы</xsl:otherwise>
				</xsl:choose>
			</h4>

			<p><xsl:value-of disable-output-escaping="yes" select="text"/></p>

			<div class="review-info">
				<xsl:if test="/informationsystem/show_add_comments/node()
					and ((/informationsystem/show_add_comments = 1 and /informationsystem/siteuser_id > 0)
					or /informationsystem/show_add_comments = 2)">
					<span class="review-answer" onclick="$('.action').hide();$('#AddComment input[name=\'parent_id\']').val('{@id}');$('#AddComment').show()">Ответить</span>
				</xsl:if>

				<span><xsl:value-of select="datetime"/></span>

				<i class="fa fa-user"></i>
				<span>
					<xsl:choose>
						<!-- Комментарий добавил авторизированный пользователь -->
						<xsl:when test="count(siteuser)">
							<a href="/users/info/{siteuser/path}/"><xsl:value-of select="siteuser/login"/></a>
						</xsl:when>
						<!-- Комментарй добавил неавторизированный пользователь -->
						<xsl:otherwise>
							<span><xsl:value-of select="author" /></span>
						</xsl:otherwise>
					</xsl:choose>
				</span>
			</div>

			<xsl:if test="count(comment)">
				<xsl:apply-templates select="comment" mode="sub_comment"/>
			</xsl:if>
		</div>
	</xsl:template>

	<!-- Star Rating -->
	<xsl:template name="show_average_grade">
		<xsl:param name="grade" select="0"/>
		<xsl:param name="const_grade" select="0"/>

		<!-- To avoid loops -->
		<xsl:variable name="current_grade" select="$grade * 1"/>

		<xsl:choose>
			<!-- If a value is an integer -->
			<xsl:when test="floor($current_grade) = $current_grade and not($const_grade &gt; ceiling($current_grade))">

				<xsl:if test="$current_grade - 1 &gt; 0">
					<xsl:call-template name="show_average_grade">
						<xsl:with-param name="grade" select="$current_grade - 1"/>
						<xsl:with-param name="const_grade" select="$const_grade - 1"/>
					</xsl:call-template>
				</xsl:if>

				<xsl:if test="$current_grade != 0">
					<img src="/images/star-full.png"/>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$current_grade != 0 and not($const_grade &gt; ceiling($current_grade))">

				<xsl:if test="$current_grade - 0.5 &gt; 0">
					<xsl:call-template name="show_average_grade">

						<xsl:with-param name="grade" select="$current_grade - 0.5"/>
						<xsl:with-param name="const_grade" select="$const_grade - 1"/>
					</xsl:call-template>
				</xsl:if>

				<img src="/images/star-half.png"/>
			</xsl:when>

			<!-- Show the gray stars until the current position does not reach the value increased to an integer -->
			<xsl:otherwise>
				<xsl:call-template name="show_average_grade">
					<xsl:with-param name="grade" select="$current_grade"/>
					<xsl:with-param name="const_grade" select="$const_grade - 1"/>
				</xsl:call-template>
				<img src="/images/star-empty.png"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Вывод даты с месяцем на русском -->
	<xsl:template name="date_to_str">
		<xsl:param name="date" select="date"/>

		<xsl:variable select="substring-after($date, '.')" name="month_postfixDate" />
		<xsl:variable select="substring-before($month_postfixDate, '.')" name="month" />

		<xsl:value-of select="substring-before($date, '.')"/>&#160;<xsl:choose>
			<xsl:when test="$month = 1">января</xsl:when>
			<xsl:when test="$month = 2">февраля</xsl:when>
			<xsl:when test="$month = 3">марта</xsl:when>
			<xsl:when test="$month = 4">апреля</xsl:when>
			<xsl:when test="$month = 5">мая</xsl:when>
			<xsl:when test="$month = 6">июня</xsl:when>
			<xsl:when test="$month = 7">июля</xsl:when>
			<xsl:when test="$month = 8">августа</xsl:when>
			<xsl:when test="$month = 9">сентября</xsl:when>
			<xsl:when test="$month = 10">октября</xsl:when>
			<xsl:when test="$month = 11">ноября</xsl:when>
			<xsl:otherwise>декабря</xsl:otherwise>
		</xsl:choose>&#160;<xsl:value-of select="substring-after($month_postfixDate, '.')"/> г.
	</xsl:template>

</xsl:stylesheet>