<?php

$oShop = Core_Entity::factory('Shop', Core_Array::get(Core_Page::instance()->libParams, 'shopId'));

$Shop_Controller_YandexVendor = new Shop_Controller_YandexVendor($oShop);
$Shop_Controller_YandexVendor->show();

exit();