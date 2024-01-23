<?php
	$phone = Core_Array::get(Core_Page::instance()->widgetParams, 'phone');
	$email = Core_Array::get(Core_Page::instance()->widgetParams, 'email');
?>
<div class="header-top-phone">
	<span class="font-weight-bold"><?php echo htmlspecialchars($phone)?> <i class="fa fa-info-circle ml-1"></i></span>
	<div class="info-popup">
		<a href="#" class="popup-close d-none">&times;</a>
		<div class="info-popup-content">
			<div class="row phone">
				<div class="col-6"><?php echo htmlspecialchars($phone)?></div>
				<div class="col-6"><a href="mailto:<?php echo htmlspecialchars($email)?>"><?php echo htmlspecialchars($email)?></a></div>
			</div>
			<div class="description">Мы принимаем звонки ежедневно с 9:00 до 19:00 по московскому времени.</div>
			<ul class="features">
				<li><a href="/delivery/">Доставка</a></li>
				<li><a href="/payment/">Оплата</a></li>
				<li><a href="/refund/">Возврат и обмен</a></li>
			</ul>
		</div>
		<div class="info-popup-triangle d-none d-sm-block"></div>
	</div>
</div>