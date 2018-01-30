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
  $svc_username='USER01',
  $svc_password='PASSWORD01',
  $wem_service_username,
  $wem_service_password,
  $databaseserver = 'SQL01',
  $citrixLicenseServer = 'srv-lic01',
  $domainNetbiosName='TESTLAB'
)

{
  contain wembroker::install
  contain wembroker::config

  Class['::wembroker::install'] ->
  Class['::wembroker::config']
}
