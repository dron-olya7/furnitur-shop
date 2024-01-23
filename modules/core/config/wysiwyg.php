<?php

return array(
	'theme' => '"silver"',
	'plugins' => '"advlist autolink lists link image charmap preview anchor pagebreak searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking save table directionality emoticons template codesample importcss help"',
	'toolbar' => '"bold italic underline strikethrough cut copy paste removeformat undo redo blocks fontfamily fontsize | alignleft aligncenter alignright alignjustify bullist numlist link unlink image media table forecolor backcolor hr subscript superscript pagebreak codesample preview code insertShortcode"',
	'toolbar_mode' => '"sliding"',
	'image_advtab' => 'true',
	'image_title' => 'true',
	'menubar' => '"edit insert format view table help"',
	'toolbar_items_size' => '"small"',
	'insertdatetime_dateformat' => '"%d.%m.%Y"',
	'insertdatetime_formats' => '["%d.%m.%Y", "%H:%M:%S"]',
	'insertdatetime_timeformat' => '"%H:%M:%S"',
	'valid_elements' => '"*[*]"',
	'extended_valid_elements' => '"meta[*],i[*],noindex[*]"',
	'file_picker_callback' => 'function (callback, value, meta) { HostCMSFileManager.fileBrowserCallBack(callback, value, meta) }',
	'convert_urls' => 'false',
	'relative_urls' => 'false',
	'remove_script_host' => 'false',
	'forced_root_block' => '"div"',
	'entity_encoding' => '""',
	'verify_html' => 'false',
	'valid_children' => '"+body[style|meta],+footer[meta],+a[div|h1|h2|h3|h4|h5|h6|p|#text]"',
	'browser_spellcheck' => 'true',
	'importcss_append' => 'true',
	'schema' => '"html5"',
	// 'paste_data_images' => 'true',
	//'importcss_selector_filter' => '/\.prefix|\.otherprefix/',
	'importcss_selector_filter' => 'function(selector) { return selector.indexOf("body") === -1; }',
	'allow_unsafe_link_target' => 'false'
);