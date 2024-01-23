<?php

defined('HOSTCMS') || exit('HostCMS: access denied.');

/**
 * Crm Module.
 *
 * @package HostCMS
 * @subpackage Crm
 * @version 7.x
 * @author Hostmake LLC
 * @copyright © 2005-2023 ООО "Хостмэйк" (Hostmake LLC), http://www.hostcms.ru
 */
class Crm_Module extends Core_Module_Abstract
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
	protected $_moduleName = 'crm';
}