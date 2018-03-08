# Class: wemrbroker
#
# This module manages wembroker
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class wembroker (
  $setup_svc_username,
  $setup_svc_password,
  $infrastructureservicessourcepath,
  $managementconsolesourcepath,
  $wem_svc_username,
  $wem_svc_password,
  $defaultadministratorsgroup,
  $vuemusersqlpassword,
  $databaseserver,
  $databasename,
  $databasefilesfolder,
  $citrixlicenseserver,
  $infrastructureservicesproductid = '40BF3158-89BA-44A4-96B0-6D806FFD5AA3',
  $managementconsoleproductid = '0FC446DF-9BE8-4808-A838-208C2D80A2EC',
  $sqlservermodulesource = 'internet',
  $sqlservermodulesourcepath = '',
  $sqlalwayson = false,
  $sqlavailabilitygroup = '',
  $sqldbbackuppath = '',
  $loadbalandedwem = false,
  $loadbalancedwemfqdn = ''
)

{
  contain wembroker::serviceaccounts
  contain wembroker::install
  contain wembroker::config
  contain wembroker::databasehighavailability

  Class['::wembroker::serviceaccounts']
  -> Class['::wembroker::install']
  -> Class['::wembroker::config']
  -> Class['::wembroker::databasehighavailability']
}
