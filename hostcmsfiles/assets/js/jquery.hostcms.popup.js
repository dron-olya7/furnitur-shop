
(function (factory) {
	if(typeof module === "object" && typeof module.exports === "object")
	{
		factory(require("jquery"), window, document);
	}
	else
	{
		factory(jQuery, window, document);
	}
}(function($, window, document, undefined) {
	var hostcmsPopups = [],
		getCurrent = function() {
			return hostcmsPopups.length ? hostcmsPopups[hostcmsPopups.length - 1] : null;
		};

	$.hostcmsPopup = function(el, options) {
		this.options = $.extend({}, $.hostcmsPopup.defaults, options);

		var _current = getCurrent();

		if (_current && _current.$elm.is(el))
		{
			$.hostcmsPopup.close();
			return;
		}

		if (this.options.closeExisting)
		{
			while ($.hostcmsPopup.isActive())
			{
				// Close any open popups.
				$.hostcmsPopup.close();
			}
		}
		hostcmsPopups.push(this);

		this.$elm = el;
		this.open();
	};

	$.hostcmsPopup.prototype = {
		constructor: $.hostcmsPopup,

		open: function() {

			this.$elm.on('click.popupclose', '.popup-close', $.hostcmsPopup.close);
			this.show();

			$(document).off('keydown.hostcmspopup').on('keydown.hostcmspopup', function(event) {
				var current = getCurrent();
				if (event.which === 27 && current.options.escapeClose) current.close();
			});

			var _options = this.options,
				_this = this;

			if (_options.responsiveWidthBreakpoint == 0 || window.innerWidth > _options.responsiveWidthBreakpoint)
			{
				$(document).on(_options.parentObject == undefined ? 'mouseup.hostcmspopup' : 'click.hostcmspopup', function(e) {
					var container = _this.$elm,
						current = getCurrent();

					if (!container.is(e.target) && container.has(e.target).length === 0 && current !== null
						&& (_options.parentObject == undefined || _options.parentObject != e.target))
					{
						current.close();
						return false;
					}
				});
			}

			if (_options.responsiveWidthBreakpoint == 0 || window.innerWidth < _options.responsiveWidthBreakpoint)
			{
				$('body').addClass('overflow-hidden');
			}
		},
		close: function() {
			hostcmsPopups.pop();
			this.hide();

			if (!$.hostcmsPopup.isActive())
			{
				$(document).off('keydown.hostcmspopup').off('mouseup.hostcmspopup').off('click.hostcmspopup');
			}

			var _options = this.options;

			if (_options.responsiveWidthBreakpoint == 0 || window.innerWidth < _options.responsiveWidthBreakpoint)
			{
				$('body').removeClass('overflow-hidden');
			}
		},
		show: function() {
			var _elm = this.$elm,
				_options = this.options;

			_elm.addClass('show');

			if (_options.withoutScroll)
			{
				sbw = $.hostcmsPopup.scrollbarWidth();

				$('body').css({
					'overflow': 'hidden',
					'width': 'calc(100% - ' + sbw + 'px)',
				});
			}

			// Показ на весь экран
			if (_options.responsiveWidthBreakpoint == 0 || window.innerWidth < _options.responsiveWidthBreakpoint)
			{
				setTimeout(function(){
					_elm.css(_options.animateResize, _options.animateResizePercent);
				}, 50);
				setTimeout(function(){
					_elm.find('.popup-close').removeClass('d-none');
				}, 500); // cause transition: 0.5s;
			}
			else
			{
				_elm.removeAttr('style');
			}
		},
		hide: function() {
			var _this = this;

			if (this.options.withoutScroll)
			{
				setTimeout(function() {
					$('body').css({
						'overflow': 'visible',
						'width': 'inherit',
					});
				}, 600);
			}

			if (this.options.responsiveWidthBreakpoint == 0 || window.innerWidth < this.options.responsiveWidthBreakpoint)
			{
				_this.$elm.css(this.options.animateResize, '0%');
				_this.$elm.find('.popup-close').addClass('d-none');

				setTimeout(function(){
					_this.$elm.removeClass('show');
				}, 500); // cause transition: 0.5s;
			}
			else
			{
				_this.$elm.removeClass('show');
			}
		}
	};

	$.hostcmsPopup.close = function(event) {
		if (!$.hostcmsPopup.isActive()) return;
		if (event) event.preventDefault();
		var current = getCurrent();
		current.close();
		return current.$elm;
	};

	// Returns if there currently is an active modal
	$.hostcmsPopup.isActive = function () {
		return hostcmsPopups.length > 0;
	};

	$.hostcmsPopup.scrollbarWidth = function () {
		var a = document.createElement("div");
		a.style.visibility = "hidden", a.style.width = "100px", a.style.msOverflowStyle = "scrollbar", document.body.appendChild(a);
		var b = a.offsetWidth;
		a.style.overflow = "scroll";
		var c = document.createElement("div");
		c.style.width = "100%", a.appendChild(c);
		var d = c.offsetWidth;
		return a.parentNode.removeChild(a), b - d
	}

	$.hostcmsPopup.getCurrent = getCurrent;

	$.hostcmsPopup.defaults = {
		responsiveWidthBreakpoint: 0,
		animateResize: 'width',
		animateResizePercent: '100%',
		closeExisting: true,
		escapeClose: true,
		withoutScroll: false
	};

	$.fn.hostcmsPopup = function(options){
		if (this.length === 1) {
			new $.hostcmsPopup(this, options);
		}
		return this;
	};
}));