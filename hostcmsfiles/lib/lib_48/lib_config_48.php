<?php
$sGuid = Core_Array::getRequest('guid', '', 'trim');

$oMaillist_Fascicle_Log = Core_Entity::factory('Maillist_Fascicle_Log')->getByGuid($sGuid);

if (!is_null($oMaillist_Fascicle_Log))
{
	$Maillist_Unsubscribe_Reason_Controller_Show = new Maillist_Unsubscribe_Reason_Controller_Show($oMaillist_Fascicle_Log);

	Core_Page::instance()->object = $Maillist_Unsubscribe_Reason_Controller_Show;
}
else
{
	$oCore_Page = Core_Page::instance()->error404();
}