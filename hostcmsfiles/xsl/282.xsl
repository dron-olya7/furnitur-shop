<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- ВыводРежимаРаботыСлужбыТехподдержки -->

	<xsl:template match="/">
		<div class="row margin-bottom-30">
			<xsl:apply-templates select="helpdesk"/>
		</div>
	</xsl:template>

	<xsl:template match="helpdesk">
		<div class="col-12">
			<div class="box-user-content no-margin-top">
				<div class="row">
					<div class="col-12">
						<div class="user-tickets">
							<div class="row margin-bottom-20">
								<div class="col-12">
									<h1 class="title">Режим работы службы поддержки <xsl:value-of select="name"/></h1>
								</div>
							</div>

							<!-- График работы -->
							<div class="table-responsive">
								<table class="table" cellpadding="0" cellspacing="0" border="0" style="border-collapse: collapse;font-size:10pt;">
									<tr>
										<td></td>
										<td class="helpdesk_hour"><xsl:apply-templates select="worktimes/worktime[day='0']" mode="title_table"/></td>
									</tr>
									<tr>
										<td class="helpdesk_day">
											<div>Понедельник</div>
											<div>Вторник</div>
											<div>Среда</div>
											<div>Четверг</div>
											<div>Пятница</div>
											<div>Суббота</div>
											<div>Воскресенье</div>
										</td>
										<td><xsl:apply-templates select="worktimes/worktime"/></td>
									</tr>
								</table>
							</div>

							<div class="row margin-top-30">
								<div class="col-12">
								<div class="helpdesk_wt_2"></div><div class="helpdesk_legend">Текущий период.</div>
								</div>
								<div class="col-12 margin-top-10">
								<div class="helpdesk_wt_1"></div><div class="helpdesk_legend">Рабочее время.</div>
								</div>
								<div class="col-12 margin-top-10">
								<div class="helpdesk_wt_0"></div><div class="helpdesk_legend">Выходные.</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

	<!--Шаблон для вывода часов-->
	<xsl:template match="worktime" mode="title_table">
		<div><xsl:value-of select="hour"/></div>
	</xsl:template>

	<!--Шаблон для вывода режима работы-->
	<xsl:template match="worktime">

		<!--<xsl:variable name="x" select="node()" />-->
		<xsl:variable name="class"><xsl:choose>
				<xsl:when test="day = (/helpdesk/date_day_of_week - 1) and hour = /helpdesk/date_hour">helpdesk_wt_2</xsl:when>
				<xsl:when test="value = 1">helpdesk_wt_1</xsl:when>
				<xsl:otherwise>helpdesk_wt_0</xsl:otherwise>
		</xsl:choose></xsl:variable>

		<div class="{$class}"></div>

		<!--Перевод строки-->
		<xsl:if test="hour=23">
			<div style="clear:both"></div>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>