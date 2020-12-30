# @summary This module manages the citrix wembroker
#
# @example Basic Usage
# 
# @param admin_group
#  Citrix WEM default administrators group. Should be a valid Active Directory group.
# @param citrix_licenseserver
#  Citrix License Server name. A valid Citrix license file is required to run Citrix WEM services.
# @param db_files_folder
#  Path to the data and log files location on the SQL Server.
# @param db_name
#  Citrix WEM database name
# @param db_server
#  Microsoft SQL Server hostname hosting the WEM database.
# @param domain_admin_username
#  Privileged account for installing the software and creating accounts (spn creation, computer registration, local admin privileges needed)
# @param domain_admin_password
#  Password of the privileged account. Should be encrypted with hiera-eyaml.
# @param mgmtconsole_installer_path
#  Path of the WEM management console installer EXE file. Can be a local or an UNC path
# @param services_installer_path
#  Path of the WEM infrastructure services installer EXE file. Can be a local or an UNC path.
# @param sqlserver_module_source
#  Source of SQLServer Powershell module v21.0.17199
# @param vuemuser_sql_password
#  Specific password for the Citrix WEM vuemUser SQL user account.
# @param wem_svc_password
#  Password of the service account of WEM infrastructure service. Should be encrypted with hiera-eyaml.
# @param wem_svc_username
#  Windows service account of WEM infrastructure service.
# @param services_productid
#  WEM infrastructure service EXE installer ProductID
# @param lb_wem_fqdn
#  If Citrix WEM is deployed behind a load-balancer, FQDN associated to the WEM virtual-ip configured in the load balancer.
# @param lb_wem
#  Configure WEM for multiple brokers behind load balancer
# @param mgmtconsole_productid
#  WEM management console EXE installer ProductID
# @param sql_alwayson
#  Activate Citrix WEM database AlwaysOn availability group membership
# @param sql_availabilitygroup
#  Name of the SQL Server Availability group on which to add the Citrix WEM database.
# @param sql_dbbackup_path
#  UNC path of a writable network folder to backup databases during AlwaysOn configuration. Needs to be writable from the MSSQL nodes.
# @param sqlserver_module_sourcepath
#  Path of the SQLServer Powershell module v21.0.17199 ZIP file
#
class wembroker (
  String $admin_group,
  String $citrix_licenseserver,
  String $db_files_folder,
  String $db_name,
  String $db_server,
  String $domain_admin_password,
  String $domain_admin_username,
  String $mgmtconsole_installer_path,
  String $services_installer_path,
  Enum['internet', 'offline'] $sqlserver_module_source,
  String $vuemuser_sql_password,
  String $wem_svc_password,
  String $wem_svc_username,
  Optional[String] $services_productid,
  Optional[String] $lb_wem_fqdn,
  Optional[Boolean] $lb_wem,
  Optional[String] $mgmtconsole_productid,
  Optional[Boolean] $sql_alwayson,
  Optional[String] $sql_availabilitygroup,
  Optional[String] $sql_dbbackup_path,
  Optional[String] $sqlserver_module_sourcepath,
  String $netbios_name = split($facts['domain'],'\.')[0],
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
