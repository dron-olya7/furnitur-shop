<?php
/**
 * HostCMS bootstrap file.
 *
 * @package HostCMS
 * @version 7.x
 * @author Hostmake LLC
 * @copyright © 2005-2023 ООО "Хостмэйк" (Hostmake LLC), http://www.hostcms.ru
 */
define('CMS_FOLDER', dirname(__FILE__) . DIRECTORY_SEPARATOR);
define('HOSTCMS', TRUE);

// ini_set("memory_limit", "128M");
// ini_set("max_execution_time", "120");

// Константа запрещает выполнение ini_set, по умолчанию false - разрешено
define('DENY_INI_SET', FALSE);

// Запрещаем установку локали, указанной в параметрах сайта
// define('ALLOW_SET_LOCALE', FALSE);
setlocale(LC_NUMERIC, "POSIX");

if (!defined('DENY_INI_SET') || !DENY_INI_SET)
{
	ini_set('display_errors', 1);
}

require_once(CMS_FOLDER . 'modules/core/core.php');

Core::init();

date_default_timezone_set(Core::$mainConfig['timezone']);

if (Core_Auth::logged())
{
	// Observers
	Core_Event::attach('Xsl_Processor.onBeforeProcess', array('Xsl_Processor_Observer', 'onBeforeProcess'));
	Core_Event::attach('Xsl_Processor.onAfterProcess', array('Xsl_Processor_Observer', 'onAfterProcess'));
	Core_Event::attach('Core_Cache.onBeforeGet', array('Core_Cache_Observer', 'onBeforeGet'));
	Core_Event::attach('Core_Cache.onAfterGet', array('Core_Cache_Observer', 'onAfterGet'));
	Core_Event::attach('Core_Cache.onBeforeSet', array('Core_Cache_Observer', 'onBeforeSet'));
	Core_Event::attach('Core_Cache.onAfterSet', array('Core_Cache_Observer', 'onAfterSet'));
}

// Core_Database::instance()->query("SET SESSION sql_mode = ''");
// Core_Database::instance()->query('SET SESSION wait_timeout = 120');

//Shop_Controller::instance()->floatFormat("%.0f");
//Shop_Controller::instance()->decimalDigits(0);

// Windows locale
//setlocale(LC_ALL, array ('ru_RU.utf-8', 'rus_RUS.utf8'));
