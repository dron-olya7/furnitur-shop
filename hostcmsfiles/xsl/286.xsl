<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:template match="/">
		<div class="row">
			<xsl:apply-templates select="siteuser"/>
		</div>
	</xsl:template>

	<xsl:template match="siteuser">
		<div class="col-12">
			<div class="box-user-content no-margin-top">
				<div class="user-licenses">
					<div class="row">
						<div class="col-12">
							<h1 class="title">Подписка на почтовые рассылки</h1>
						</div>
					</div>

					<xsl:choose>
						<xsl:when test="count(maillist) > 0">
							<form method="post" action="./">
								<div class="row table-header">
									<div class="col-6 col-lg-4">
										Рассылка
									</div>
									<div class="col-lg-5 d-none d-lg-block">
										Описание
									</div>
									<div class="col-6 col-lg-3">
										Формат
									</div>
								</div>

								<xsl:apply-templates select="maillist"></xsl:apply-templates>

								<button name="apply" type="submit" class="btn btn-sm mt-4">Применить</button>
							</form>
						</xsl:when>
						<xsl:otherwise>
							<div class="col-12">
								<div class="alert alert-warning">
									Доступные рассылки отсутствуют!
								</div>
							</div>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="maillist">
		<xsl:variable name="id" select="@id" />
		<xsl:variable name="maillist_siteuser" select="/siteuser/maillist_siteuser[maillist_id = $id]" />

		<div class="row table-row">
			<div class="col-6 col-lg-4">
				<div class="pretty p-default p-pulse">
					<input id="maillist_{@id}" name="maillist_{@id}" type="checkbox" value="1">
						<xsl:if test="$maillist_siteuser/node() or not(/siteuser/@id)">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>

					<div class="state p-primary-o">
						<label><xsl:value-of select="name"/></label>
					</div>
				</div>
			</div>
			<div class="col-lg-5 d-none d-lg-block">
				<xsl:value-of select="description"/>
			</div>
			<div class="col-6 col-lg-3">
				<select class="wide" name="type_{@id}">
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
</xsl:stylesheet>