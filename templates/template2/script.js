jQuery.event.special.touchstart = {
	setup: function( _, ns, handle ) {
		this.addEventListener('touchstart', handle, { passive: !ns.includes('noPreventDefault') });
	}
};
jQuery.event.special.touchmove = {
	setup: function( _, ns, handle ) {
		this.addEventListener('touchmove', handle, { passive: !ns.includes('noPreventDefault') });
	}
};

// Функции без создания коллекции
$.extend({
	deleteLittleCart: function(path, shop_item_id){
		$.clientRequest({
			path: path + '?ajax=1&delete=' + shop_item_id,
			'callBack': $.deleteLittleCartCallback,
			context: $('.little-cart-wrapper')
		});
		return false;
	},
	deleteLittleCartCallback: function(data, status, jqXHR)
	{
		$.loadingScreen('hide');
		$(this).html(data);
	},
	addFavorite: function(path, shop_item_id, object){
		$("div#favoriteList").remove();

		var bSelected = $('.product-icons #wishlist' + shop_item_id + '.active').length || $('.product-block #wishlist' + shop_item_id + '.selected').length;

		var additional = parseInt(bSelected)
			? 'removeFavorite=1'
			: 'showDialog';

		$.clientRequest({
			path: path + '?loadFavoriteList&' + additional + '&shop_item_id=' + shop_item_id,
			'callBack': $.addFavoriteCallback,
			context: $('.little-wishlist')
		});

		return false;
	},
	addFavoriteCallback: function(data, status, jqXHR)
	{
	   	$.loadingScreen('hide');

	    if (data.siteuser_id)
	    {
    		$('body').append(data.html);
    		$("#favoriteList").modal("show");
	    }
	    else
	    {
    		$('.product-icons #wishlist' + data.shop_item_id).toggleClass('active');
    		$('.product-block #wishlist' + data.shop_item_id).toggleClass('selected');

    		$(this).html(data.html);
	    }

    	$.checkDot();

    	// Shake div
    	shake('.user-icon');
	},
    addIntoFavoriteList: function(path, shop_item_id, shop_favorite_list_id)
    {
		var emptyList = shop_favorite_list_id == 0
			? '&emptyList=1'
			: '';

		$.clientRequest({
			path: path + '?loadFavoriteList' + emptyList + '&showDialog&shop_item_id=' + shop_item_id + '&shop_favorite_list_id=' + shop_favorite_list_id,
			'callBack': $.addIntoFavoriteListCallback,
			context: $('.little-wishlist')
		});

		return false;
    },
	addIntoFavoriteListCallback: function(data, status, jqXHR)
	{
	    $.loadingScreen('hide');
	    $("#favoriteList").modal("hide");

		$('.product-icons #wishlist' + data.shop_item_id).toggleClass('active');
		$('.product-block #wishlist' + data.shop_item_id).toggleClass('selected');

		$(this).html(data.html);

    	$.checkDot();

    	// Shake div
    	shake('.user-icon');
	},
	addFavoriteList: function(object, path, shop_id, siteuser_id)
	{
		var $object = $(object),
			$parent = $object.parents('.modal-base-favorite-list'),
			$input = $parent.find('input[name = name]'),
			name = $input.val();

		$input.removeClass('error');

		if (name.length)
		{
    		$.ajax({
    			url: path,
    			type: 'POST',
    			data: { add_favorite_list: 1, name: name, shop_id: shop_id, siteuser_id: siteuser_id },
    			dataType: 'json',
    			success: function (response) {
    			    if (response.status == 'success')
    			    {
        			    $('select.modal-select-favorite-list').append($('<option>', {
                            value: response.id,
                            text: response.name
                        }));

						$input.val('');
    			    }
    			}
    		});
		}
		else
		{
			$input.addClass('error');
		}
	},
	addCompare: function(path, shop_item_id, object){
		$('.product-icons #compare' + shop_item_id).toggleClass('active');
		$('.product-block #compare' + shop_item_id).toggleClass('selected');

		$.clientRequest({
			path: path + '?compare=' + shop_item_id,
			'callBack': $.addCompareCallback,
			context: $('.little-compare')
		});

		return false;
	},
	addCompareCallback: function(data, status, jqXHR)
	{
		$.loadingScreen('hide');
		$(this).html(data.html);

		var countItems = parseInt($('.compare-items').val());

		if (!data.total || !countItems)
		{
			$('.compare-table').parent().remove();
			$('.compare-alert').removeClass('d-none');
		}

		$.checkDot();

		// Shake div
		shake('.user-icon');
	},
	checkDot: function()
	{
		var $dot = $('.user-icon .dot'),
			compares = parseInt($('.compare-list li').length),
			favorites = parseInt($('.wishlist-list li').length);

		$dot.attr('class', '').addClass('dot');

		if (favorites && !compares)
		{
			$dot.attr('class', '').addClass('dot favorite');
		}
		else if (compares && !favorites)
		{
			$dot.attr('class', '').addClass('dot compare');
		}
		else if (!compares && !favorites)
		{
			$dot.attr('class', '').addClass('dot hidden');
		}
	},
	bootstrapAddIntoCart: function(path, shop_item_id, count){
		$.clientRequest({
			path: path + '?add=' + shop_item_id + '&count=' + count,
			'callBack': $.bootstrapAddIntoCartCallback,
			context: $('.little-cart-wrapper')
		});
		return false;
	},
	bootstrapAddIntoCartCallback: function(data, status, jqXHR)
	{
		$.loadingScreen('hide');
		$(this).html(data);

		// Shake div
		shake('.little-cart-icon');
	},
	oneStepCheckout: function(path, shop_item_id, count)
	{
		$("div#oneStepCheckout").remove();

		$.clientRequest({
			path: path + '?oneStepCheckout&showDialog&shop_item_id=' + shop_item_id + '&count=' + count,
			'callBack': $.oneStepCheckoutCallback,
			context: ''
		});
		return false;
	},
	oneStepCheckoutCallback: function(data, status, jqXHR)
	{
		$.loadingScreen('hide');
		$("body").append(data.html);
		$("#oneStepCheckout").modal("show");
	},
	getOnestepDeliveryList: function(path, shop_item_id, $form)
	{
		var shop_country_id = $form.find("#shop_country_id").val(),
			shop_country_location_id = $form.find("#shop_country_location_id").val(),
			shop_country_location_city_id = $form.find("#shop_country_location_city_id").val(),
			shop_country_location_city_area_id = $form.find("#shop_country_location_city_area_id").val();

		$.clientRequest({
			path: path + '?oneStepCheckout&showDelivery&shop_country_id=' + shop_country_id + '&shop_country_location_id=' + shop_country_location_id + '&shop_country_location_city_id=' + shop_country_location_city_id + '&shop_country_location_city_area_id=' + shop_country_location_city_area_id + '&shop_item_id=' + shop_item_id,
			'callBack': $.getOnestepDeliveryListCallback,
			context: $form.find("#shop_delivery_condition_id")
		});
	},
	getOnestepDeliveryListCallback: function(data, status, jqXHR)
	{
		$.loadingScreen('hide');
		$("#shop_delivery_condition_id").empty();

		$.each(data.delivery, function(key, object) {
			$('#shop_delivery_condition_id').append('<option value=' + object.shop_delivery_condition_id + '>' + object.name + '</option>');
		});
	},
	getOnestepPaymentSystemList: function(path, $form)
	{
		var shop_delivery_condition_id = $form.find("#shop_delivery_condition_id").val();

		$.clientRequest({
			path: path + '?oneStepCheckout&showPaymentSystem&shop_delivery_condition_id=' + shop_delivery_condition_id,
			'callBack': $.getOnestepPaymentSystemListCallback,
			context: $form.find("#shop_payment_system_id")
		});
	},
	getOnestepPaymentSystemListCallback: function(data, status, jqXHR)
	{
		$.loadingScreen('hide');
		$("#shop_payment_system_id").empty();
		$.each(data.payment_systems, function(key, object) {
			$('#shop_payment_system_id').append('<option value=' + object.id + '>' + object.name + '</option>');
		});
	},
	selectModification: function (object, shop_item_id, path)
	{
		var $object = $(object),
			name = $(object).data('name'),
			data = { 'selectModification': 1, 'shop_item_id': shop_item_id },
			isActive = $object.hasClass('active');

		$('.additional-options-wrapper .' + name + ' div').removeClass('active');
		!isActive && $object.addClass('active');

		$('.additional-options-wrapper').each(function(index) {
			data['property_' + $(this).data('property-id')] = $(this).find('div.active').data('id') || 0;
		});

		$.ajax({
			url: path,
			type: 'POST',
			data: data,
			dataType: 'json',
			success: function (answer) {
				$('.additional-options-wrapper div[data-id]').removeClass('not-available');
				$('.add-cart-row').removeClass('inactive');

				if (answer.available)
				{
					$.each(answer.available, function(property_id, aPropertyValueIds) {
						$('.additional-options-wrapper[data-property-id = ' + property_id + '] div[data-id]').each(function(index) {
							if ($.inArray($(this).data('id'), aPropertyValueIds) < 0)
							{
								$(this).addClass('not-available');
							}
						});
					});
				}

				if (answer.available && answer.available.length === 0)
				{
					$('.additional-options-wrapper div[data-id]').addClass('not-available');
					$('.add-cart-row').addClass('inactive');
				}

				if (answer.items)
				{
					if (answer.items.length == 1)
					{
						// Подменяем параметры
						$.changeAttributes(answer.items[0]);
					}
					else // Если нашлось несколько модификаций - показываем модальное окно для выбора
					{
						var aItems = [];

						html = '<div class="row">';

						$.each(answer.items, function(key, oModification) {
							html += '<div class="col-12"><div class="select-modification-item" data-id="' + oModification.id + '"><span class="name">' + oModification.name + '</span><span class="price">' + oModification.price +  ' ₽</span></div></div>';

							aItems['item_' + oModification.id] = oModification;
						});

						html += '</div>';

						$('body').append(
							'<div class="modal fade" id="selectModificationModal" tabindex="-1" aria-labelledby="selectModificationModalLabel" aria-hidden="true">\
								<div class="modal-dialog modal-lg modal-dialog-centered">\
									<div class="modal-content">\
										<div class="modal-header modal-header-background">\
											<h5 class="modal-title">Выберите товар</h5>\
											<button type="button" class="close" data-dismiss="modal" aria-label="Close">\
												<span aria-hidden="true">&times;</span>\
											</button>\
										</div>\
										<div class="modal-body">' + html + '</div>\
									</div>\
								</div>\
							</div>'
						);

						$('#selectModificationModal').modal('show');

						$('.select-modification-item').on('click', function(){
							var $id = $(this).data('id');

							if (aItems['item_' + $id])
							{
								$.changeAttributes(aItems['item_' + $id]);
								$('#selectModificationModal').modal('hide');
							}
						});
					}
				}

				// Если ничего не нашлось, возвращаем параметры основного товара
				if (answer.items == undefined && answer.parent)
				{
					$.changeAttributes(answer.parent);
				}

				$('#selectModificationModal').on('hidden.bs.modal', function () {
					$(this).remove();
				});
			}
		});
	},
	changeAttributes(item)
	{
		// Меняем цену
		var price = parseFloat(item.price),
			discount = parseFloat(item.discount);

		if (discount)
		{
			var old_price = price + discount;

			if (old_price != price)
			{
				price = price.toLocaleString() + ' ₽<span class="old-price">' + old_price.toLocaleString() + ' ₽</span>';
			}
		}
		else
		{
			price = price.toLocaleString() + ' ₽';
		}

		$('.product-block .price.main-price').html(price);

		if (item.description.length)
		{
			$('.product-block .short-description').html(item.description);
		}

		if (item.text.length)
		{
			$('#description').html(item.text);
		}

		if (item.name.length)
		{
			$('.product-block .product-name').html(item.name);
		}

		// Подмена для корзины
		$('.add-cart-row a#cart').data('item-id', item.id);

		// Подмена для быстрого заказа
		$('.add-cart-row a#fast_order').data('item-id', item.id).data('target', '#oneStepCheckout' + item.id);
	},
	addDirectoryRow: function(object)
	{
		row = $(object).parents('.directory-row');
		rowClone = row.clone();

		var jObjectInput = rowClone.find('.directory-row-input'),
			jObjectCheckbox = rowClone.find('input[type="checkbox"]'),
			jObjectSelect = rowClone.find('select');

		jObjectInput.val('');
		jObjectCheckbox.prop('checked', false);

		// Input name
		var reg = /^(\S+)_(\d+)_([A-Za-z]+)(\d+)$/,
			arr = reg.exec(jObjectInput.prop('name')),
			count = arr == null ? 0 : (arr.length || 0);

		count == 5 && jObjectInput.prop('name', arr[1] + '_' + arr[2] + '_' + arr[3] + '[]');

		// Select name
		var reg = /^(\S+)_(\d+)_(\S+)_(\S+)_([A-Za-z]+)(\d+)$/,
			arr = reg.exec(jObjectSelect.prop('name')),
			count = arr == null ? 0 : (arr.length || 0);

		count == 7 && jObjectSelect.prop('name', arr[1] + '_' + arr[2] + '_' + arr[3] + '_' + arr[4] + '_' + arr[5] + '[]');

		// Checkbox name
		var reg = /^(\S+)_(\d+)_(\S+)_([A-Za-z]+)(\d+)$/,
			arr = reg.exec(jObjectCheckbox.prop('name')),
			count = arr == null ? 0 : (arr.length || 0);

		count == 6 && jObjectCheckbox.prop('name', arr[1] + '_' + arr[2] + '_' + arr[3] + '_' + arr[4] + '[]');

		$(object).remove();

		row.after(rowClone);

		return false;
	},
	applyNewsletter: function(object)
	{
		var $form = $(object).parents(".newsletter-wrapper").find("form"),
			jInput = $form.find(".news-form-con"),
			email = jInput.val();

		if (email.length)
		{
			$.ajax({
				url: $form.attr('action'),
				type: 'POST',
				data: {'stealthSubscribe': 1, 'email': email},
				dataType: 'json',
				success: function (answer) {
					var message = answer.success.length
							? answer.success
							: answer.error;

					bootbox.dialog({
						message: message,
						className: 'newsletter-dialog'
					});
				}
			});
		}
	},
	subscribeMaillist: function(path, maillist_id, type){
		$.clientRequest({
			path: path + '?maillist_id=' + maillist_id + '&type=' + type,
			'callBack': $.subscribeMaillistCallback,
			context: $('#subscribed_' + maillist_id)
		});
		return false;
	},
	subscribeMaillistCallback: function(data, status, jqXHR)
	{
		$.loadingScreen('hide');
		$(this).removeClass('hidden').next().hide();
	},
	cartSelectSiteuser: function(object, cartUrl)
	{
		$('.cart-siteuser-field, .cart-siteuser-field i').removeClass('current');

		var $parentDiv = $(object).parent(),
			$form = $('form.cart-form'),
			$selectCountry = $('select[name = shop_country_id]', $form),
			$spanCartCountry = $parentDiv.find('span.cart-country'),
			$spanCartCity = $parentDiv.find('span.cart-city');

		$('input[name = name]', $form).val($parentDiv.find('span.cart-name').text());
		$('input[name = surname]', $form).val($parentDiv.find('span.cart-surname').text());
		$('input[name = patronymic]', $form).val($parentDiv.find('span.cart-patronymic').text());
		$('input[name = company]', $form).val($parentDiv.find('span.cart-company-name').text());
		$('input[name = phone]', $form).val($parentDiv.find('span.cart-phone').text());
		$('input[name = address]', $form).val($parentDiv.find('span.cart-address').text());

		$('input[name = postcode]', $form).val($parentDiv.find('span.cart-postcode').text());

		if ($spanCartCountry.text().length)
		{
			// Country
			$selectCountry
				.find('option:contains("' + $spanCartCountry.text() + '")')
				.prop("selected", true);

			$selectCountry.niceSelect('update');

			if ($spanCartCity.text().length)
			{
				// Reload country locations and cities
				$.loadLocations(cartUrl, $selectCountry.val(), function(){
					// $selectCountry.niceSelect('update');
					$.loadCityByName($selectCountry.val(), $spanCartCity.text() , cartUrl);
				});
			}
		}

		$parentDiv.addClass('current');
		$(object).addClass('current');
	},
	loadingScreen: function(method) {
		// Method calling logic
		if (methods[method] ) {
			return methods[method].apply(this, Array.prototype.slice.call( arguments, 1 ));
		} else {
			$.error( 'Method ' +  method + ' does not exist on jQuery.tooltip' );
		}
	},
	clientSelectOptionsCallback: function(data, status, jqXHR) {
		$.loadingScreen('hide');

		var $object = jQuery(this);

		$object.empty();
		for (var key in data)
		{
			$object.append(jQuery('<option>').attr('value', key.substr(1)).text(data[key]));
		}
		$object.change();
	},
	clientRequest: function(settings) {
		if (typeof settings.callBack == 'undefined')
		{
			alert('Callback function is undefined');
		}

		$.loadingScreen('show');

		var path = settings.path,
			data = (typeof settings.data != 'undefined') ? settings.data : {};

		data['_'] = Math.round(new Date().getTime());

		jQuery.ajax({
			context: settings.context,
			url: path,
			type: 'POST',
			data: data,
			dataType: 'json',
			success: settings.callBack
		});
		return false;
	},
	loadLocations: function(path, shop_country_id, callback)
	{
		if (shop_country_id)
		{
			$('#shop_country_location_city_id').clearSelect();
			$('#shop_country_location_city_area_id').clearSelect();
			$.clientRequest({path: path + '?ajaxLoad&shop_country_id=' + shop_country_id, 'callBack': [$.clientSelectOptionsCallback, callback], context: $('#shop_country_location_id')});
		}
	},
	loadCities: function(path, shop_country_location_id, callback)
	{
		if (shop_country_location_id)
		{
			$('#shop_country_location_city_area_id').clearSelect();
			$.clientRequest({path: path + '?ajaxLoad&shop_country_location_id=' + shop_country_location_id, 'callBack': [$.clientSelectOptionsCallback, callback], context: $('#shop_country_location_city_id')});
		}
	},
	loadCityAreas: function(path, shop_country_location_city_id, callback)
	{
		if (shop_country_location_city_id)
		{
			$.clientRequest({path: path + '?ajaxLoad&shop_country_location_city_id=' + shop_country_location_city_id, 'callBack': [$.clientSelectOptionsCallback, callback], context: $('#shop_country_location_city_area_id')});
		}
	},
	loadCityByName: function(shopCountryId, cityName, cartUrl)
	{
		if (shopCountryId)
		{
			$('#shop_country_location_city_area_id').clearSelect();
			$.clientRequest({path: cartUrl + '?ajaxLoad&shop_country_id=' + shopCountryId + '&city_name=' + cityName, 'callBack': $.loadCityByNameCallback, context: $('#shop_country_location_city_id')});
		}
	},
	loadCityByNameCallback: function(data, status, jqXHR) {
		$.loadingScreen('hide');

		if (data.result)
		{
			var $object = jQuery(this);

			$('select[name = shop_country_location_id]')
				.val(data.result.shop_country_location_id)
				.niceSelect('update');

			for (var key in data.cities)
			{
				$object.append(jQuery('<option>').attr('value', key.substr(1)).text(data.cities[key]));
			}

			$('select[name = shop_country_location_city_id]')
				.find('option[value = "' + data.result.shop_country_location_city_id + '"]')
				.prop("selected", true);

			$object.change();
		}
	},
	friendOperations: function(data, status, jqXHR) {
		$.loadingScreen('hide');
		var $this = jQuery(this);

		switch (data)
		{
			case 'Added':
				$this.text('Запрос на добавление в друзья отправлен.').prop("onclick", null);
			break;
			case 'Removed':
				$this.text('Пользователь убран из друзей.').prop("onclick", null);
			break;
		}
	}
});

$.fn.extend({
	updateCaptcha: function(captchaKey, captchaHeight) {
		return this.each(function(index, object) {
			jQuery(object).prop('src', "/captcha.php?get_captcha=" + captchaKey + "&height=" + captchaHeight + "&anc=" + Math.floor(Math.random()*100000));
		});
	},
	clearSelect: function()
	{
		return this.each(function(index, object){
			jQuery(object).empty().append(jQuery('<option>').attr('value', 0).text('…'));
		});
	}
});

var methods = {
	show : function() {
		$('body').css('cursor', 'wait');
		var fade_div = $('#ajaxLoader'), jWindow = $(window);
		if (fade_div.length === 0)
		{
			fade_div = $('<div></div>')
				.appendTo(document.body)
				.hide()
				.prop('id', 'ajaxLoader')
				.css('z-index', '1500')
				.css('position', 'absolute')
				.append($('<img>').prop('src', '/hostcmsfiles/images/ajax_loader.gif'));
		}

		fade_div.show()
			.css('top', (jWindow.height() - fade_div.outerHeight(true)) / 2 + jWindow.scrollTop())
			.css('left', (jWindow.width() - fade_div.outerWidth(true)) / 2 + jWindow.scrollLeft());
	},
	hide : function( ) {
		$('#ajaxLoader').hide().css('left', -1000);
		$('body').css('cursor', 'auto');
	}
};

$(function() {
	if ($("#zoom").length){
		var zoomImage = $('img#zoom');
		var image = $('#additional-images a');
		var zoomConfig = {
			gallery:'additional-images',
			cursor: 'zoom-in',
			zoomType: "inner",
			galleryActiveClass: 'active',
			responsive: true
		};

		$("#zoom").elevateZoom(zoomConfig);

		image.on('click', function(){
			var largeImage = $(this).attr('data-zoom-image');
			$('.thumbnail').attr('href', largeImage);
			// Remove old instance od EZ
			$('.zoomContainer').remove();
			zoomImage.removeData('elevateZoom');
			// Update source for images
			zoomImage.attr('src', $(this).data('image'));
			zoomImage.data('zoom-image', $(this).data('zoom-image'));
			// Reinitialize EZ
			zoomImage.elevateZoom(zoomConfig);
		});

		$(document).on('click', '.thumbnail', function () {
			if ($('.additional-images-slider').length)
			{
				$('.thumbnails').magnificPopup('open', 0);
			}

			return false;
		});

		$('.thumbnails').magnificPopup({
			delegate: '.owl-item:not(".cloned") a.elevatezoom-gallery:has(img)',
			type: 'image',
			tLoading: 'Loading image #%curr%...',
			mainClass: 'mfp-with-zoom',
			gallery: {
				enabled: true,
				//navigateByImgClick: true,
				preload: [0,1], // Will preload 0 - before current, and 1 after the current image
				tCounter: ''
			},
			image: {
				tError: '<a href="%url%">The image #%curr%</a> could not be loaded.',
			}
		});

		var owlAdditionalImages = $('.additional-images-slider');
		owlAdditionalImages.owlCarousel({
			loop: true,
			margin: 10,
			nav: true,
			dots: false,
			items: 3,
			lazyLoad: true,
			navText: [
				"<i class='fa fa-chevron-left'></i>",
				"<i class='fa fa-chevron-right'></i>"
			],
		});
	}

	var $mainSlider = $('.js-slider-main'),
		$mainSliderImg = $('.main-slider-img');

	if ($mainSliderImg.length) {
		$mainSlider.find($mainSliderImg).each(function(){
			var atti, $tfi = $(this).find('img');
			atti = !$tfi.hasClass('src-img')
				? $tfi.data('bg')
				: $tfi.attr('src');

			var src = 'url(' + atti + ')';
			$(this).css('background-image', src);
			$(this).find('img').hide();
		});
	}

	$mainSlider.each(function(){
		$(this).slick({
			dots: true,
			arrows: true,
			prevArrow: '<span class="slick-prev"><i class="fa fa-chevron-left"></span>',
			nextArrow: '<span class="slick-next"><i class="fa fa-chevron-right"></span>',
			appendArrows: '.arrows-container',
			slidesToShow: 1,
			slidesToScroll: 1,
			speed: 500,
			autoplay: true,
			autoplaySpeed: 5000,
			responsive: [
				{
					breakpoint: 767,
					settings: {
						arrows: true,
						dots: false,
					}
				}
			]
		});
	});

	// Brands slider
	var $sliderBrands = $('.js-slider-brands');

	if ($sliderBrands.length) {
		$sliderBrands.slick({
			dots: false,
			arrows: true,
			slidesToShow: 6,
			slidesToScroll: 1,
			prevArrow: '<span class="slick-prev"><i class="fa fa-chevron-left"></span>',
			nextArrow: '<span class="slick-next"><i class="fa fa-chevron-right"></span>',
			responsive: [
				{
					breakpoint: 1024,
					settings: {
						slidesToShow: 5
					}
				},
				{
					breakpoint: 767,
					settings: {
						slidesToShow: 3
					}
				},
				{
					breakpoint: 450,
					settings: {
						slidesToShow: 1
					}
				}
			]
		});
	}

	// Viewed slider
	var $sliderViewed = $('.js-slider-viewed, .js-slider-favorite');

	if ($sliderViewed.length) {
		$sliderViewed.slick({
			dots: false,
			arrows: true,
			slidesToShow: 4,
			slidesToScroll: 1,
			prevArrow: '<span class="slick-prev"><i class="fa fa-chevron-left"></span>',
			nextArrow: '<span class="slick-next"><i class="fa fa-chevron-right"></span>',
			responsive: [
				{
					breakpoint: 991,
					settings: {
						slidesToShow: 3
					}
				},
				{
					breakpoint: 767,
					settings: {
						slidesToShow: 2
					}
				},
				{
					breakpoint: 450,
					settings: {
						slidesToShow: 1,
						arrows: false
					}
				}
			]
		});
	}

	var $shopItemSlider = $('.js-simple-slider');

	if ($shopItemSlider.length) {
		$shopItemSlider.slick({
			dots: false,
			arrows: true,
			infinite: false,
			slidesToShow: 1,
			slidesToScroll: 1,
			prevArrow: '<span class="slick-prev"><i class="fa fa-chevron-left"></span>',
			nextArrow: '<span class="slick-next"><i class="fa fa-chevron-right"></span>',
		});
	}

	// jQuery.Autocomplete selectors
	$('.search-top').autocomplete({
		serviceUrl: '/search/?autocomplete=1',
		//delimiter: ',',
		maxHeight: 200,
		width: 300,
		deferRequestBy: 300,
		// appendTo: '.top-search-form',
		appendTo: '.search-top-suggestions',
		onSelect: function (suggestion) {
			//$(this).closest("form").submit();
			window.location.href = suggestion.path;
		}
	});

	// Small screen search
	$('input#search').autocomplete({
		serviceUrl: '/search/?autocomplete=1',
		//delimiter: ',',
		maxHeight: 200,
		width: 300,
		deferRequestBy: 300,
		// appendTo: '.top-search-form',
		appendTo: '.search-top-suggestions',
		onSelect: function (suggestion) {
			//$(this).closest("form").submit();
			window.location.href = suggestion.path;
		}
	});

	/*-----------------------
		Price Range Slider
	------------------------ */
	$(".price-range").each(function(){
		var rangeSlider = $(this),
		jParent = $(this).parents('.range-price-block'),
        minamount = jParent.find('#minamount'),
        maxamount = jParent.find("#maxamount"),
		currency = typeof minamount.data('property') == 'undefined' ? ' ₽' : '';

		rangeSlider.slider({
			range: true,
			slide: function (event, ui) {
				minamount.val(ui.values[0] + currency).change();
				maxamount.val(ui.values[1] + currency).change();

				minamount.data('min', ui.values[0]);
				maxamount.data('max', ui.values[1]);

				jParent.find('input[name $= "_from_original"]').val(ui.values[0]);
				jParent.find('input[name $= "_to_original"]').val(ui.values[1]);
			},
			create: function(event, ui) {
				var min_value_original = parseInt(jParent.find('input[name $= "_from_original"]').data('min')),
					max_value_original = parseInt(jParent.find('input[name $= "_to_original"]').data('max')),
					minValue = parseInt(jParent.find('input[name $= "_from"]').data('min')),
					maxValue = parseInt(jParent.find('input[name $= "_to"]').data('max'));

				$(this).slider({
					min: min_value_original,
					max: max_value_original,
					values: [minValue, maxValue]
				});
			}
		});

		minamount.val(rangeSlider.slider("values", 0) + currency);
		maxamount.val(rangeSlider.slider("values", 1) + currency);
	});

	$('select:not([name = grade])').niceSelect();

	$('.stars').stars({
		inputType: "select", disableValue: false
	});

	$(window).scroll(function () {
		if ($(this).scrollTop() > 70) {
			$('#back-to-top').removeClass('off').addClass('on').fadeIn();
		} else {
			$('#back-to-top').removeClass('on').addClass('off').fadeOut();
		}
	});

	// scroll body to 0px on click
	$('#back-to-top').click(function () {
		$('body,html').animate({
			scrollTop: 0
		}, 800);
		return false;
	});

	// ----------- fixed nav -----------
	navScroll.init();

	// Search
	$('.header-icons .search-icon i').on('click', function(){
		var $input = $(this).next();

		// console.log($input.is(":hidden"));

		if ($input.is(":hidden"))
		{
			$('.search-wrapper').hostcmsPopup({responsiveWidthBreakpoint: 992, animateResize: 'height'});
		}
		// else
		// {
			$input.toggleClass('hidden shown');
		// }
	});

	$('.header-top-city').on('click', function(){
		$('#cityModal').modal('show')
	});

	// Phone information popup
	$('.header-top-phone i.fa-info-circle').on('click', function() {
		$('.info-popup').hostcmsPopup({responsiveWidthBreakpoint: 576});
	});

	$('.header-icons .little-cart-icon > i').on('click', function(e) {
		$('.little-cart-wrapper').hostcmsPopup({animateResizePercent: window.innerWidth < 992 ? '90%' : '40%', withoutScroll: true});
	});

	$('.header-icons .user-icon > i').on('click', function() {
		$('.user-account-wrapper').hostcmsPopup({parentObject: this, responsiveWidthBreakpoint: 992, animateResize: 'height'});
		// e.stopImmediatePropagation();
	});

	$('.header-icons .hamburger-icon > i.top').on('click', function() {
		$('#navbar-nav-lists').removeClass('d-none d-lg-block').hostcmsPopup({responsiveWidthBreakpoint: 992});
	});

	$('.header-icons .hamburger-icon > i.hamburger-categories').on('click', function() {
		$('.header-categories #navbar-nav-lists').hostcmsPopup({responsiveWidthBreakpoint: 992});
		$('.header-categories').removeClass('d-none d-lg-block');
	});

	/*$(window).on('resize', function(){
		if ($(window).width() >= 992)
		{
			$('.header-categories #navbar-nav-lists').addClass('w-100');
		}
		else
		{
			$('.header-categories #navbar-nav-lists').removeClass('w-100');
		}
	});*/

	$('.categories-navbar .popup-close').on('click', function(e){
		$('.header-categories').addClass('d-none d-lg-block');
	});

	$(document).keydown(function(e){
		var code = e.keyCode || e.which;

		if (code == 27)
		{
			$('.header-categories').addClass('d-none d-lg-block');
		}
	});

	// Add title for spinner buttons
	$.widget('ui.spinner', $.ui.spinner, {
		_buttonHtml: function() {
		  return '<a title="Увеличить количество" tabindex="-1" aria-hidden="true" class="ui-button ui-widget ui-spinner-button ui-spinner-up ui-corner-tr ui-button-icon-only" role="button"><span class="ui-button-icon ui-icon ui-icon-triangle-1-n"></span><span class="ui-button-icon-space"> </span></a><a title="Уменьшить количество" tabindex="-1" aria-hidden="true" class="ui-button ui-widget ui-spinner-button ui-spinner-down ui-corner-br ui-button-icon-only" role="button"><span class="ui-button-icon ui-icon ui-icon-triangle-1-s"></span><span class="ui-button-icon-space"> </span></a>';
		}
	});

	// Количество в корзине
	$('.spinner').spinner({ min:1 });

	var timeout = null;

	// Пересчет в корзине
	$('.spinner').on('spin', function(event, ui) {
		if(timeout) {
			clearTimeout(timeout);
			timeout = null;
		}

		timeout = setTimeout(function() {
			timeout = null;

			$.ajax({
				url: '/shop/cart/',
				data: { 'ajax': 1, 'recount': 1 },
				dataType: 'json',
				type: 'POST',
				success: function(answer){
					if (answer.status == 'success')
					{
						$('.cart-form')
							.append('<input type="hidden" name="recount" value="1"/>')
							.submit();
					}
				}
			});
		}, 1000);
	});

	// Добавление/удаление отложенных товаров
	$('a.cart-postpone').on('click', function(){
		$.ajax({
			url: '/shop/cart/',
			data: { 'change_postpone': 1, 'shop_item_id': $(this).data('id'), 'postpone': $(this).data('postpone') },
			dataType: 'json',
			type: 'POST',
			success: function(answer){
				if (answer.status == 'success')
				{
					window.location = window.location.href;
				}
			}
		});
	});

	// Выход из личного кабинета
	$('a.exit-account').on('click', function(){
		$.ajax({
			url: '/users/',
			data: { 'exit': 1 },
			dataType: 'json',
			type: 'POST',
			success: function(answer){
				if (answer.status == 'success')
				{
					window.location = window.location.href;
				}
			}
		});
	});

	// Clicked parent
	$('.navbar .dropdown > a').click(function() {
		if (!$(this).hasClass('parent-clicked')) {
			$('.navbar .dropdown > a').removeClass('parent-clicked');
			$(this).addClass('parent-clicked');
		} else {
			location.href = this.href;
		}
	});

	setTimeout(function() {
		$('.shop-content .filter').removeClass('filter-hidden');
	}, 1000);
});

function shake(div){
    var interval = 100, distance = 5, times = 4;

    $(div).css('position', 'relative');

    for(var iter = 0; iter < (times + 1); iter++){
		$(div).animate({
			left:((iter % 2 == 0 ? distance : distance * -1))
		},interval);
	}

	$(div).animate({ left: 0 }, interval);
}

// Личные сообщения
$.fn.messageTopicsHostCMS = function(settings) {
	// Настройки
	settings = $.extend({
		timeout:					10000, // Таймаут обновлений
		data:						'.messages-data', // блок с данными переписки для обновления
		url:						'#url', // значение URL
		page:						'#page', // значение total
		message_field:				'textarea', // поле ввода сообщения
		page_link:					'.page_link', // ссылки на страницы
		keyToSend:					13 // Отправка сообщения
	}, settings);

	var Obj = $.extend({
			_url:			this.find(settings.url).text(),
			_page:			parseInt(this.find(settings.page).text()) + 1,
			oData:			this.find(settings.data),
			oForm:			this.find('form'),
			oField:		this.find(settings.message_field),	// поле ввода сообщения
			oPage:			this.find(settings.page_link),	// ссылки на страницы
			oTemp:			{} // блок временных данных
		}, this);

	function _start() {
		if (Obj.length == 1) {
			// обновление данных по таймауту
			setInterval(_ajaxLoad, settings.timeout);

			Obj.oField.keydown(function(e) {
				if (e.ctrlKey && e.keyCode == settings.keyToSend) Obj.oForm.submit();
			});

			// отправка формы по Ctrl+Enter
			Obj.oField.keydown(function(e) {
				if (e.ctrlKey && e.keyCode == settings.keyToSend) Obj.oForm.submit();
			});

			// отправка сообщения из формы
			Obj.oForm.submit(function() {
				if (Obj.oField.val().trim().length) {
					_ajaxLoad({form: Obj.oForm.serialize()});
					Obj.oForm.find(':input:not([type=submit],[type=button])').each(function(){$(this).val('')});
				}
				return false;
			});
		}
		return false;
	}

	// Ajax запрос
	function _ajaxLoad(data) {
		if (!data) data = {};
		form = data.form ? '&' + data.form: '';

		return $.ajax({
			url: Obj._url + 'page-' + Obj._page + '/',
			type: 'POST',
			data: 'ajaxLoad=1' + form,
			dataType: 'json',
			success: function (ajaxData) {
				//Obj.oData.html($(ajaxData.content).find(settings.data).html());
				Obj.oData.html(ajaxData.content);
			},
			error: function (){return false}
		});
	}
	return this.ready(_start);
};

$.fn.messagesHostCMS = function(settings) {
//jQuery.extend({
	//messagesHostCMS: function(settings){
		// Настройки
		settings = $.extend({
			chat_height :					465, // Высота чата переписки
			timeout :							10000, // Таймаут обновлений
			load_messages :				'#load_messages', // кнопка подгрузки старых сообщений
			chat_window :					'#chat_window', // окно чата переписки
			messages :						'#messages', // список сообщений чата
			prefix_message_id :		'msg_', // префикс идентификатора сообщения в DOM
			message_field :				'textarea', // поле ввода сообщения
			url :									'#url', // значение URL
			limit :								'#limit', // значение limit
			total :								'#total', // значение total
			topic_id :						'#topic_id', // значение message_topic id
			keyToSend :						13 // Отправка сообщения
		}, settings);

	var Obj = $.extend({
			_activity :		1,
			_autoscroll :	1,
			_url :				this.find(settings.url).text(),
			_limit :			this.find(settings.limit).text(),
			_total :			this.find(settings.total).text(),
			_topic_id :		this.find(settings.topic_id).text(),
			_count_msg :	0, // количество сообщений в чате
			oLoad :				this.find(settings.load_messages), // кнопка подгрузки старых сообщений
			oWindow :			this.find(settings.chat_window), // окно чата переписки
			oMessages :		this.find(settings.messages), // список сообщений чата
			oField :			this.find(settings.message_field),	// поле ввода сообщения
			oForm :				this.find('form'),
			oTemp :				{} // блок временных данных
		}, this);

	function _start() {
		if (Obj.length == 1) {
			_recountChat();

			// обновление данных по таймауту
			setInterval(_ajaxLoad, settings.timeout);

			// проверка активности пользователя
			$("body").mousemove(function(){
				Obj._activity = Obj._autoscroll == 1 ? 1 : 0;
			});

			// отправка формы по Ctrl+Enter
			Obj.oField.keydown(function(e) {
				if (e.ctrlKey && e.keyCode == settings.keyToSend) Obj.oForm.submit();
			});

			Obj.oWindow.scroll(function(){
				Obj._autoscroll = Obj.oMessages.height() == Obj.oWindow.scrollTop() + settings.chat_height ? 1 : 0;
			});

			// отправка сообщения из формы
			Obj.oForm.submit(function() {
				if (Obj.oField.val().trim().length) {
					Obj._autoscroll = 1;
					Obj._activity = 1;
					_ajaxLoad({form : Obj.oForm.serialize()});
					Obj.oField.val('');
				}
				return false;
			});

			Obj.oLoad.click(function(){
				_ajaxLoad({
					preload : true,
					page : 'page-' + parseInt(Obj._count_msg / Obj._limit + 1)
				})
			});
		}
		return false;
	}

	// Ajax запрос
	function _ajaxLoad(data) {
		if (!data) data = {};
		page = data.page ? data.page + '/' : '';
		form = data.form ? '&' + data.form : '';
		return $.ajax({
			url : Obj._url + Obj._topic_id + '/' + page,
			type : 'POST',
			data : 'ajaxLoad=1&activity=' + Obj._activity + form,
			dataType : 'json',
			success :	function (ajaxData) {
				Obj.oTemp = $(ajaxData.content);

				if (!data.preload && Obj._count_msg > Obj._limit)
				{
					Obj.oTemp.find(settings.messages + ' > :first[id^='+settings.prefix_message_id+']').remove();
				}

				// замена сообщений чата
				Obj.oTemp.find(settings.messages + ' > [id^='+settings.prefix_message_id+']').each(function(){
					oMsg = Obj.oMessages.find('[id="' + $(this).attr('id') +'"]');
					if (oMsg.length == 1) oMsg.replaceWith($(this));
				});

				newMessages = Obj.oTemp.find(settings.messages + ' > [id^='+settings.prefix_message_id+']');
				if (newMessages.length) {
					if (data.preload){
						Obj.oMessages.prepend(newMessages);
						Obj._autoscroll = 0;
						Obj.oWindow.scrollTop(0);
					}
					else {
						Obj.oMessages.append(newMessages);
					}
					_recountChat();
				}
			},
			error : function (){return false}
		});
	}

	function _recountChat() {
		if (Obj.oWindow.height() > settings.chat_height) Obj.oWindow.height(settings.chat_height + 'px');
		if (Obj._autoscroll == 1) Obj.oWindow.scrollTop(Obj.oMessages.height() - settings.chat_height);
		if (Obj.oTemp.length) Obj._total = Obj.oTemp.find(settings.total).text();
		Obj._count_msg = Obj.oMessages.find('> *[id^='+settings.prefix_message_id+']').length;
		if (Obj._count_msg >= Obj._total && Obj.oLoad.is(':visible')) Obj.oLoad.toggle();
		Obj._activity = 0;
	}

	return this.ready(_start);
};

// OwlCarousel .andSelf() was deprecated in jQuery 1.8 and removed in jQuery 3.0. .addBack()
$.fn.andSelf = function() {
  return this.addBack.apply(this, arguments);
}

// ----------- nav animation -----------
var navScroll = {
  init: function(){
    $(window).on('scroll', function(e){
		navScroll.navDrop();
    });
  },
  navDrop: function(){
		var $scrollTop = $(window).scrollTop(),
			$object = $('.header-bottom.scroll'),
			$headerBottomHeight = $object.outerHeight(),
			$headerHeight = $object.outerHeight();

		if ($scrollTop > $headerHeight){
			$object.addClass('scrolled');
			$('header').css('padding-top', $headerBottomHeight);
		}
		else {
			$object.removeClass('scrolled');
			$('header').css('padding-top', 0);
		}
	}
}

function applyFilter()
{
	var $form = $('form.filter-form'),
		path = $form.attr('action'),
		producerOption = $form.find('select[name = producer_id] option:selected'),
		priceFrom = parseInt($form.find('input[name = price_from]').val()),
		priceTo = parseInt($form.find('input[name = price_to]').val()),
		priceFromOriginal = $form.find('input[name = price_from_original]').val(),
		priceToOriginal = $form.find('input[name = price_to_original]').val(),
		sortingOption = $form.find('select[name = sorting] option:selected');

	if (parseInt(producerOption.attr('value')))
	{
		path += producerOption.data('producer') + '/';
	}

	if (typeof priceFrom !== 'undefined' && !isNaN(priceFrom)
		&& typeof priceTo !== 'undefined' && !isNaN(priceTo)
		&& (priceFrom !== priceFromOriginal || priceTo !== priceToOriginal)
	)
	{
		path += 'price-' + priceFrom + '-' + priceTo + '/';
	}

	var inputs = $form.find('*[data-property]:not(div)'),
		tag_name = null;

	$.each(inputs, function (index, value) {
		var type = this.type || this.tagName.toLowerCase(),
			jObject = $(this),
			value = null,
			setValue = false;

		if (typeof jObject.attr('name') !== 'undefined' && jObject.attr('name').indexOf('_to') !== -1)
		{
			return;
		}

		switch (type)
		{
			case 'checkbox':
			case 'radio':
				value = +jObject.is(':checked');
				setValue = type != 'checkbox' ? true : jObject.attr('name').indexOf('[]') !== -1;
			break;
			case 'option':
				value = +jObject.is(':selected');
				setValue = true;
			break;
			case 'text':
			case 'hidden':
				value = jObject.val();
				setValue = true;
			break;
		}

		if (value && jObject.data('property') !== tag_name)
		{
			tag_name = jObject.data('property');

			if (typeof jObject.attr('name') !== 'undefined' && jObject.attr('name').indexOf('_from') !== -1)
			{
				path += '';
			}
			else
			{
				path += tag_name + '/';
			}
		}

		if (setValue && value)
		{
			if (typeof jObject.attr('name') !== 'undefined' && jObject.attr('name').indexOf('_from') !== -1)
			{
				path += encodeURIComponent(tag_name + '-' + jObject.val() + '-' + jObject.next().val()) + '/';
			}
			else
			{
				path += encodeURIComponent(
					typeof jObject.data('value') !== 'undefined'
						? jObject.data('value')
						: value
				) + '/';
			}
		}
	});

	path += $form.data('tag');

	if (parseInt(sortingOption.attr('value')))
	{
		path += '?sorting=' + sortingOption.val();
	}

	// console.log(path);

	window.location.href = path;
}

class fastFilter {
	constructor(form) {
		this._timerId = false;
		this._form = form;

		this.filterChanged = function (obj) {
			if (this._timerId) {
				clearTimeout(this._timerId);
			}

			var $this = this;

			this._timerId = setTimeout(function () {
				$this._loadJson(obj);
			}, 1500);

			return this;
		};

		this._loadJson = function (obj) {
			var data = this._serializeObject();

			$.loadingScreen('show');

			$.ajax({
				url: './',
				type: "POST",
				data: data,
				dataType: 'json',
				success: function (result) {
					$.loadingScreen('hide');

					if (typeof result.count !== 'undefined') {
						var jParent = obj.parents('.property-list').length
							? obj.parents('.property-list')
							: obj.parent();

						$('.popup-filter').remove();

						jParent.css('position', 'relative');
						jParent.append('<div class="popup-filter"><div>Найдено: ' + result.count + '</div><br/><div><button class="btn btn-sm" onclick="applyFilter(); return false;">Применить</button></div></div>');

						setTimeout(function () {
							$('.popup-filter').remove();
						}, 5000);
					}
				}
			});
		};

		this._serializeObject = function () {
			var o = { fast_filter: 1 };
			var a = this._form.serializeArray();
			$.each(a, function () {
				if (o[this.name] !== undefined) {
					if (!o[this.name].push) {
						o[this.name] = [o[this.name]];
					}
					o[this.name].push(this.value || '');
				} else {
					o[this.name] = this.value || '';
				}
			});

			return o;
		};
	}
}