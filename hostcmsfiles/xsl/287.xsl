<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "lang://287">
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<xsl:template match="/">
		<xsl:apply-templates select="/site"/>
	</xsl:template>

	<xsl:template match="/site">
		<!-- <h1>Поиск</h1> -->

		<form method="get" class="search-form" action="/search/">
			<div class="form-group has-feedback">
				<i class="form-control-feedback form-control-search fa fa-search"></i>
				<input type="text" name="text" class="form-control form-control-search-input" placeholder="Введите поисковой запрос." value="{query}" />
				<i class="form-control-feedback fa fa-times" style="cursor: pointer;" onclick="$('.form-control-search-input').val('');"></i>
			</div>
		</form>

		<div class="cms-search">
			<xsl:if test="query != ''">
				<div class="total-result">
					<strong>Найдено <xsl:value-of select="total"/><xsl:text> </xsl:text><xsl:call-template name="declension">
						<xsl:with-param name="number" select="total"/></xsl:call-template>
					</strong>.
				</div>

				<xsl:if test="total != 0">
					<xsl:apply-templates select="search_page" />
				</xsl:if>
			</xsl:if>
		</div>

		<xsl:if test="total != 0">
			<div class="row">
				<div class="col-12">
					<xsl:variable name="count_pages" select="ceiling(total div limit)"/>

					<xsl:variable name="visible_pages" select="5"/>

					<xsl:variable name="real_visible_pages"><xsl:choose>
							<xsl:when test="$count_pages &lt; $visible_pages"><xsl:value-of select="$count_pages"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$visible_pages"/></xsl:otherwise>
					</xsl:choose></xsl:variable>

					<!-- Считаем количество выводимых ссылок перед текущим элементом -->
					<xsl:variable name="pre_count_page"><xsl:choose>
							<xsl:when test="(page) - (floor($real_visible_pages div 2)) &lt; 0">
								<xsl:value-of select="page"/>
							</xsl:when>
							<xsl:when test="($count_pages  - (page) - 1) &lt; floor($real_visible_pages div 2)">
								<xsl:value-of select="$real_visible_pages - ($count_pages  - (page) - 1) - 1"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="round($real_visible_pages div 2) = $real_visible_pages div 2">
										<xsl:value-of select="floor($real_visible_pages div 2) - 1"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="floor($real_visible_pages div 2)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
					</xsl:choose></xsl:variable>

					<!-- Считаем количество выводимых ссылок после текущего элемента -->
					<xsl:variable name="post_count_page"><xsl:choose>
							<xsl:when test="0 &gt; (page) - (floor($real_visible_pages div 2) - 1)">
								<xsl:value-of select="$real_visible_pages - (page) - 1"/>
							</xsl:when>
							<xsl:when test="($count_pages  - (page) - 1) &lt; floor($real_visible_pages div 2)">
								<xsl:value-of select="$real_visible_pages - $pre_count_page - 1"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$real_visible_pages - $pre_count_page - 1"/>
							</xsl:otherwise>
					</xsl:choose></xsl:variable>

					<xsl:variable name="i"><xsl:choose>
							<xsl:when test="(page) + 1 = $count_pages"><xsl:value-of select="(page) - $real_visible_pages + 1"/></xsl:when>
							<xsl:when test="(page) - $pre_count_page &gt; 0"><xsl:value-of select="(page) - $pre_count_page"/></xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose></xsl:variable>

					<div class="shop-bottom">
						<div class="shop-pagination">
							<ul class="pagination">
								<xsl:call-template name="for">
									<xsl:with-param name="limit" select="limit"/>
									<xsl:with-param name="page" select="page"/>
									<xsl:with-param name="items_count" select="total"/>
									<xsl:with-param name="i" select="$i"/>
									<xsl:with-param name="post_count_page" select="$post_count_page"/>
									<xsl:with-param name="pre_count_page" select="$pre_count_page"/>
									<xsl:with-param name="visible_pages" select="$real_visible_pages"/>
								</xsl:call-template>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="search_page">
		<div class="row mt-3">
			<xsl:if test="shop_item/node() and shop_item/image_small != ''">
				<div class="col-4 col-md-2">
					<a class="search-item-image" title="{shop_item/name}" href="{shop_item/url}">
						<img class="img-fluid" alt="{shop_item/name}" src="{shop_item/dir}{shop_item/image_small}" />
					</a>
				</div>
			</xsl:if>

			<div class="col-12">
				<xsl:if test="shop_item/node() and shop_item/image_small != ''">
					<xsl:attribute name="class">col-8 col-md-10</xsl:attribute>
				</xsl:if>

				<div class="search-content">
					<a href="{url}">
						<xsl:value-of select="title"/>
					</a>

					<xsl:if test="shop_item/comments_average_grade/node()">
						<div class="search-stars">
							<div class="five-stars-container">
								<span class="five-stars" style="width: {shop_item/comments_average_grade * 20}%"></span>
							</div>
						</div>
					</xsl:if>

					<xsl:if test="shop_item/node()">
						<div class="font-weight-bold">
							<xsl:apply-templates select="shop_currency/code">
								<xsl:with-param name="value" select="shop_item/price" />
							</xsl:apply-templates>
							<xsl:if test="shop_item/discount != 0">
								<span class="old-price small">
									<xsl:apply-templates select="shop_currency/code">
										<xsl:with-param name="value" select="shop_item/price + shop_item/discount" />
									</xsl:apply-templates>
								</span>
							</xsl:if>
						</div>

						<xsl:if test="shop_item/description != ''">
							<div class="d-none d-md-block">
								<xsl:value-of disable-output-escaping="yes" select="shop_item/description"/>
							</div>
						</xsl:if>
					</xsl:if>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="url" match="text()">
		<xsl:param name="str" select="."/>

		<xsl:param name="max">50</xsl:param>
		<xsl:param name="hvost">10</xsl:param>

		<xsl:param name="begin">
			<xsl:choose>
				<xsl:when test="string-length($str) &gt; $max">
					<xsl:value-of select="substring($str, 1, $max - $hvost)"/>
				</xsl:when>

				<xsl:otherwise>
					<xsl:value-of select="substring($str, 1)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:param>

		<xsl:param name="end">
			<xsl:choose>
				<xsl:when test="string-length($str) &gt; $max">
					<xsl:value-of select="substring($str, string-length($str) - $hvost + 1, $hvost)"/>
				</xsl:when>

				<xsl:otherwise>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:param>

		<xsl:param name="result">
			<xsl:choose>
				<xsl:when test="$end != ''">
					<xsl:value-of select="concat($begin, '…', $end)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$begin"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:param>

		<xsl:value-of disable-output-escaping="yes" select="$result"/>
	</xsl:template>

	<!-- Цикл для вывода строк ссылок -->
	<xsl:template name="for">
		<xsl:param name="limit"/>
		<xsl:param name="page"/>
		<xsl:param name="pre_count_page"/>
		<xsl:param name="post_count_page"/>
		<xsl:param name="i" select="0"/>
		<xsl:param name="items_count"/>
		<xsl:param name="visible_pages"/>

		<xsl:variable name="n" select="ceiling($items_count div $limit)"/>

		<xsl:variable name="start_page"><xsl:choose>
				<xsl:when test="$page + 1 = $n"><xsl:value-of select="$page - $visible_pages + 1"/></xsl:when>
				<xsl:when test="$page - $pre_count_page &gt; 0"><xsl:value-of select="$page - $pre_count_page"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose></xsl:variable>

		<!-- <xsl:if test="$i = $start_page and $page != 0">
			<span class="ctrl">
				← Ctrl
			</span>
		</xsl:if>

		<xsl:if test="$i = ($page + $post_count_page + 1) and $n != ($page+1)">
			<span class="ctrl">
				Ctrl →
			</span>
		</xsl:if> -->

		<xsl:if test="$items_count &gt; $limit and ($page + $post_count_page + 1) &gt; $i">

			<!-- Ссылка на текущий узел структуры -->
			<xsl:variable name="link" select="/site/url" />

			<!-- Текст поискового запроса -->
			<xsl:variable name="queryencode">?text=<xsl:value-of select="/site/queryencode"/></xsl:variable>

			<!-- Определяем адрес ссылки -->
			<xsl:variable name="number_link">
				<xsl:choose>
					<!-- Если не нулевой уровень -->
					<xsl:when test="$i != 0">page-<xsl:value-of select="$i + 1"/>/</xsl:when>
					<!-- Иначе если нулевой уровень - просто ссылка на страницу со списком элементов -->
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<!-- Выводим ссылку на первую страницу -->
			<xsl:if test="$page - $pre_count_page &gt; 0 and $i = $start_page">
			<li><a href="{$link}{$queryencode}" style="text-decoration: none;">←</a></li>
			</xsl:if>

			<!-- Ставим ссылку на страницу-->
			<xsl:if test="$i != $page">
				<xsl:if test="($page - $pre_count_page) &lt;= $i and $i &lt; $n">
					<!-- Выводим ссылки на видимые страницы -->
					<li><a href="{$link}{$number_link}{$queryencode}">
							<xsl:value-of select="$i + 1"/>
					</a></li>
				</xsl:if>

				<!-- Выводим ссылку на последнюю страницу -->
				<xsl:if test="$i+1 &gt;= ($page + $post_count_page + 1) and $n &gt; ($page + 1 + $post_count_page)">
					<!-- Выводим ссылку на последнюю страницу -->
				<li><a href="{$link}page-{$n}/{$queryencode}" style="text-decoration: none;">→</a></li>
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

			<li class="hidden"><a href="{$link}{$prev_number_link}{$queryencode}"></a></li>
			</xsl:if>

			<!-- Ссылка на следующую страницу для Ctrl + вправо -->
			<xsl:if test="($n - 1) > $page and $i = $page">
			<li class="hidden"><a href="{$link}page-{$page+2}/{$queryencode}"></a></li>
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
				<xsl:with-param name="limit" select="$limit"/>
				<xsl:with-param name="page" select="$page"/>
				<xsl:with-param name="items_count" select="$items_count"/>
				<xsl:with-param name="pre_count_page" select="$pre_count_page"/>
				<xsl:with-param name="post_count_page" select="$post_count_page"/>
				<xsl:with-param name="visible_pages" select="$visible_pages"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- Declension of the numerals -->
	<xsl:template name="declension">

		<xsl:param name="number" select="number"/>

		<!-- Nominative case / Именительный падеж -->
		<xsl:variable name="nominative">
			<xsl:text>страница</xsl:text>
		</xsl:variable>

		<!-- Genitive singular / Родительный падеж, единственное число -->
		<xsl:variable name="genitive_singular">
			<xsl:text>страницы</xsl:text>
		</xsl:variable>

		<xsl:variable name="genitive_plural">
			<xsl:text>страниц</xsl:text>
		</xsl:variable>

		<xsl:variable name="last_digit">
			<xsl:value-of select="$number mod 10"/>
		</xsl:variable>

		<xsl:variable name="last_two_digits">
			<xsl:value-of select="$number mod 100"/>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$last_digit = 1 and $last_two_digits != 11">
				<xsl:value-of select="$nominative"/>
			</xsl:when>
			<xsl:when test="$last_digit = 2 and $last_two_digits != 12     or     $last_digit = 3 and $last_two_digits != 13     or     $last_digit = 4 and $last_two_digits != 14">
				<xsl:value-of select="$genitive_singular"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$genitive_plural"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="shop_currency/code">
		<xsl:param name="value" />

		<xsl:variable name="spaced" select="format-number($value, '# ###', 'my')" />

		<xsl:choose>
			<xsl:when test=". = 'USD'">$<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'EUR'">€<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'GBP'">£<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'RUB'"><xsl:value-of select="$spaced"/> ₽</xsl:when>
			<xsl:when test=". = 'AUD'">AU$<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'CNY'"><xsl:value-of select="$spaced"/>元</xsl:when>
			<xsl:when test=". = 'JPY'"><xsl:value-of select="$spaced"/>¥</xsl:when>
			<xsl:when test=". = 'KRW'"><xsl:value-of select="$spaced"/>₩</xsl:when>
			<xsl:when test=". = 'PHP'"><xsl:value-of select="$spaced"/>₱</xsl:when>
			<xsl:when test=". = 'THB'"><xsl:value-of select="$spaced"/>฿</xsl:when>
			<xsl:when test=". = 'BRL'">R$<xsl:value-of select="$spaced"/></xsl:when>
		<xsl:when test=". = 'INR'"><xsl:value-of select="$spaced"/><i class="fa fa-inr"></i></xsl:when>
		<xsl:when test=". = 'TRY'"><xsl:value-of select="$spaced"/><i class="fa fa-try"></i></xsl:when>
		<xsl:when test=". = 'ILS'"><xsl:value-of select="$spaced"/><i class="fa fa-ils"></i></xsl:when>
			<xsl:otherwise><xsl:value-of select="$spaced"/> <xsl:value-of select="." /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>