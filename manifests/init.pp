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
  $infrastructureServicesSourcePath,
  $infrastructureServicesProductId = '40BF3158-89BA-44A4-96B0-6D806FFD5AA3',
  $managementConsoleSourcePath,
  $managementConsoleProductId = '0FC446DF-9BE8-4808-A838-208C2D80A2EC',
  $wem_svc_username,
  $wem_svc_password,
  $databaseServer,
  $databaseName,
  $citrixLicenseServer,
  $loadbalandedWem = false,
  $loadbalancedWemFqdn = '',
)

{
  contain wembroker::serviceaccounts
  contain wembroker::install
  contain wembroker::config

  Class['::wembroker::serviceaccounts'] ->
  Class['::wembroker::install'] ->
  Class['::wembroker::config']
}
