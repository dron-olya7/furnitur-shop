<?php
	$name = Core_Array::get(Core_Page::instance()->widgetParams, 'name');
?>

<a class="header-logo" href="/">
	<div class="header-logo-wrapper">
		<span class="header-logo-name"><?php echo htmlspecialchars($name)?></span>
	</div>
</a>