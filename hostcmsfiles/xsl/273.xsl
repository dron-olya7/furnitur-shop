<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:include href="import://251"/>

	<xsl:template match="/shop">
		<!-- Получаем ID родительской группы и записываем в переменную $group -->
		<xsl:variable name="group" select="group"/>

		<xsl:if test="page = 0 and filter_path = '' and count(tag) = 0 and count(.//shop_group[parent_id=$group])">
			<div class="categories style1">
				<xsl:apply-templates select=".//shop_group[parent_id=$group]" mode="style1"/>
			</div>

			<!-- <div class="categories style2">
				<div class="row">
					<xsl:apply-templates select=".//shop_group[parent_id=$group]" mode="style2"/>
				</div>
			</div> -->
		</xsl:if>

		<xsl:if test="shop_filter_seos/shop_filter_seo/node()">
			<div class="row mb-2">
				<div class="col-12">
					<xsl:apply-templates select="shop_filter_seos/shop_filter_seo"/>
				</div>
			</div>
		</xsl:if>

		<!-- Если задан SEO-фильтр, выводим <h1> и текст -->
		<xsl:if test="shop_filter_seo/node() and shop_filter_seo/h1 != ''">
			<h1><xsl:value-of select="shop_filter_seo/h1"/></h1>

			<xsl:if test="page = 0 and shop_filter_seo/text != ''">
				<div><xsl:value-of disable-output-escaping="yes" select="shop_filter_seo/text"/></div>
			</xsl:if>
		</xsl:if>

		<xsl:variable name="product_class">
			<xsl:choose>
				<xsl:when test="page = 0 and filter_path = '' and count(.//shop_group[parent_id=$group])"></xsl:when>
				<xsl:otherwise>categories-empty</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Обработка выбранных тэгов -->
		<xsl:if test="count(tag)">
			<h1 class="title tag-title">Метка — <strong><xsl:value-of select="tag/name"/></strong>.</h1>
		</xsl:if>

		<div class="products-row {$product_class}">
			<xsl:if test="filter_path != '' and count(shop_item) = 0">
				<div class="alert alert-warning" role="alert">
					Нет найденных товаров. Попробуйте изменить условия фильтра.
				</div>
			</xsl:if>

			<xsl:if test="filter_path = '' and count(shop_item) = 0 and $group &gt; 0">
				<div class="alert alert-warning" role="alert">
					В группе нет товаров.
				</div>
			</xsl:if>

			<xsl:apply-templates select="shop_item" />
		</div>

		<xsl:if test="total &gt; 0 and limit &gt; 0 and ceiling(total div limit) &gt; 1">
			<xsl:variable name="count_pages" select="ceiling(total div limit)"/>

			<xsl:variable name="visible_pages" select="5"/>

			<xsl:variable name="real_visible_pages"><xsl:choose>
					<xsl:when test="$count_pages &lt; $visible_pages"><xsl:value-of select="$count_pages"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$visible_pages"/></xsl:otherwise>
			</xsl:choose></xsl:variable>

			<!-- Links before current -->
			<xsl:variable name="pre_count_page"><xsl:choose>
					<xsl:when test="page - (floor($real_visible_pages div 2)) &lt; 0">
						<xsl:value-of select="page"/>
					</xsl:when>
					<xsl:when test="($count_pages - page - 1) &lt; floor($real_visible_pages div 2)">
						<xsl:value-of select="$real_visible_pages - ($count_pages - page - 1) - 1"/>
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

			<!-- Links after current -->
			<xsl:variable name="post_count_page"><xsl:choose>
					<xsl:when test="0 &gt; page - (floor($real_visible_pages div 2) - 1)">
						<xsl:value-of select="$real_visible_pages - page - 1"/>
					</xsl:when>
					<xsl:when test="($count_pages - page - 1) &lt; floor($real_visible_pages div 2)">
						<xsl:value-of select="$real_visible_pages - $pre_count_page - 1"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$real_visible_pages - $pre_count_page - 1"/>
					</xsl:otherwise>
			</xsl:choose></xsl:variable>

			<xsl:variable name="i"><xsl:choose>
					<xsl:when test="page + 1 = $count_pages"><xsl:value-of select="page - $real_visible_pages + 1"/></xsl:when>
					<xsl:when test="page - $pre_count_page &gt; 0"><xsl:value-of select="page - $pre_count_page"/></xsl:when>
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
		</xsl:if>
	</xsl:template>

	<xsl:template match="shop_group" mode="style1">
		<div class="categories-item">
			<div class="categories-item-wrapper">
				<xsl:if test="image_large != ''">
					<div>
						<img class="img-fluid" src="{dir}{image_large}" />
					</div>
				</xsl:if>
				<div>
					<div class="categories-caption-text">
						<span><a href="{url}"><xsl:value-of select="name" /></a></span>
						<span class="badge badge-light"><xsl:value-of select="items_total_count" /></span>
					</div>

					<xsl:if test="count(shop_group)">
						<ul>
							<xsl:apply-templates select="shop_group[position() &lt; 4]" mode="sub"/>
						</ul>
					</xsl:if>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="shop_group" mode="sub">
		<li>
			<div>
				<span><a href="{url}"><xsl:value-of select="name" /></a></span>
				<span class="badge badge-light"><xsl:value-of select="items_total_count" /></span>
			</div>
		</li>
	</xsl:template>

	<xsl:template match="shop_group" mode="style2">
		<div class="col-md-4 col-sm-6">
			<div class="categories-item">
				<xsl:variable name="image">
					<xsl:choose>
						<xsl:when test="image_large != ''">
							<xsl:value-of select="dir"/><xsl:value-of select="image_large" />
						</xsl:when>
						<xsl:otherwise>/hostcmsfiles/assets/images/no-image.svg</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<a href="{url}" class="categories-link" style="background-image: url('{$image}');">
					<div class="categories-caption">
						<span class="categories-caption-text"><xsl:value-of select="name" /></span>
					</div>
					<div class="static-overlay"></div>
				</a>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="shop_filter_seo">
		<div class="shop-filter-seo">
			<a href="{url}"><xsl:value-of select="name" /></a>
		</div>
	</xsl:template>

	<!-- Pagination -->
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
			<li>
			<span aria-hidden="true"><i class="fa fa-angle-double-left"></i></span>
			</li>
		</xsl:if>

		<xsl:if test="$i = ($page + $post_count_page + 1) and $n != ($page+1)">
			<li>
			<span aria-hidden="true"><i class="fa fa-angle-double-right"></i></span>
			</li>
		</xsl:if> -->

		<!-- Filter String -->
		<xsl:variable name="filter"><xsl:if test="/shop/filter_path/node() and /shop/filter_path != ''"><xsl:value-of select="/shop/filter_path"/></xsl:if></xsl:variable>

		<xsl:variable name="on_page"><xsl:if test="/shop/on_page/node() and /shop/on_page > 0"><xsl:choose><xsl:when test="/shop/filter_path/node()">&amp;</xsl:when><xsl:otherwise>?</xsl:otherwise></xsl:choose>on_page=<xsl:value-of select="/shop/on_page"/></xsl:if></xsl:variable>

		<xsl:variable name="sorting"><xsl:if test="/shop/sorting/node() and /shop/sorting > 0"><xsl:choose><xsl:when test="/shop/filter_path/node()">?</xsl:when><xsl:otherwise>&amp;</xsl:otherwise></xsl:choose>sorting=<xsl:value-of select="/shop/sorting"/></xsl:if></xsl:variable>

		<xsl:if test="$items_count &gt; $limit and ($page + $post_count_page + 1) &gt; $i">
			<!-- Store in the variable $group ID of the current group -->
			<xsl:variable name="group" select="/shop/group"/>

			<!-- Tag Path -->
			<xsl:variable name="tag_path"><xsl:if test="count(/shop/tag) != 0">tag/<xsl:value-of select="/shop/tag/urlencode"/>/</xsl:if></xsl:variable>

			<!-- Compare Product Path -->
			<!-- <xsl:variable name="shop_producer_path"><xsl:if test="count(/shop/shop_producer)">producer-<xsl:value-of select="/shop/shop_producer/@id"/>/</xsl:if></xsl:variable> -->
			<xsl:variable name="shop_producer_path"></xsl:variable>

			<!-- Choose Group Path -->
			<xsl:variable name="group_link"><xsl:choose><xsl:when test="$group != 0"><xsl:value-of select="/shop//shop_group[@id=$group]/url"/></xsl:when><xsl:otherwise><xsl:value-of select="/shop/url"/></xsl:otherwise></xsl:choose></xsl:variable>

			<!-- Set $link variable -->
			<xsl:variable name="number_link"><xsl:if test="$i != 0">page-<xsl:value-of select="$i + 1"/>/</xsl:if></xsl:variable>

			<!-- First pagination item -->
			<xsl:if test="$page - $pre_count_page &gt; 0 and $i = $start_page">
				<li>
					<a href="{$group_link}{$filter}{$tag_path}{$shop_producer_path}{$on_page}{$sorting}" class="page_link" style="text-decoration: none;">←</a>
				</li>
			</xsl:if>

			<!-- Pagination item -->
			<xsl:if test="$i != $page">
				<xsl:if test="($page - $pre_count_page) &lt;= $i and $i &lt; $n">
					<!-- Pagination item -->
					<li>
						<a href="{$group_link}{$filter}{$number_link}{$tag_path}{$shop_producer_path}{$on_page}{$sorting}" class="page_link">
							<xsl:value-of select="$i + 1"/>
						</a>
					</li>
				</xsl:if>

				<!-- Last pagination item -->
				<xsl:if test="$i+1 &gt;= ($page + $post_count_page + 1) and $n &gt; ($page + 1 + $post_count_page)">
					<!-- Last pagination item -->
					<li>
						<a href="{$group_link}{$filter}page-{$n}/{$tag_path}{$shop_producer_path}{$on_page}{$sorting}" class="page_link" style="text-decoration: none;">→</a>
					</li>
				</xsl:if>
			</xsl:if>

			<!-- Ctrl+left link -->
			<xsl:if test="$page != 0 and $i = $page">
				<xsl:variable name="prev_number_link">
					<xsl:if test="$page &gt; 1">page-<xsl:value-of select="$i"/>/</xsl:if>
				</xsl:variable>

			<li class="hidden"><a href="{$group_link}{$filter}{$prev_number_link}{$tag_path}{$shop_producer_path}{$on_page}{$sorting}" id="id_prev"></a></li>
			</xsl:if>

			<!-- Ctrl+right link -->
			<xsl:if test="($n - 1) > $page and $i = $page">
			<li class="hidden"><a href="{$group_link}{$filter}page-{$page+2}/{$tag_path}{$shop_producer_path}{$on_page}{$sorting}" id="id_next"></a></li>
			</xsl:if>

			<!-- Current pagination item -->
			<xsl:if test="$i = $page">
				<li class="active">
					<span><xsl:value-of select="$i+1"/></span>
				</li>
			</xsl:if>

			<!-- Recursive Template -->
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
</xsl:stylesheet>