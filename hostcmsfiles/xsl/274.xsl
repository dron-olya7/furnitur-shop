<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>
	
	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>
	
	<xsl:template match="/">
		<script type="text/javascript">
			<xsl:comment>
				<xsl:text disable-output-escaping="yes">
					<![CDATA[
					$(function() {
					var jForm = $('form.filter-form');
					mainFastFilter = new fastFilter(jForm);
					
					jForm.find(':input:not(:hidden):not(button)').on('change', function() {
					mainFastFilter.filterChanged($(this));
					});
					
					$('.filter-color').on('click', function(){
					var $this = $(this),
					property_id = $this.data('id'),
					list_item_id = $this.data('item-id'),
					id = 'property_' + property_id + '_' + list_item_id;
					
					if ($this.hasClass('active'))
					{
					$this.removeClass('active');
					
					$('#' + id).remove();
					}
					else
					{
					$this.addClass('active');
					$this.append('<input type="hidden" class="color-input" id="' + id + '" name="property_' + property_id + '" data-property="' + $this.data('property') + '" data-value="' + $this.data('value') + '" value="' + list_item_id + '"/>');
					}
					
					mainFastFilter.filterChanged($(this));
					});
					
					jForm.on('submit', function(e) {
					e.preventDefault();
					applyFilter();
					});
					});
					]]>
				</xsl:text>
			</xsl:comment>
		</script>
		
		<div class="filter filter-hidden">
			<xsl:apply-templates select="/shop"/>
		</div>
	</xsl:template>
	
	<xsl:variable name="n" select="number(3)"/>
	
	<xsl:template match="shop">
		<!-- Получаем ID родительской группы и записываем в переменную $group -->
		<xsl:variable name="group" select="group"/>
		
		<xsl:variable name="path">
			<xsl:choose>
				<xsl:when test="/shop//shop_group[@id=$group]/node()"><xsl:value-of select="/shop//shop_group[@id=$group]/url"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="/shop/url"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- дополнение пути для action, если выбрана метка -->
	<xsl:variable name="form_tag_url"><xsl:if test="count(tag) = 1">tag/<xsl:value-of select="tag/urlencode"/>/</xsl:if></xsl:variable>
		
		<form class="filter-form" method="get" action="{$path}" data-tag="{$form_tag_url}">
			<div class="row">
				<div class="col-12">
					<div class="property-list">
						<select class="wide" name="sorting" onchange="$(this).parents('form:first').submit()" placeholder="Сортировать">
							<option value="0">…</option>
							<option value="1">
							<xsl:if test="sorting = 1"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
								По цене (сначала дешевые)
							</option>
							<option value="2">
							<xsl:if test="sorting = 2"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
								По цене (сначала дорогие)
							</option>
							<option value="3">
							<xsl:if test="sorting = 3"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
								По названию
							</option>
						</select>
					</div>
				</div>
			</div>
			
			<xsl:if test="/shop/max_price &gt; 0">
				<div class="row">
					<div class="col-12">
						<div class="property-list">
							<div class="range-price-block">
								<h4 class="mt-3">Цена</h4>
								<div class="price-range-wrap">
									<div class="price-range"></div>
									
									<div class="range-slider">
										<div class="price-input">
											<input name="price_from" type="text" id="minamount" data-min="{/shop/min_price}" value="{/shop/min_price}">
												<xsl:if test="/shop/price_from != 0">
													<xsl:attribute name="value"><xsl:value-of select="/shop/price_from"/></xsl:attribute>
													<xsl:attribute name="data-min"><xsl:value-of select="/shop/price_from"/></xsl:attribute>
												</xsl:if>
											</input>
											
											<input name="price_to" type="text" id="maxamount" data-max="{/shop/max_price}" value="{/shop/max_price}">
												<xsl:if test="/shop/price_to != 0">
													<xsl:attribute name="value"><xsl:value-of select="/shop/price_to"/></xsl:attribute>
													<xsl:attribute name="data-max"><xsl:value-of select="/shop/price_to"/></xsl:attribute>
												</xsl:if>
											</input>
										</div>
									</div>
								</div>
								<input name="price_from_original" data-min="{/shop/min_price}" value="{/shop/min_price}" hidden="hidden" />
								<input name="price_to_original" data-max="{/shop/max_price}" value="{/shop/max_price}" hidden="hidden" />
							</div>
						</div>
					</div>
				</div>
			</xsl:if>
			
			<!-- Фильтр по дополнительным свойствам товара: -->
			<xsl:if test="count(shop_item_properties//property[filter != 0 and (type = 0 or type = 1 or type = 3 or type = 4 or type = 7 or type = 11) and tag_name != 'color' and count(filter_counts/count) &gt; 1])">
				<xsl:apply-templates select="shop_item_properties//property[filter != 0 and (type = 0 or type = 1 or type = 3 or type = 4 or type = 7 or type = 11) and tag_name != 'color']" mode="propertyList"/>
			</xsl:if>
			
			<xsl:if test="shop_item_properties//property[tag_name = 'color']/node() and count(shop_item_properties//property[tag_name = 'color'][count(filter_counts/count) &gt; 1]/list//list_item[icon != ''])">
				<div class="row">
					<div class="col-12">
						<div class="property-list sidebar-list mt-3">
							<div class="additional-options-wrapper">
								<xsl:variable name="propertyNode" select="/shop/shop_item_properties//property[tag_name = 'color']" />
								<div class="caption mb-2"><xsl:value-of select="$propertyNode/name"/></div>
								<div class="colors">
									<xsl:for-each select="shop_item_properties//property[tag_name = 'color']/list/list_item[icon != '']">
										<xsl:variable name="id" select="@id" />
										
										<xsl:if test="../../filter_counts/count[@id = $id]">
											<xsl:variable name="nodename">property_<xsl:value-of select="../../@id" /></xsl:variable>
											<xsl:variable name="color"><xsl:value-of select="icon" /></xsl:variable>
											<xsl:variable name="value" select="value" />
											
											<div style="background-color: {$color};" class="filter-color" title="{$value}" data-id="{../../@id}" data-property="{../../tag_name}" data-value="{value}" data-item-id="{@id}">
												<xsl:if test="/shop/*[name()=$nodename]/node() and /shop/*[name()=$nodename] = @id">
													<xsl:attribute name="class">filter-color active</xsl:attribute>
													<input type="hidden" class="color-input" id="property_{../../@id}_{@id}" name="property_{../../@id}" data-property="{../../tag_name}" data-value="{value}" value="{@id}"/>
												</xsl:if>
											</div>
										</xsl:if>
									</xsl:for-each>
								</div>
							</div>
						</div>
					</div>
				</div>
			</xsl:if>
			
			<xsl:if test="count(/shop/producers/shop_producer)">
				<div class="row">
					<div class="col-12">
						<div class="property-list">
							<h4 class="mt-3">Производитель</h4>
							<select class="wide" name="producer_id">
								<option value="0">...</option>
								<xsl:apply-templates select="/shop/producers/shop_producer" />
							</select>
						</div>
					</div>
				</div>
			</xsl:if>
			
			<div class="row">
				<div class="col-12">
				<div class="apply-button mt-3"><button class="btn w-100">Применить</button></div>
				</div>
			</div>
		</form>
	</xsl:template>
	
	<xsl:template match="shop_producer">
		<xsl:variable name="name">
			<xsl:choose>
				<xsl:when test="/shop/filter_mode = 0">
					<xsl:value-of select="name" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="path" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<option value="{@id}" data-producer="{$name}">
			<xsl:if test="/shop/producer_id = @id">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			
			<xsl:value-of select="name"/>
			
			<xsl:if test="count/node()">
			<xsl:text> (</xsl:text><xsl:value-of select="count"/><xsl:text>)</xsl:text>
			</xsl:if>
		</option>
	</xsl:template>
	
	<!-- Шаблон для фильтра по дополнительным свойствам -->
	<xsl:template match="property" mode="propertyList">
		<xsl:variable name="nodename">property_<xsl:value-of select="@id"/></xsl:variable>
		<xsl:variable name="nodename_from">property_<xsl:value-of select="@id"/>_from</xsl:variable>
		<xsl:variable name="nodename_to">property_<xsl:value-of select="@id"/>_to</xsl:variable>
		
		<xsl:variable name="filteringNode" select="/shop/*[name()=$nodename]" />
		
		<div class="row">
			<div class="col-12">
				<div class="property-list">
					<!-- Не флажок -->
					<xsl:if test="filter != 5 and filter != 6 or min/node()">
						<h4 class="mt-3"><xsl:value-of select="name"/></h4>
					</xsl:if>
					
					<xsl:choose>
						<!-- Отображаем поле ввода -->
						<xsl:when test="filter = 1">
							<div class="input-box">
								<input type="text" name="property_{@id}" data-property="{tag_name}">
									<xsl:if test="$filteringNode != ''">
										<xsl:attribute name="value"><xsl:value-of select="$filteringNode"/></xsl:attribute>
									</xsl:if>
								</input>
							</div>
						</xsl:when>
						<!-- Отображаем список -->
						<xsl:when test="filter = 2">
							<select class="wide" name="property_{@id}" >
								<option value="0">...</option>
								<xsl:apply-templates select="list/list_item">
									<xsl:with-param name="filteringNode" select="$filteringNode"/>
									<xsl:with-param name="propertyNode" select="."/>
								</xsl:apply-templates>
							</select>
						</xsl:when>
						<!-- Отображаем переключатели -->
						<xsl:when test="filter = 3">
							<!-- <div class="property-inline-wrapper">
								<div class="pretty p-default p-curve">
									<input name="property_{@id}" value="0" id="id_property_{@id}_0"/>
									<div class="state p-success-o">
										<label>Любой вариант</label>
									</div>
								</div>
							</div>-->
							
							<xsl:apply-templates select="list/list_item">
								<xsl:with-param name="filteringNode" select="$filteringNode"/>
								<xsl:with-param name="propertyNode" select="."/>
							</xsl:apply-templates>
						</xsl:when>
						<!-- Отображаем флажки -->
						<xsl:when test="filter = 4">
							<xsl:apply-templates select="list/list_item">
								<xsl:with-param name="filteringNode" select="$filteringNode"/>
								<xsl:with-param name="propertyNode" select="."/>
							</xsl:apply-templates>
						</xsl:when>
						<!-- Отображаем флажок -->
						<xsl:when test="filter = 5">
							<div class="property-inline-wrapper mt-3">
								<div class="pretty p-default p-pulse">
									<input type="checkbox" name="property_{@id}" value="1" id="property_{@id}" data-property="{tag_name}">
										<xsl:if test="$filteringNode != ''">
											<xsl:attribute name="checked"><xsl:value-of select="$filteringNode"/></xsl:attribute>
										</xsl:if>
									</input>
									
									<div class="state p-danger-o">
										<label><xsl:value-of select="name"/></label>
									</div>
								</div>
							</div>
						</xsl:when>
						<!-- Отображение полей "от и до" -->
						<xsl:when test="filter = 6">
							<!-- <div class="propertyInput">
								<div>
									<xsl:text>От </xsl:text>
									<input name="property_{@id}_from" size="5" type="text" value="{min}" data-property="{tag_name}">
										<xsl:if test="/shop/*[name()=$nodename_from] != 0">
											<xsl:attribute name="value"><xsl:value-of select="/shop/*[name()=$nodename_from]"/></xsl:attribute>
										</xsl:if>
									</input>
									
									<xsl:text>до </xsl:text>
									<input name="property_{@id}_to" size="5" type="text" value="{max}" data-property="{tag_name}">
										<xsl:if test="/shop/*[name()=$nodename_to] != 0">
											<xsl:attribute name="value"><xsl:value-of select="/shop/*[name()=$nodename_to]"/></xsl:attribute>
										</xsl:if>
									</input>
									
									<input name="property_{@id}_from_original" value="{min}" hidden="hidden" />
									<input name="property_{@id}_to_original" value="{max}" hidden="hidden" />
								</div>
								<div class="slider"></div><br/>
							</div>-->
							
							<xsl:if test="min/node()">
								<div class="range-price-block">
									<!-- <h4 class="mt-3">Цена</h4> -->
									<div class="price-range-wrap">
										<div class="price-range"></div>
										
										<div class="range-slider">
											<div class="price-input">
												<input name="property_{@id}_from" type="text" id="minamount" data-min="{min}" value="{min}" data-property="{tag_name}">
													<xsl:if test="/shop/*[name()=$nodename_from] != 0">
														<xsl:attribute name="value"><xsl:value-of select="/shop/*[name()=$nodename_from]"/></xsl:attribute>
														<xsl:attribute name="data-min"><xsl:value-of select="/shop/*[name()=$nodename_from]"/></xsl:attribute>
													</xsl:if>
												</input>
												
												<input name="property_{@id}_to" type="text" id="maxamount" data-max="{max}" value="{max}" data-property="{tag_name}">
													<xsl:if test="/shop/*[name()=$nodename_to] != 0">
														<xsl:attribute name="value"><xsl:value-of select="/shop/*[name()=$nodename_to]"/></xsl:attribute>
														<xsl:attribute name="data-max"><xsl:value-of select="/shop/*[name()=$nodename_to]"/></xsl:attribute>
													</xsl:if>
												</input>
											</div>
										</div>
									</div>
									
									<xsl:variable name="min">
										<xsl:choose>
											<xsl:when test="min/node()"><xsl:value-of select="min"/></xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									
									<xsl:variable name="max">
										<xsl:choose>
											<xsl:when test="max/node()"><xsl:value-of select="max"/></xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									
									<input name="property_{@id}_from_original" data-min="{$min}" value="{$min}" hidden="hidden" />
									<input name="property_{@id}_to_original" data-max="{$max}" value="{$max}" hidden="hidden" />
								</div>
							</xsl:if>
						</xsl:when>
						<!-- Отображаем список с множественным выбором-->
						<xsl:when test="filter = 7">
							<select class="wide" name="property_{@id}[]" multiple="multiple">
								<xsl:apply-templates select="list/list_item">
									<xsl:with-param name="filteringNode" select="$filteringNode"/>
									<xsl:with-param name="propertyNode" select="."/>
								</xsl:apply-templates>
							</select>
						</xsl:when>
					</xsl:choose>
				</div>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="list_item">
		<xsl:param name="filteringNode" />
		<xsl:param name="propertyNode" />
		<xsl:param name="sub"/>
		
		<xsl:variable name="list_item_id" select="@id"/>
		
		<xsl:variable name="value">
			<xsl:choose>
				<xsl:when test="/shop/filter_mode = 1 and path != ''">
					<xsl:value-of select="path" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="value" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="$sub = 1">
			<xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;
		</xsl:if>
		
		<!-- Так как установлено itemsPropertiesListJustAvailable, то здесь проверка не имеет смысла и долго работает -->
		<!-- <xsl:if test="$propertyNode/filter_counts/count[@id = $list_item_id]/node()"> -->
			<xsl:if test="$propertyNode/filter = 2">
				<!-- Отображаем список -->
				<xsl:variable name="nodename">property_<xsl:value-of select="$propertyNode/@id"/></xsl:variable>
				<option value="{@id}" data-property="{$propertyNode/tag_name}" data-value="{$value}">
				<xsl:if test="$filteringNode = @id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
					<xsl:value-of select="value"/>
					
					<xsl:variable name="filterCount" select="$propertyNode/filter_counts/count[@id = $list_item_id]" />
					<xsl:if test="$filterCount/node()">
					<xsl:text> (</xsl:text><xsl:value-of select="$filterCount"/><xsl:text>)</xsl:text>
					</xsl:if>
				</option>
			</xsl:if>
			<xsl:if test="$propertyNode/filter = 3">
				<!-- Отображаем переключатели -->
				<xsl:variable name="nodename">property_<xsl:value-of select="$propertyNode/@id"/></xsl:variable>
				<!-- <br/>
				<input type="radio" name="property_{$propertyNode/@id}" value="{@id}" id="id_property_{$propertyNode/@id}_{@id}" data-property="{$propertyNode/tag_name}" data-value="{$value}">
					<xsl:if test="$filteringNode = @id">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
					<label for="id_property_{$propertyNode/@id}_{@id}">
						<xsl:value-of select="value"/>
						
						<xsl:variable name="filterCount" select="$propertyNode/filter_counts/count[@id = $list_item_id]" />
						<xsl:if test="$filterCount/node()">
						<xsl:text> (</xsl:text><xsl:value-of select="$filterCount"/><xsl:text>)</xsl:text>
						</xsl:if>
					</label>
				</input>-->
				<div class="property-inline-wrapper">
					<div class="pretty p-default p-curve">
						<input type="radio" name="property_{$propertyNode/@id}" value="{@id}" id="id_property_{$propertyNode/@id}_{@id}" data-property="{$propertyNode/tag_name}" data-value="{$value}">
							<xsl:if test="$filteringNode = @id">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<div class="state p-danger-o">
							<label>
								<xsl:value-of select="value"/>
								<xsl:variable name="filterCount" select="$propertyNode/filter_counts/count[@id = $list_item_id]" />
								<xsl:if test="$filterCount/node()">
								<xsl:text> (</xsl:text><xsl:value-of select="$filterCount"/><xsl:text>)</xsl:text>
								</xsl:if>
							</label>
						</div>
					</div>
				</div>
			</xsl:if>
			<xsl:if test="$propertyNode/filter = 4">
				<!-- Отображаем флажки -->
				<xsl:variable name="nodename">property_<xsl:value-of select="$propertyNode/@id"/></xsl:variable>
				
				<div class="property-inline-wrapper">
					<div class="pretty p-default p-pulse">
						<input type="checkbox" value="{@id}" name="property_{$propertyNode/@id}[]" id="property_{$propertyNode/@id}_{@id}" data-property="{$propertyNode/tag_name}" data-value="{$value}">
							<xsl:if test="$filteringNode = @id">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<div class="state p-danger-o">
							<label>
								<xsl:value-of select="value"/>
							</label>
						</div>
					</div>
					<xsl:variable name="filterCount" select="$propertyNode/filter_counts/count[@id = $list_item_id]" />
					<xsl:if test="$filterCount/node()">
						<span class="badge badge-gray"><xsl:value-of select="$filterCount"/></span>
					</xsl:if>
				</div>
			</xsl:if>
			<xsl:if test="$propertyNode/filter = 7">
				<!-- Отображаем список -->
				<xsl:variable name="nodename">property_<xsl:value-of select="$propertyNode/@id"/></xsl:variable>
				<option value="{@id}" data-property="{$propertyNode/tag_name}" data-value="{$value}">
					<xsl:if test="$filteringNode = @id">
						<xsl:attribute name="selected">
						</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="value"/>
					
					<xsl:variable name="filterCount" select="$propertyNode/filter_counts/count[@id = $list_item_id]" />
					<xsl:if test="$filterCount/node()">
					<xsl:text> (</xsl:text><xsl:value-of select="$filterCount"/><xsl:text>)</xsl:text>
					</xsl:if>
				</option>
			</xsl:if>
			<!-- </xsl:if> -->
		
		<xsl:if test="list_item/node()">
			<xsl:apply-templates select="list_item">
				<xsl:with-param name="property" select="$propertyNode" />
				<xsl:with-param name="sub" select="1" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>