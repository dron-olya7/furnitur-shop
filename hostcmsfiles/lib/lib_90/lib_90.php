<div class="header-top-menu d-none d-md-block">
	<?php
	$Structure_Controller_Show = new Structure_Controller_Show(
		Core_Entity::factory('Site', CURRENT_SITE));

	$Structure_Controller_Show
		->xsl(
			Core_Entity::factory('Xsl')->getByName('ШапкаВерхМенюСайт2')
		)
		->menu(2)
		->show();
	?>
</div>