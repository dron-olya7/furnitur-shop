<?php

defined('HOSTCMS') || exit('HostCMS: access denied.');

/**
 * Shortcode.
 *
 * @package HostCMS
 * @subpackage Shortcode
 * @version 7.x
 * @author Hostmake LLC
 * @copyright © 2005-2023 ООО "Хостмэйк" (Hostmake LLC), http://www.hostcms.ru
 */
class Shortcode_Module extends Core_Module_Abstract
{
	/**
	 * Module version
	 * @var string
	 */
	public $version = '7.0';

	/**
	 * Module date
	 * @var date
	 */
	public $date = '2023-12-21';


	/**
	 * Module name
	 * @var string
	 */
	protected $_moduleName = 'shortcode';

	/**
	 * Get Module's Menu
	 * @return array
	 */
	public function getMenu()
	{
		$this->menu = array(
			array(
				'sorting' => 150,
				'block' => 3,
				'ico' => 'fa-regular fa-file-code',
				'name' => Core::_('Shortcode.menu'),
				'href' => "/admin/shortcode/index.php",
				'onclick' => "$.adminLoad({path: '/admin/shortcode/index.php'}); return false"
			)
		);

		return parent::getMenu();
	}
}