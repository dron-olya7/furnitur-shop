<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	xmlns:exsl="http://exslt.org/common"
	extension-element-prefixes="exsl"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:template match="/">
		<SCRIPT type="text/javascript">
			<xsl:comment>
				<xsl:text disable-output-escaping="yes">
					<![CDATA[
					$(function() {
					$('.addFile').click(function(){
					r = $(this).parents('.form-group');
					r2 = r.clone();
					r2.find('.caption').text('');
					r2.find('span').remove();
					r.after(r2);
					return false;
					});
					});
					]]>
				</xsl:text>
			</xsl:comment>
		</SCRIPT>

		<div class="row margin-bottom-30">
			<xsl:apply-templates select="helpdesk/helpdesk_ticket" />
		</div>
	</xsl:template>

	<!-- ВыводСпискаСообщенийТикета -->
	<xsl:template match="helpdesk_ticket">
		<div class="col-12">
			<div class="box-user-content no-margin-top">
				<div class="row">
					<div class="col-12">
						<div class="user-tickets">

							<xsl:if test="error_message/node()">
								<div class="alert alert-danger alert-cart">
									<xsl:value-of disable-output-escaping="yes" select="error_message"/>
								</div>
							</xsl:if>

							<div class="row margin-bottom-20">
								<div class="col-12">
									<h2>
										<xsl:choose>
											<xsl:when test="helpdesk_ticket_subject != ''">
												<xsl:value-of select="helpdesk_ticket_subject"/>
											</xsl:when>
										<xsl:otherwise><xsl:text>[Без темы]</xsl:text></xsl:otherwise>
										</xsl:choose>
										<xsl:text> — [</xsl:text><xsl:value-of select="number"/>]
									</h2>
								</div>
							</div>

							<div class="row margin-bottom-20">
								<div class="col-12">
									<button class="btn btn-sm mb-4" onclick="$('#AddMessage').toggle('slow')"><i class="fa fa-plus" ></i>Добавить сообщение</button>

									<div id="AddMessage" style="display: none" class="margin-top-10 margin-bottom-20">
										<xsl:call-template name="AddReplyForm"></xsl:call-template>
									</div>
								</div>
							</div>

							<xsl:if test="count(helpdesk_message[parent_id = 0])">
								<div class="helpdesk-messages"><xsl:apply-templates select="helpdesk_message[parent_id = 0]" /></div>
							</xsl:if>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

	<!-- Шаблон для вывода сообщения -->
	<xsl:template match="helpdesk_message">
		<div id="{@id}" class="comment helpdesk-message-block">
			<div class="subject">
				<xsl:value-of select="subject" />
			</div>

			<div>
				<xsl:value-of select="message" disable-output-escaping="yes" />
			</div>

			<div class="helpdesk-message-info">
				<!-- Оценка сообщения - только для исходящих -->
				<xsl:if test="inbox = 0">
					<!-- <span><xsl:call-template name="show_grade">
							<xsl:with-param name="grade" select="grade"/>
							<xsl:with-param name="const_grade" select="5"/>
					</xsl:call-template></span> -->

					<xsl:variable name="options">
						<option value="1">Poor</option>
						<option value="2">Fair</option>
						<option value="3">Average</option>
						<option value="4">Good</option>
						<option value="5">Excellent</option>
					</xsl:variable>

					<xsl:variable name="grade" select="grade" />

					<div id="grade{@id}">
						<select name="grade">
							<xsl:for-each select="exsl:node-set($options)/option">
								<option value="{@value}">
									<xsl:if test="@value = $grade">
										<xsl:attribute name="selected">selected</xsl:attribute>
									</xsl:if>
									<xsl:value-of select="." />
								</option>
							</xsl:for-each>
						</select>
					</div>
				<span><xsl:text> </xsl:text></span>

					<SCRIPT>
						$(function() {
						$('#grade<xsl:value-of select="@id" />').stars({inputType: "select", disableValue: false, callback: function(object, type, value, e){
						$.ajax({
						url: './',
						type: "POST",
						dataType: "json",
						data: {ajaxGrade: 1, value: value, id: '<xsl:value-of select="@id" />'}
						});
						}
						});
						});
					</SCRIPT>
				</xsl:if>

				<span class="message-answer" onclick="$('#cr_{@id}').toggle('slow')">Ответить</span>

				<xsl:if test="user/node() or ../siteuser/node()">
					<i class="fa fa-user"></i>
					<span>
						<xsl:choose>
							<!-- Сообщение добавил пользователь сайта -->
							<xsl:when test="inbox = 1">
								<xsl:value-of select="../siteuser/login"/>
							</xsl:when>
							<!-- Сообщение добавил пользователь центра администрирования-->
							<xsl:otherwise>
							<xsl:value-of select="user/position"/><xsl:text> </xsl:text><xsl:value-of select="user/name"/><xsl:text> </xsl:text><xsl:value-of select="user/surname"/>
							</xsl:otherwise>
						</xsl:choose>
					</span>
				</xsl:if>

				<span class="hidden-xs"><xsl:value-of select="datetime"/></span>
			</div>

			<xsl:if test="helpdesk_attachment/node()">
				<!-- <div class="margin-top-10">
					Прикрепленные файлы:
				</div> -->
				<div class="attachments-wrapper">

					<!-- <ul style="list-style-type: none; margin-top: 5px; padding-left: 5px"> -->
						<xsl:apply-templates select="helpdesk_attachment"/>
					<!-- </ul> -->
				</div>
			</xsl:if>
		</div>

		<div class="comment_reply" id="cr_{@id}">
			<xsl:call-template name="AddReplyForm">
				<xsl:with-param name="message_id" select="@id"/>
				<xsl:with-param name="message_parent_id" select="@id"/>
				<xsl:with-param name="message_comment_subject">Re: <xsl:value-of select="subject" /></xsl:with-param>
			</xsl:call-template>
		</div>

		<!-- Выбираем дочерние сообщения-->
		<xsl:variable name="id" select="@id"/>
		<xsl:if test="count(//helpdesk_message[parent_id = $id]) > 0">
			<div class="helpdesk-message-margin">
				<xsl:apply-templates select="../helpdesk_message[parent_id = $id]"/>
			</div>
		</xsl:if>
	</xsl:template>

	<!-- Оценка -->
	<xsl:template name="show_grade">
		<xsl:param name="grade" select="0"/>
		<xsl:param name="const_grade" select="0"/>

		<!-- Чтобы избежать зацикливания -->
		<xsl:variable name="current_grade" select="$grade * 1"/>

		<xsl:choose>
			<!-- Если число целое -->
			<xsl:when test="not($const_grade &gt; $current_grade)">
				<xsl:if test="$current_grade - 1 &gt; 0">
					<xsl:call-template name="show_grade">
						<xsl:with-param name="grade" select="$current_grade - 1"/>
						<xsl:with-param name="const_grade" select="$const_grade - 1"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="$current_grade != 0">
					<img src="/images/star-full.png"/>
				</xsl:if>
			</xsl:when>
			<!--
			<xsl:when test="$current_grade != 0 and not($const_grade &gt; ceiling($current_grade))">

				<xsl:if test="$current_grade - 0.5 &gt; 0">
					<xsl:call-template name="show_average_grade">

						<xsl:with-param name="grade" select="$current_grade - 0.5"/>
						<xsl:with-param name="const_grade" select="$const_grade - 1"/>
					</xsl:call-template>
				</xsl:if>

				<img src="/images/star-half.png"/>
			</xsl:when>
			-->

			<!-- Выводим серые звездочки, пока текущая позиция не дойдет то значения, увеличенного до целого -->
			<xsl:otherwise>
				<xsl:call-template name="show_grade">
					<xsl:with-param name="grade" select="$current_grade"/>
					<xsl:with-param name="const_grade" select="$const_grade - 1"/>
				</xsl:call-template>
				<img src="/images/star-empty.png"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:variable name="lowCase">абвгдеёжзийклмнопрстуфхцчшщыъьэюяabcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="upCase">АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЫЪЬЭЮЯABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

	<xsl:template name="upper">
		<xsl:param name="str" />
		<xsl:value-of select="translate($str, $lowCase, $upCase)"/>
	</xsl:template>

	<xsl:template name="lower">
		<xsl:param name="str" />
		<xsl:value-of select="translate($str, $upCase, $lowCase)"/>
	</xsl:template>

	<!-- Вывод вложенных файлов сообщения -->
	<xsl:template match="helpdesk_attachment">
		<!-- Ссылка на вложенный файл -->
		<!-- Определяем ссылку -->
		<xsl:variable name="attachment">./?get_attachment_id=<xsl:value-of select="@id"/></xsl:variable>

		<xsl:variable name="file_name">
			<xsl:call-template name="lower">
				<xsl:with-param name="str"><xsl:value-of select="file_name"/></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<!-- Определяем расширения файла -->
		<xsl:variable name="extension">
			<xsl:call-template name="Extension">
				<xsl:with-param name="string" select="$file_name"/>
			</xsl:call-template>
		</xsl:variable>
		<!-- <li> -->

		<div class="attachments-wrapper-file">
			<div class="attachment-icon">
				<!-- Пиктограмма в соответствии с расширением файла -->
				<xsl:choose>
					<xsl:when test="$extension='bmp' or $extension='gif' or $extension='jpg' or $extension='jpeg' or $extension='png'">
						<img src="{$attachment}"/>
					</xsl:when>
					<xsl:when test="$extension='zip' or $extension='rar'">
						<img src="/hostcmsfiles/images/filetypes/zip.svg"/>
					</xsl:when>
					<xsl:when test="$extension='pdf'">
						<img src="/hostcmsfiles/images/filetypes/pdf.svg"/>
					</xsl:when>
					<xsl:when test="$extension='css'">
						<img src="/hostcmsfiles/images/filetypes/css.svg"/>
					</xsl:when>
					<xsl:when test="$extension='doc'">
						<img src="/hostcmsfiles/images/filetypes/doc.svg"/>
					</xsl:when>
					<xsl:when test="$extension='html' or $extension='htm' or $extension='xhtml'">
						<img src="/hostcmsfiles/images/filetypes/html.svg"/>
					</xsl:when>
					<xsl:when test="$extension='php'">
						<img src="/hostcmsfiles/images/filetypes/php.svg"/>
					</xsl:when>
					<xsl:when test="$extension='ppt'">
						<img src="/hostcmsfiles/images/filetypes/ppt.svg"/>
					</xsl:when>
					<xsl:when test="$extension='sql'">
						<img src="/hostcmsfiles/images/filetypes/sql.svg"/>
					</xsl:when>
					<xsl:when test="$extension='txt'">
						<img src="/hostcmsfiles/images/filetypes/txt.svg"/>
					</xsl:when>
					<xsl:when test="$extension='xls'">
						<img src="/hostcmsfiles/images/filetypes/xls.svg"/>
					</xsl:when>
					<xsl:when test="$extension='xml' or $extension='xsl'">
						<img src="/hostcmsfiles/images/filetypes/javascript.svg"/>
					</xsl:when>
					<xsl:when test="$extension='js'">
						<img src="/hostcmsfiles/images/filetypes/js.svg"/>
					</xsl:when>
					<xsl:otherwise>
						<img src="/hostcmsfiles/images/filetypes/word.svg"/>
					</xsl:otherwise>
				</xsl:choose>
			</div>

			<div class="attachment-name">
				<div class="link"><a href="{$attachment}" target="blank" title="{file_name}"><xsl:value-of select="file_name"/></a></div>
				<div class="size"><span class="label label-lightgray"><xsl:value-of select="size"/><xsl:text> </xsl:text><xsl:value-of select="size_measure"/></span></div>
			</div>
		</div>
		<!-- </li> -->
	</xsl:template>

	<!-- Определение расширения файла -->
	<xsl:template name="Extension">
		<xsl:param name="string" select="string"/>

		<!-- Получаем подстроку после точки -->
		<xsl:variable name="ext">
			<xsl:value-of select="substring-after($string, '.')"/>
		</xsl:variable>

		<xsl:choose>
			<!-- Если есть точка в подстроке -->
			<xsl:when test="contains($ext, '.')">
				<xsl:call-template name="Extension">
					<xsl:with-param name="string" select="$ext"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$ext"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Вывод рейтинга -->
	<xsl:template name="show_average_grade">
		<xsl:param name="grade" select="0"/>
		<xsl:param name="const_grade" select="0"/>

		<!-- Чтобы избежать зацикливания -->
		<xsl:variable name="current_grade" select="$grade * 1"/>

		<xsl:choose>
			<!-- Если число целое -->
			<xsl:when test="floor($current_grade) = $current_grade and not($const_grade &gt; ceiling($current_grade))">

				<xsl:if test="$current_grade - 1 &gt; 0">
					<xsl:call-template name="show_average_grade">
						<xsl:with-param name="grade" select="$current_grade - 1"/>
						<xsl:with-param name="const_grade" select="$const_grade - 1"/>
					</xsl:call-template>
				</xsl:if>

				<xsl:if test="$current_grade != 0">
					<img src="/hostcmsfiles/images/stars_single.gif"/>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$current_grade != 0 and not($const_grade &gt; ceiling($current_grade))">

				<xsl:if test="$current_grade - 0.5 &gt; 0">
					<xsl:call-template name="show_average_grade">
						<xsl:with-param name="grade" select="$current_grade - 0.5"/>
						<xsl:with-param name="const_grade" select="$const_grade - 1"/>
					</xsl:call-template>
				</xsl:if>

				<img src="/hostcmsfiles/images/stars_half.gif"/>
			</xsl:when>

			<!-- Выводим серые звездочки, пока текущая позиция не дойдет то значения, увеличенного до целого -->
			<xsl:otherwise>
				<xsl:call-template name="show_average_grade">
					<xsl:with-param name="grade" select="$current_grade"/>
					<xsl:with-param name="const_grade" select="$const_grade - 1"/>
				</xsl:call-template>
				<img src="/hostcmsfiles/images/stars_gray.gif"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Шаблон вывода добавления сообщения-->
	<xsl:template name="AddReplyForm">
		<xsl:param name="message_id" select="0" />
		<xsl:param name="message_parent_id" select="0" />
		<xsl:param name="message_comment_subject" />

		<!--Отображение формы добавления комментария-->
		<form action="{/url}" name="message_form_0{$message_id}" class="show form" method="post" enctype="multipart/form-data">

			<input type="hidden" name="parent_id" value="{$message_parent_id}"/>

			<div class="form-group">
				<label for="message_subject">Тема</label>
				<input class="form-control" type="text" size="70" name="message_subject" value="{$message_comment_subject}"/>
			</div>

			<div class="form-group">
				<label for="message_subject">Текст сообщения</label>
				<xsl:choose>
					<xsl:when test="/helpdesk/message_type = 0">
						<textarea name="message_text" cols="68" rows="5" class="form-control mceEditor"></textarea>
					</xsl:when>
					<xsl:otherwise>
						<textarea name="message_text" cols="68" rows="5" class="form-control"/>
					</xsl:otherwise>
				</xsl:choose>
			</div>

			<!-- {$message_id} добавляется для придания имени блока уникальности, т.к. таких блоков несколько -->
			<!-- <div id="helpdesk_upload_file{$message_id}" class="form-group feedback">
				<label class="control-label feedback-caption text-align-left pull-left" for="message_subject">Прикрепить файл</label>
				<input size="30" name="attachment[]" type="file" title="Прикрепить файл" />
			<xsl:text> </xsl:text><a style="font-size:9pt;" href="#" class="addFile">Еще файл …</a>
			</div> -->

			<div id="helpdesk_upload_file{$message_id}" class="form-group">
				<div class="field">
					<div class="input-group">
						<div><input class="no-padding-left pull-left" name="attachment[]" type="file" title="Прикрепить файл" /></div>
						<div class="directory-actions" style="margin-top: 0;">
							<span class="addFile input-group-addon green-text add-file">
								<i class="fa fa-fw fa-plus"></i>
							</span>
						</div>
					</div>
				</div>
			</div>

			<!-- <div class="row">
				<div class="caption"></div>
				<div class="field"><input type="submit" name="send_message" class="button" value="Отправить"/></div>
			</div> -->

			<!-- <div class="form-group">
				<div class="col-12">
					<input class="button" name="send_message" value="Отправить" type="submit" />
				</div>
			</div> -->

			<button type="submit" class="btn btn-sm mb-4" name="send_message" value="send_message">Отправить</button>
		</form>
	</xsl:template>
</xsl:stylesheet>