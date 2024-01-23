<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "lang://244">
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:template match="/siteuser">
		<xsl:choose>
			<xsl:when test="new_password/node()">
				<h1>&labelNewPasswordTitle;</h1>
				<p>&labelNewPasswordTextLine1;</p>
				<p>&labelNewPasswordTextLine2;</p>
				<script type="text/javascript">setTimeout(function(){ location = '../' }, 3000);</script>
			</xsl:when>
			<xsl:otherwise>
				<h1>&labelRestoreTitle;</h1>

				<xsl:if test="error_code/node()">
					<div id="error">
						<xsl:choose>
							<xsl:when test="error_code = 'wrongUser'">&labelMessageWrongUser;</xsl:when>
							<xsl:when test="error_code = 'wrongCsrf'">&labelMessageWrongCsrf;</xsl:when>
							<xsl:otherwise>Unknown Error</xsl:otherwise>
						</xsl:choose>
					</div>
				</xsl:if>

				<form action="/users/restore_password/" method="POST">
					<p>
						&labelLogin;
						<br />
						<input name="login" type="text" size="30" class="large" required="required" />
					</p>
					<p>
						&labelEmail;
						<br />
						<input name="email" type="text" size="30" class="large" required="required" />
					</p>
					<p>
						<!-- CSRF-токен -->
						<input name="csrf_token" type="hidden" value="{csrf_token}" />

						<input name="apply" type="submit" value="&labelRestore;" class="button" />
					</p>
				</form>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>