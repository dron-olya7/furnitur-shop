<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:template match="/informationsystem">
		<!-- Получаем ID родительской группы и записываем в переменную $group -->
		<xsl:variable name="group" select="group"/>

		<h1 class="title"><xsl:value-of select="name"/></h1>

		<div class="items-wrapper">
			<xsl:apply-templates select="informationsystem_item[active=1]"/>
		</div>

		<!-- Строка ссылок на другие страницы информационной системы -->
		<xsl:if test="ОтображатьСсылкиНаСледующиеСтраницы=1">
			<!-- Ссылка, для которой дописываются суффиксы page-XX/ -->
			<xsl:variable name="link">
				<xsl:value-of select="/informationsystem/url"/>
				<xsl:if test="$group != 0">
					<xsl:value-of select="/informationsystem//informationsystem_group[@id = $group]/url"/>
				</xsl:if>
			</xsl:variable>

			<div class="shop-bottom">
				<div class="shop-pagination">
					<ul class="pagination">
						<xsl:call-template name="for">
							<xsl:with-param name="link" select="$link"/>
							<xsl:with-param name="limit" select="limit"/>
							<xsl:with-param name="page" select="page"/>
							<xsl:with-param name="items_count" select="total"/>
							<xsl:with-param name="visible_pages">5</xsl:with-param>
						</xsl:call-template>
					</ul>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="informationsystem_item">
		<xsl:variable name="group_id" select="informationsystem_group_id"/>
		<div class="item">
			<div class="image">
				<a href="{url}">
					<xsl:choose>
						<xsl:when test="image_small != ''">
							<img src="{dir}{image_small}" alt="{name}"/>
						</xsl:when>
						<xsl:otherwise><img src="/hostcmsfiles/assets/images/no-image.svg" alt="{name}"/></xsl:otherwise>
					</xsl:choose>
				</a>

				<div class="info">
					<xsl:if test="count(/informationsystem//informationsystem_group[@id = $group_id])">
						<span class="group-name"><a href="{/informationsystem//informationsystem_group[@id = $group_id]/url}"><xsl:value-of select="/informationsystem//informationsystem_group[@id = $group_id]/name" /></a></span>
					</xsl:if>

					<span class="showed"><i class="fa fa-eye"></i><xsl:value-of select="showed"/></span>

					<span class="comments"><i class="fa fa-comments-o"></i><xsl:value-of select="comments_count"/></span>
				</div>
			</div>
			<div class="date">
				<xsl:call-template name="date_to_str">
					<xsl:with-param name="date" select="date" />
				</xsl:call-template>
			</div>
			<div class="name"><a href="{url}"><xsl:value-of select="name"/></a></div>
		</div>
	</xsl:template>

	<!-- Цикл для вывода строк ссылок -->
	<xsl:template name="for">
		<xsl:param name="i" select="0"/>
		<xsl:param name="prefix">page</xsl:param>
		<xsl:param name="link"/>
		<xsl:param name="limit"/>
		<xsl:param name="page"/>
		<xsl:param name="items_count"/>
		<xsl:param name="visible_pages"/>

		<xsl:variable name="n" select="$items_count div $limit"/>

		<!-- Заносим в переменную $group идентификатор текущей группы -->
		<xsl:variable name="group" select="/informationsystem/group"/>

		<!-- Считаем количество выводимых ссылок перед текущим элементом -->
		<xsl:variable name="pre_count_page">
			<xsl:choose>
				<xsl:when test="$page &gt; ($n - (round($visible_pages div 2) - 1))">
					<xsl:value-of select="$visible_pages - ($n - $page)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="round($visible_pages div 2) - 1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Считаем количество выводимых ссылок после текущего элемента -->
		<xsl:variable name="post_count_page">
			<xsl:choose>
				<xsl:when test="0 &gt; $page - (round($visible_pages div 2) - 1)">
					<xsl:value-of select="$visible_pages - $page"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="round($visible_pages div 2) = ($visible_pages div 2)">
							<xsl:value-of select="$visible_pages div 2"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="round($visible_pages div 2) - 1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- <xsl:if test="$i = 0 and $page != 0">
			<span class="ctrl">
				&#8592; Ctrl
			</span>
		</xsl:if>

		<xsl:if test="$i >= $n and ($n - 1) > $page">
			<span class="ctrl">
				Ctrl &#8594;
			</span>
		</xsl:if>-->

		<xsl:variable name="filter"><xsl:if test="/informationsystem/sorting/node()">?sorting=<xsl:value-of select="/informationsystem/sorting"/></xsl:if></xsl:variable>

		<xsl:if test="$items_count &gt; $limit and $n &gt; $i">

			<!-- Определяем адрес тэга -->
			<xsl:variable name="tag_link">
				<xsl:choose>
					<!-- Если не нулевой уровень -->
					<xsl:when test="count(/informationsystem/tag) != 0">tag/<xsl:value-of select="/informationsystem/tag/urlencode"/>/</xsl:when>
					<!-- Иначе если нулевой уровень - просто ссылка на страницу со списком элементов -->
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<!-- Определяем адрес ссылки -->
			<xsl:variable name="number_link">
				<xsl:choose>
					<!-- Если не нулевой уровень -->
					<xsl:when test="$i != 0">
						<xsl:value-of select="$prefix"/>-<xsl:value-of select="$i + 1"/>/</xsl:when>
					<!-- Иначе если нулевой уровень - просто ссылка на страницу со списком элементов -->
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<!-- Ставим ссылку на страницу-->
			<xsl:if test="$i != $page">
				<!-- Выводим ссылку на первую страницу -->
				<xsl:if test="$page - $pre_count_page &gt; 0 and $i = 0">
					<li><a href="{$link}{$filter}">&#x2190;</a></li>
				</xsl:if>

				<xsl:choose>
					<xsl:when test="$i &gt;= ($page - $pre_count_page) and ($page + $post_count_page) &gt;= $i">
						<!-- Выводим ссылки на видимые страницы -->
						<li><a href="{$link}{$tag_link}{$number_link}{$filter}">
							<xsl:value-of select="$i + 1"/>
						</a></li>
					</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>

				<!-- Выводим ссылку на последнюю страницу -->
				<xsl:if test="$i+1 &gt;= $n and $n &gt; ($page + 1 + $post_count_page)">
					<xsl:choose>
						<xsl:when test="$n &gt; round($n)">
							<!-- Выводим ссылку на последнюю страницу -->
							<li><a href="{$link}{$prefix}-{round($n+1)}/{$filter}">→</a></li>
						</xsl:when>
						<xsl:otherwise>
							<li><a href="{$link}{$prefix}-{round($n)}/{$filter}">→</a></li>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:if>

			<!-- Ссылка на предыдущую страницу для Ctrl + влево -->
			<xsl:if test="$page != 0 and $i = $page">
				<xsl:variable name="prev_number_link">
					<xsl:choose>
						<!-- Если не нулевой уровень -->
						<xsl:when test="($page) != 0">page-<xsl:value-of select="$i"/>/</xsl:when>
						<!-- Иначе если нулевой уровень - просто ссылка на страницу со списком элементов -->
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<li class="hidden"><a href="{$link}{$tag_link}{$prev_number_link}{$filter}" id="id_prev"></a></li>
			</xsl:if>

			<!-- Ссылка на следующую страницу для Ctrl + вправо -->
			<xsl:if test="($n - 1) > $page and $i = $page">
				<li class="hidden"><a href="{$link}{$tag_link}page-{$page+2}/{$filter}" id="id_next"></a></li>
			</xsl:if>

			<!-- Не ставим ссылку на страницу-->
			<xsl:if test="$i = $page">
				<li class="active">
					<span><xsl:value-of select="$i+1"/></span>
				</li>
			</xsl:if>

			<!-- Рекурсивный вызов шаблона. НЕОБХОДИМО ПЕРЕДАВАТЬ ВСЕ НЕОБХОДИМЫЕ ПАРАМЕТРЫ! -->
			<xsl:call-template name="for">
				<xsl:with-param name="i" select="$i + 1"/>
				<xsl:with-param name="prefix" select="$prefix"/>
				<xsl:with-param name="link" select="$link"/>
				<xsl:with-param name="limit" select="$limit"/>
				<xsl:with-param name="page" select="$page"/>
				<xsl:with-param name="items_count" select="$items_count"/>
				<xsl:with-param name="visible_pages" select="$visible_pages"/>
			</xsl:call-template>
		</xsl:if>
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