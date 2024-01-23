<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:template match="/maillist_fascicle_log">
		<style>
			html, body {
				max-height: 100%;
			}
			.unsubscribe-block {
				display: flex;
				justify-content: center;
				align-items: center;
				flex-direction: column;
				height: 100%;
			}
			.unsubscribe-block .center {
				margin: auto;
			}
			.unsubscribe-block .unsubscribe-reason-list {
				list-style-type: none;
				padding-left: 0;
			}
			.unsubscribe-block textarea { display: block; }
			.unsubscribe-block button { margin-top: 10px; }
			.unsubscribe-block .error { color: red; }
			.unsubscribe-block .error .success { color: green; }
		</style>

		<div class="unsubscribe-block">
			<div class="center">
				<xsl:choose>
					<xsl:when test="error/node()">
						<div class="error">
							<xsl:choose>
								<xsl:when test="error = 0"><span class="success">Клиент отписан от рассылки!</span></xsl:when>
								<xsl:when test="error = 1">Клиент не найден</xsl:when>
								<xsl:when test="error = 2">Клиент не подписан на рассылку</xsl:when>
							</xsl:choose>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<form action="./?guid={guid}" method="POST">
							<ul class="unsubscribe-reason-list">
								<xsl:apply-templates select="maillist_unsubscribe_reason" />
							</ul>
							<div>Комментарий:</div>
							<textarea name="reason" rows="7"><xsl:value-of select="reason"/></textarea>
							<button type="submit" name="unsubscribe" value="unsubscribe">Отписаться</button>
						</form>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="maillist_unsubscribe_reason">
		<li>
			<input type="radio" name="maillist_unsubscribe_reason_id" value="{@id}">
				<xsl:if test="position() = 1">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
				<span style="color: {color}"><xsl:value-of select="reason" /></span>
			</input>
		</li>
	</xsl:template>
</xsl:stylesheet>