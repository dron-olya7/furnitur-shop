<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- МагазинСпискиИзбранного -->

	<xsl:template match="/">
		<xsl:apply-templates select="shop"/>
	</xsl:template>

	<xsl:template match="shop">
		<!-- Modal Div -->
		<div class="modal fade" id="favoriteList" tabindex="-1" aria-labelledby="cityModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-xl modal-dialog-centered">
				<div class="modal-content">
					<!-- <form method="post" action="{url}favorite/" class="validate"> -->
						<div class="modal-header modal-header-background">
							<h5 class="modal-title" id="myModalLabel">Добавление товара <xsl:value-of select="shop_item/name"/> в избранное</h5>
							<button type="button" class="close" data-dismiss="modal" aria-label="Close">
								<span aria-hidden="true"><i class="fa fa-times-circle"></i></span>
							</button>
						</div>

						<div class="modal-body">
							<div class="row align-items-center modal-base-favorite-list">
								<div class="col-11">
									<input class="form-control" type="text" name="name" autocomplete="off" placeholder="Введите название списка" value="" />
								</div>
								<div class="col-1">
									<i class="fa fa-plus-circle primary modal-add-favorite-list" title="Добавить список" onclick="$.addFavoriteList(this, '{url}favorite/', {@id} , {siteuser_id})"></i>
								</div>
							</div>

							<div class="row mt-2">
								<div class="col-12">
									<div>Выбрать список</div>
									<select class="form-control modal-select-favorite-list" name="shop_favorite_list_id">
										<option value="0" selected="selected">...</option>
										<xsl:apply-templates select="shop_favorite_list"/>
									</select>
								</div>
							</div>
						</div>

						<div class="modal-footer">
							<!-- <input type="hidden" value="1" name="addIntoFavoriteList" />
							<input type="hidden" value="{@id}" name="shop_id" />
							<input type="hidden" value="{siteuser_id}" name="siteuser_id" />
							<input type="hidden" value="{shop_item_id}" name="shop_item/id" /> -->
							<button class="btn btn-modal-favorite" onclick="$.addIntoFavoriteList('{url}favorite/', {shop_item/@id}, $('select[name = shop_favorite_list_id]').val())">Добавить</button>
						</div>
					<!-- </form> -->
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="shop_favorite_list">
		<option value="{@id}"><xsl:value-of select="name"/></option>
	</xsl:template>
</xsl:stylesheet>