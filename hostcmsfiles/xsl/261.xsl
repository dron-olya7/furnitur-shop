<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<xsl:template match="/shop">
		<xsl:apply-templates select="shop_item"/>
	</xsl:template>

	<xsl:template match="shop_item">
		<!-- Store parent id in a variable -->
		<xsl:variable name="group" select="/shop/group"/>

		<xsl:variable name="id" select="@id" />

		<div class="container">
			<!-- Breadcrumbs -->
			<div class="breadcrumbs">
				<ul class="breadcrumbs-list">
				<li class="breadcrumbs-list-item"><a href="/">Главная</a></li>
					<xsl:apply-templates select="/shop//shop_group[@id = $group]" mode="breadcrumbs"/>
					<li class="breadcrumbs-list-item"><xsl:value-of select="name"/></li>
				</ul>
			</div>

			<!-- Show Message -->
			<xsl:if test="/shop/message/node()">
				<div class="alert alert-warning"><xsl:value-of disable-output-escaping="yes" select="/shop/message"/></div>
			</xsl:if>

			<div class="row product">
				<!-- <div class="col-12 col-md-7 order-last order-md-first product-block"> -->
					<div class="col-12 col-md-7 product-block">
						<div class="info">
							<xsl:if test="shop_producer/node()">
							<div class="vendor"><a href="{/shop/url}producers/{shop_producer/path}/"><xsl:value-of select="shop_producer/name"/></a></div>
							</xsl:if>
							<xsl:if test="rest &gt; 0">
								<div class="third">✓ В наличии</div>
							</xsl:if>
							<xsl:if test="marking != ''">
								<div class="marking">Артикул: <xsl:value-of select="marking"/></div>
							</xsl:if>
						</div>
						<h1 class="product-name"><xsl:value-of select="name"/></h1>
						<div class="row">
							<div class="col-12">
								<div class="product-flex">
									<xsl:if test="comments_average_grade/node()">
										<div class="five-stars-container" title="{comments_average_grade}/5">
											<span class="five-stars" style="width: {comments_average_grade * 20}%"></span>
										</div>
									</xsl:if>
									<div>
										<div id="compare{@id}" class="compare" onclick="return $.addCompare('{/shop/url}compare/', {@id}, this)">
											<xsl:if test="/shop/comparing/shop_item[@id = $id]/node()">
												<xsl:attribute name="class">compare selected</xsl:attribute>
											</xsl:if>
										<i class="fa fa-balance-scale third"></i><a href="#" class="third">Сравнить</a>
										</div>
										<div id="wishlist{@id}" class="wishlist" onclick="return $.addFavorite('{/shop/url}favorite/', {@id}, this)">
											<xsl:if test="/shop/favorite/shop_item[@id = $id]/node()">
												<xsl:attribute name="class">wishlist selected</xsl:attribute>
											</xsl:if>
										<i class="fa fa-heart-o primary"></i><a href="#" class="primary">Избранное</a>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-12">
								<div class="price main-price">
									<xsl:apply-templates select="/shop/shop_currency/code">
										<xsl:with-param name="value" select="price" />
									</xsl:apply-templates>
									<xsl:if test="discount != 0">
										<span class="old-price">
											<xsl:apply-templates select="/shop/shop_currency/code">
												<xsl:with-param name="value" select="price + discount" />
											</xsl:apply-templates>
										</span>
									</xsl:if>
								</div>
							</div>
						</div>

						<xsl:if test="description != ''">
							<div class="row">
								<div class="col-12">
									<div class="short-description">
										<xsl:value-of disable-output-escaping="yes" select="description"/>
									</div>
								</div>
							</div>
						</xsl:if>

						<!-- Метки -->
						<xsl:if test="count(tag)">
							<div class="row">
								<div class="col-12">
									<div class="tag-list">
										<xsl:apply-templates select="tag"/>
									</div>
								</div>
							</div>
						</xsl:if>

						<div class="row">
							<div class="col-12">
								<div class="product-flex add-cart-row">
									<div class="input-spinner">
										<div class="spinner-wrap">
											<input name="quantity" type="text" class="spinner" value="1" placeholder="1"/>
										</div>
									</div>
								<div><a id="cart" class="btn" data-item-id="{@id}" onclick="return $.bootstrapAddIntoCart('{/shop/url}cart/', $(this).data('item-id'), $('input[name = quantity]').val())">В корзину</a></div>
							<div><a id="fast_order" class="one-step-link" data-item-id="{@id}" onclick="return $.oneStepCheckout('{/shop/url}cart/', $(this).data('item-id'), $('input[name = quantity]').val())" data-toggle="modal" data-target="#oneStepCheckout{@id}"><i class="fa fa-mouse-pointer mr-1"></i>Купить в 1 клик</a></div>
								</div>
							</div>
						</div>

						<xsl:if test="modifications/node()">
							<!-- Размеры -->
							<!-- <xsl:if test="/shop/shop_item_properties//property[tag_name = 'size']/node()"> -->
								<xsl:variable name="sizes" select="modifications//property_value[tag_name = 'size']" />

								<xsl:if test="count($sizes)">
									<xsl:variable name="property" select="/shop/shop_item_properties//property[tag_name = 'size']" />
									<div class="row">
										<div class="col-12">
											<div class="additional-options-wrapper" data-property-id="{$property/@id}">
												<span class="caption"><xsl:value-of select="$property/name"/></span>
												<div class="sizes">
													<xsl:for-each select="$sizes">
														<xsl:if test="generate-id() = generate-id($sizes[. = current()][1])">
															<xsl:variable name="value" select="value" />
															<div onclick="$.selectModification(this, {$id}, '{/shop/url}')" data-name="sizes" data-id="{list_item_id}"><xsl:value-of select="value"/></div>
														</xsl:if>
													</xsl:for-each>
												</div>
											</div>
										</div>
									</div>
								</xsl:if>
							<!-- </xsl:if> -->

							<!-- Цвета -->
							<!-- <xsl:if test="/shop/shop_item_properties//property[tag_name = 'color']/node() and count(/shop/shop_item_properties//property[tag_name = 'color']/list//list_item[icon != ''])"> -->
								<xsl:variable name="colors" select="modifications//property_value[tag_name = 'color'][value/node()]" />

								<xsl:if test="count($colors)">
									<xsl:variable name="property" select="/shop/shop_item_properties//property[tag_name = 'color']" />
									<div class="row">
										<div class="col-12">
											<div class="additional-options-wrapper" data-property-id="{$property/@id}">
												<span class="caption"><xsl:value-of select="$property/name"/></span>
												<div class="colors">
													<xsl:for-each select="$colors">
														<xsl:if test="generate-id() = generate-id($colors[. = current()][1])">
															<xsl:variable name="color"><xsl:value-of select="icon" /></xsl:variable>
															<xsl:variable name="value" select="value" />

															<div style="background-color: {$color};" onclick="$.selectModification(this, {$id}, '{/shop/url}')" data-name="colors" data-id="{$property/list/list_item[value = $value]/@id}" title="{$value}"></div>
														</xsl:if>
													</xsl:for-each>
												</div>
											</div>
										</div>
									</div>
								</xsl:if>
							<!-- </xsl:if> -->

							<!-- Обычный вывод модификаций -->
							<xsl:if test="not(count($sizes)) and not(count($colors))">
								<div class="row">
									<div class="col-12">
										<div class="modifications-wrapper">
											<xsl:apply-templates select="modifications/shop_item" mode="modifications"/>
										</div>
									</div>
								</div>
							</xsl:if>
						</xsl:if>

						<!-- Склады, если больше 1 -->
						<xsl:if test="not(modifications/node()) and count(/shop/shop_warehouse) &gt; 1 and count(shop_warehouse_item) &gt; 1">
							<xsl:variable name="curr_item" select="." />
							<div class="row">
								<div class="col-12">
									<h6>Наличие на складах</h6>
									<xsl:for-each select="/shop/shop_warehouse">
										<xsl:variable name="warehouse_id" select="@id" />
										<div class="options-wrapper">
										<div><span class="bg-white"><xsl:value-of select="name"/></span></div>
											<div><xsl:value-of select="$curr_item//shop_warehouse_item[shop_warehouse_id = $warehouse_id]/count"/></div>
										</div>
									</xsl:for-each>
								</div>
							</div>
						</xsl:if>
					</div>
					<div class="col-12 col-md-5 col-pull-12">
						<div class="thumbnails">
							<xsl:if test="image_large != ''">
								<div class="main-image">
									<a href="{dir}{image_large}" class="thumbnail">
										<img id="zoom" data-src="{dir}{image_large}" class="lazyload" data-zoom-image="{dir}{image_large}"/>
									</a>
								</div>

								<xsl:if test="count(property_value[tag_name='img'][file !=''])">
									<div id="additional-images" class="additional-images-slider">
										<div class="item">
											<a href="{dir}{image_large}" class="elevatezoom-gallery active" data-image="{dir}{image_large}" data-zoom-image="{dir}{image_large}">
												<img class="item-main img-fluid lazyload" data-src="{dir}{image_large}" height="80" width="80"/>
											</a>
										</div>

										<xsl:for-each select="property_value[tag_name='img'][file !='']">
											<xsl:sort select="@id" />
											<div class="item">
												<a href="{../dir}{file}" class="elevatezoom-gallery" data-image="{../dir}{file}" data-zoom-image="{../dir}{file}">
													<img class="img-fluid lazyload" data-src="{../dir}{file}" height="80" width="80"/>
												</a>
											</div>
										</xsl:for-each>
									</div>
								</xsl:if>
							</xsl:if>
						</div>
					</div>
				</div>
			</div>

			<div class="product-tabs">
				<div class="container">
					<xsl:variable name="bProperties" select="count(property_value[not(file/node())][value != '']) or weight &gt; 0 or length &gt; 0 or width &gt; 0 or height &gt; 0" />
					<div class="tabs">
						<ul class="nav nav-tabs" id="shop-item-tabs" role="tablist">
							<xsl:if test="text != ''">
								<li class="nav-item" role="presentation">
									<a class="nav-link" id="description-tab" data-toggle="tab" href="#description" role="tab" aria-controls="description" aria-selected="false">Обзор</a>
								</li>
							</xsl:if>
							<xsl:if test="$bProperties">
								<li class="nav-item" role="presentation">
									<a class="nav-link" id="properties-tab" data-toggle="tab" href="#properties" role="tab" aria-controls="properties" aria-selected="false">Характеристики</a>
								</li>
							</xsl:if>
							<li class="nav-item" role="presentation">
							<a class="nav-link" id="comment-tab" data-toggle="tab" href="#comment" role="tab" aria-controls="comment" aria-selected="false">Отзывы <small><xsl:value-of select="comments_count"/></small></a>
							</li>
							<xsl:if test="shop_tabs/node()">
								<xsl:for-each select="shop_tabs/shop_tab">
									<li class="nav-item" role="presentation">
										<a class="nav-link" id="{@id}tab" data-toggle="tab" href="#tab{@id}" role="tab" aria-controls="tab{@id}" aria-selected="false"><xsl:value-of select="caption" /></a>
									</li>
								</xsl:for-each>
							</xsl:if>
						</ul>
					</div>
					<div class="tab-content">
						<div class="tab-pane" id="description" role="tabpanel">
							<xsl:choose>
								<xsl:when test="description != ''">
									<xsl:value-of disable-output-escaping="yes" select="text" />
								</xsl:when>
								<xsl:otherwise>
									<div class="alert alert-info" role="alert">
										Расширенное описание отсутствует
									</div>
								</xsl:otherwise>
							</xsl:choose>
						</div>
						<xsl:if test="$bProperties">
							<div class="tab-pane" id="properties" role="tabpanel">
								<!-- Вес -->
								<xsl:if test="weight &gt; 0">
									<div class="options-wrapper">
									<div><span>Вес</span></div>
									<div><xsl:value-of select="weight" /><xsl:text> </xsl:text><xsl:value-of select="/shop/shop_measure/name" /></div>
									</div>
								</xsl:if>

								<!-- Размер -->
								<xsl:if test="length &gt; 0 or width &gt; 0 or height &gt; 0">
									<div class="options-wrapper">
									<div><span>Размер Д×Ш×В</span></div>
							<div><xsl:value-of select="length" /><xsl:text> × </xsl:text><xsl:value-of select="width" /><xsl:text> × </xsl:text><xsl:value-of select="height" /><xsl:text> </xsl:text><xsl:value-of select="/shop/size_measure/name" /></div>
									</div>
								</xsl:if>

								<xsl:apply-templates select="property_value[not(file/node())]"/>
							</div>
						</xsl:if>
						<div class="tab-pane active" id="comment" role="tabpanel">
							<div class="comment-stats-wrapper">
								<div>
								<div class="average-rating"><span><xsl:value-of select="comments_average_grade" /></span> / 5</div>
									<ul class="rating" data-rating="{comments_average_grade}">
										<li class="rating-star"></li>
										<li class="rating-star"></li>
										<li class="rating-star"></li>
										<li class="rating-star"></li>
										<li class="rating-star"></li>
									</ul>
								</div>
								<div>
									<xsl:variable name="item" select="."/> <!-- Save current shop_item node -->
									<div class="comment-stats-line">
										<div class="title">Отлично</div>
										<xsl:variable name="five">
											<xsl:choose>
												<xsl:when test="number(count($item//comment[grade = 5]) div comments_count)">
													<xsl:value-of select="count($item//comment[grade = 5]) div comments_count * 100" />
												</xsl:when>
												<xsl:otherwise>0</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
									<div class="line"><span style="width: {$five}%"></span></div>
										<div class="count"><xsl:value-of select="count($item//comment[grade = 5])"/></div>
									</div>
									<div class="comment-stats-line">
										<div class="title">Очень хорошо</div>
										<xsl:variable name="four">
											<xsl:choose>
												<xsl:when test="number(count($item//comment[grade = 4]) div comments_count)">
													<xsl:value-of select="count($item//comment[grade = 4]) div comments_count * 100" />
												</xsl:when>
												<xsl:otherwise>0</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
									<div class="line"><span style="width: {$four}%"></span></div>
										<div class="count"><xsl:value-of select="count($item//comment[grade = 4])"/></div>
									</div>
									<div class="comment-stats-line">
										<div class="title">Неплохо</div>
										<xsl:variable name="three">
											<xsl:choose>
												<xsl:when test="number(count($item//comment[grade = 3]) div comments_count)">
													<xsl:value-of select="count($item//comment[grade = 3]) div comments_count * 100" />
												</xsl:when>
												<xsl:otherwise>0</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
									<div class="line"><span style="width: {$three}%"></span></div>
										<div class="count"><xsl:value-of select="count($item//comment[grade = 3])"/></div>
									</div>
									<div class="comment-stats-line">
										<div class="title">Плохо</div>
										<xsl:variable name="two">
											<xsl:choose>
												<xsl:when test="number(count($item//comment[grade = 2]) div comments_count)">
													<xsl:value-of select="count($item//comment[grade = 2]) div comments_count * 100" />
												</xsl:when>
												<xsl:otherwise>0</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
									<div class="line"><span style="width: {$two}%"></span></div>
										<div class="count"><xsl:value-of select="count($item//comment[grade = 2])"/></div>
									</div>
									<div class="comment-stats-line">
										<div class="title">Ужасно</div>
										<xsl:variable name="one">
											<xsl:choose>
												<xsl:when test="number(count($item//comment[grade = 1]) div comments_count)">
													<xsl:value-of select="count($item//comment[grade = 1]) div comments_count * 100" />
												</xsl:when>
												<xsl:otherwise>0</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
									<div class="line"><span style="width: {$one}%"></span></div>
										<div class="count"><xsl:value-of select="count($item//comment[grade = 1])"/></div>
									</div>
								</div>
							</div>
							<xsl:if test="/shop/show_comments/node() and /shop/show_comments = 1">
								<xsl:choose>
									<xsl:when test="count(comment)">
										<div class="row reviews">
											<!-- <div class="col-xs-12"> -->
												<div class="col-12">
													<xsl:apply-templates select="comment[parent_id = 0]"/>
												</div>
											</div>
										</xsl:when>
										<xsl:otherwise>
											<div class="alert alert-info item-text">Отзывы о товаре отсутствуют.</div>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>

								<!-- If allowed to display add comment form,
								1 - Only authorized
								2 - All
								-->
								<xsl:if test="/shop/show_add_comments/node() and ((/shop/show_add_comments = 1 and /shop/siteuser_id &gt; 0)  or /shop/show_add_comments = 2)">
									<div class="action">
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
							</div>
							<xsl:if test="shop_tabs/node()">
								<xsl:for-each select="shop_tabs/shop_tab">
									<div class="tab-pane" id="tab{@id}" role="tabpanel">
										<xsl:value-of disable-output-escaping="yes" select="text" />
									</div>
								</xsl:for-each>
							</xsl:if>
						</div>
					</div>
				</div>

				<!-- Состав текущего сета -->
				<xsl:if test="set/node()">
					<div class="favorite-main">
						<div class="container">
							<div class="section-title">
								<span class="h2">В набор входят</span>
							</div>
							<div class="row">
								<div class="col-12">
									<div class="products-row sets-include">
										<!-- Основной товар -->
										<xsl:apply-templates select="/shop/shop_item" mode="slider">
											<xsl:with-param name="type">main</xsl:with-param>
										</xsl:apply-templates>

										<div class="equal">=</div>
										<!-- Товары из набора -->
										<xsl:apply-templates select="set/shop_item" mode="slider">
											<xsl:with-param name="type">set</xsl:with-param>
										</xsl:apply-templates>
									</div>
								</div>
							</div>
						</div>
					</div>
				</xsl:if>

				<!-- Наборы -->
				<xsl:if test="/shop/parent_sets/node()">
					<div class="favorite-main">
						<div class="container">
							<div class="section-title">
								<span class="h2">Наборы</span>
							</div>
							<div class="row">
								<div class="col-12">
									<xsl:for-each select="/shop/parent_sets/shop_item">
										<div class="products-row sets-include">
											<xsl:if test="position() != last()">
												<xsl:attribute name="class">products-row sets-include mb-4</xsl:attribute>
											</xsl:if>

											<!-- Основной товар -->
											<xsl:apply-templates select="." mode="slider">
												<xsl:with-param name="type">main</xsl:with-param>
											</xsl:apply-templates>

											<div class="equal">=</div>
											<!-- Товары из набора -->
											<xsl:apply-templates select="set/shop_item" mode="slider">
												<xsl:with-param name="type">set</xsl:with-param>
											</xsl:apply-templates>
										</div>
									</xsl:for-each>
								</div>
							</div>
						</div>
					</div>
				</xsl:if>

				<!-- Сопутствующие -->
				<xsl:if test="associated/node()">
					<div class="favorite-main">
						<div class="container">
							<div class="section-title">
								<span class="h2">Рекомендуем посмотреть</span>
							</div>
							<div class="row">
								<div class="col-12">
									<div class="favorite-slider js-slider-favorite products-row">
										<xsl:if test="count(associated//shop_item) &gt; 4">
											<xsl:attribute name="class">favorite-slider js-slider-favorite products-row four</xsl:attribute>
										</xsl:if>
										<xsl:apply-templates select="associated/shop_item" mode="slider" />
									</div>
								</div>
							</div>
						</div>
					</div>
				</xsl:if>

				<SCRIPT>
					$(function() {
					$('#shop-item-tabs li:first-child a').tab('show');
					});
				</SCRIPT>
			</xsl:template>

			<xsl:template match="shop_item" mode="modifications">
				<div class="modification-item" title="{name}">
					<div class="image">
						<a href="{url}">
							<xsl:choose>
								<xsl:when test="image_small != ''">
									<img src="{dir}{image_small}"/>
								</xsl:when>
								<xsl:otherwise>
									<img src="/hostcmsfiles/assets/images/no-image.svg"/>
								</xsl:otherwise>
							</xsl:choose>
						</a>
					</div>
					<div class="name">
						<a href="{url}">
							<xsl:value-of select="name" />
						</a>
					</div>
					<div class="price">
						<xsl:apply-templates select="/shop/shop_currency/code">
							<xsl:with-param name="value" select="price" />
						</xsl:apply-templates>
						<xsl:if test="discount != 0">
							<span class="old-price">
								<xsl:apply-templates select="/shop/shop_currency/code">
									<xsl:with-param name="value" select="price + discount" />
								</xsl:apply-templates>
							</span>
						</xsl:if>
					</div>
				</div>
			</xsl:template>

			<!-- Show property item -->
			<xsl:template match="property_value">
				<xsl:if test="value/node() and value != '' or file/node() and file != ''">
					<xsl:variable name="property_id" select="property_id" />
					<xsl:variable name="property" select="/shop/shop_item_properties//property[@id=$property_id]" />

					<xsl:if test="$property/type != 7">
						<div class="options-wrapper">
						<div><span><xsl:value-of select="$property/name"/></span></div>
							<div><xsl:choose>
									<xsl:when test="$property/type = 2">
										<a href="{../dir}{file}" target="_blank"><xsl:value-of select="file_name"/></a>
									</xsl:when>
									<xsl:when test="$property/type = 7">
										<input type="checkbox" disabled="disabled">
											<xsl:if test="value = 1">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of disable-output-escaping="yes" select="value"/>
										<!-- Единица измерения свойства -->
										<xsl:if test="$property/shop_measure/node()">
											<xsl:text> </xsl:text><xsl:value-of select="$property/shop_measure/name"/>
										</xsl:if>
									</xsl:otherwise>
							</xsl:choose></div>
						</div>
					</xsl:if>
				</xsl:if>
			</xsl:template>

			<xsl:template match="shop_item" mode="slider">
				<xsl:param name="type"/>
				<xsl:variable name="id" select="@id" />
				<div class="product">
					<xsl:if test="$type = 'set' or $type = 'main'">
						<xsl:attribute name="class">product set</xsl:attribute>
					</xsl:if>
					<xsl:if test="discount != 0 or round(rest) = 0">
						<div class="product-labels">
							<xsl:if test="discount != 0">
								<div class="label label-discount">
									Скидка
									<xsl:choose>
										<xsl:when test="shop_discount/percent">
											<xsl:value-of disable-output-escaping="yes" select="round(shop_discount/percent)"/>%
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of disable-output-escaping="yes" select="shop_discount/value"/>
											<xsl:apply-templates select="/shop/shop_currency/code">
												<xsl:with-param name="value" select="price + discount" />
											</xsl:apply-templates>
										</xsl:otherwise>
									</xsl:choose>
								</div>
							</xsl:if>

							<xsl:if test="round(rest) = 0">
								<div class="label label-no-rest">Нет в наличии</div>
							</xsl:if>
						</div>
					</xsl:if>
					<div class="product-icons">
						<div id="compare{@id}" class="icon icon-compare" onclick="return $.addCompare('{/shop/url}compare/', {@id}, this)">
							<xsl:if test="/shop/comparing/shop_item[@id = $id]/node()">
								<xsl:attribute name="class">icon icon-compare active</xsl:attribute>
							</xsl:if>
							<i class="fa fa-balance-scale" title="Сравнение"></i>
						</div>
						<div id="wishlist{@id}" class="icon icon-favorite" onclick="return $.addFavorite('/shop/favorite/', {@id}, this)">
							<xsl:if test="/shop/favorite/shop_item[@id = $id]/node()">
								<xsl:attribute name="class">icon icon-favorite active</xsl:attribute>
							</xsl:if>
							<i class="fa fa-heart" title="Избранное"></i>
						</div>
					</div>
					<div class="product-img">
						<a title="{name}" href="{url}">
							<xsl:choose>
								<xsl:when test="image_small != ''">
									<img alt="{name}" src="{dir}{image_small}" />
								</xsl:when>
								<!-- Картинка родительского товара -->
								<xsl:when test="modification_id and shop_item/image_small != ''">
									<img alt="{name}" src="{shop_item/dir}{shop_item/image_small}" />
								</xsl:when>
								<xsl:otherwise><img src="/hostcmsfiles/assets/images/no-image.svg" alt="{name}"/></xsl:otherwise>
							</xsl:choose>
						</a>
					</div>
					<div class="product-description">
						<xsl:if test="comments_average_grade/node()">
							<div class="five-stars-container">
								<span class="five-stars" style="width: {comments_average_grade * 20}%"></span>
							</div>
						</xsl:if>
						<a href="{url}"><xsl:value-of select="name"/></a>
						<div class="clearfix"></div>
						<span class="product-price">
							<xsl:apply-templates select="/shop/shop_currency/code">
								<xsl:with-param name="value" select="price" />
							</xsl:apply-templates>
							<xsl:if test="discount != 0">
								<span class="old-price">
									<xsl:apply-templates select="/shop/shop_currency/code">
										<xsl:with-param name="value" select="price + discount" />
									</xsl:apply-templates>
								</span>
							</xsl:if>
						</span>
					</div>
					<div class="product-cart">
						<a class="btn" onclick="return $.bootstrapAddIntoCart('{/shop/url}cart/', {@id}, 1)">
						<span><i class="fa fa-shopping-basket"></i></span>
							<span>В корзину</span>
						</a>
					</div>
				</div>
				<xsl:if test="$type = 'set' and position() != last()">
					<div class="plus">+</div>
				</xsl:if>
			</xsl:template>

			<xsl:template match="tag">
				<a href="{/shop/url}tag/{urlencode}/">
					<xsl:value-of select="name"/>
				</a>
				<!-- <xsl:if test="position() != last()"> -->
					<!-- <xsl:text>, </xsl:text> -->
					<!-- </xsl:if> -->
			</xsl:template>

			<xsl:template name="AddCommentForm">
				<xsl:param name="id" select="0"/>

				<!-- Заполняем форму -->
				<xsl:variable name="subject">
					<xsl:if test="/shop/comment/parent_id/node() and /shop/comment/parent_id/node() and /shop/comment/parent_id= $id">
						<xsl:value-of select="/shop/comment/subject"/>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name="email">
					<xsl:if test="/shop/comment/email/node() and /shop/comment/parent_id/node() and /shop/comment/parent_id= $id">
						<xsl:value-of select="/shop/comment/email"/>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name="phone">
					<xsl:if test="/shop/comment/parent_id/node() and /shop/comment/parent_id/node() and /shop/comment/parent_id= $id">
						<xsl:value-of select="/shop/form_user_phone"/>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name="text">
					<xsl:if test="/shop/comment/text/node() and /shop/comment/parent_id/node() and /shop/comment/parent_id= $id">
						<xsl:value-of select="/shop/comment/text"/>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name="name">
					<xsl:if test="/shop/comment/author/node() and /shop/comment/parent_id/node() and /shop/comment/parent_id= $id">
						<xsl:value-of select="/shop/comment/author"/>
					</xsl:if>
				</xsl:variable>

				<div class="row">
					<div class="col-12">
						<div class="form-wrapper">
							<form action="{/shop/shop_item/url}" id="review" class="show" name="comment_form_0{$id}" method="post">
								<!-- Авторизированным не показываем -->
								<xsl:if test="/shop/siteuser_id = 0">
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
												<select name="grade">
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
								<xsl:if test="//captcha_id != 0 and /shop/siteuser_id = 0">
									<div class="form-group">
										<!-- <label for="textarea_text"></label> -->
										<div class="captcha captcha-refresh">
											<img id="comment_{$id}" class="captcha lazyload" data-src="/captcha.php?id={//captcha_id}{$id}&amp;height=30&amp;width=100" title="Контрольное число" name="captcha"/>
											<span class="d-flex align-items-center" onclick="$('#comment_{$id}').updateCaptcha('{//captcha_id}{$id}', 30); return false"><img class="mr-1" src="/images/refresh.png" /> Показать другое число</span>
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
						<xsl:if test="/shop/show_add_comments/node()
							and ((/shop/show_add_comments = 1 and /shop/siteuser_id > 0)
							or /shop/show_add_comments = 2)">
							<span class="review-answer" onclick="$('.action').hide();$('#AddComment input[name=\'parent_id\']').val('{@id}');$('#AddComment').show()">Ответить</span>
						</xsl:if>

						<span><xsl:value-of select="datetime"/></span>

						<span>
							<xsl:choose>
								<!-- Комментарий добавил авторизированный пользователь -->
								<xsl:when test="count(siteuser)">
								<i class="fa fa-user"></i><a href="/users/info/{siteuser/path}/"><xsl:value-of select="siteuser/login"/></a>
								</xsl:when>
								<!-- Комментарй добавил неавторизированный пользователь -->
								<xsl:otherwise>
									<xsl:if test="author != ''">
									<i class="fa fa-user"></i><span><xsl:value-of select="author" /></span>
									</xsl:if>
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

			<!-- Шаблон для вывода звездочек (оценки) -->
			<xsl:template name="for">
				<xsl:param name="i" select="0"/>
				<xsl:param name="n"/>

				<input type="radio" name="shop_grade" value="{$i}" id="id_shop_grade_{$i}">
					<xsl:if test="/shop/shop_grade = $i">
						<xsl:attribute name="checked"></xsl:attribute>
					</xsl:if>
			</input><xsl:text> </xsl:text>
				<label for="id_shop_grade_{$i}">
					<xsl:call-template name="show_average_grade">
						<xsl:with-param name="grade" select="$i"/>
						<xsl:with-param name="const_grade" select="5"/>
					</xsl:call-template>
				</label>
				<br/>
				<xsl:if test="$n &gt; $i and $n &gt; 1">
					<xsl:call-template name="for">
						<xsl:with-param name="i" select="$i + 1"/>
						<xsl:with-param name="n" select="$n"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:template>

			<!-- Шаблон выводит хлебные крошки -->
			<xsl:template match="shop_group" mode="breadcrumbs">
				<xsl:variable name="parent_id" select="parent_id"/>

				<!-- Call recursively parent group -->
				<xsl:apply-templates select="//shop_group[@id = $parent_id]" mode="breadcrumbs"/>

				<xsl:if test="parent_id = 0">
					<li class="breadcrumbs-list-item">
						<a href="{/shop/url}" hostcms:id="{/shop/@id}" hostcms:field="name" hostcms:entity="shop">
							<xsl:value-of select="/shop/name"/>
						</a>
					</li>
				</xsl:if>

				<li class="breadcrumbs-list-item">
					<a href="{url}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_group">
						<xsl:value-of select="name"/>
					</a>
				</li>
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