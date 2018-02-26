# Citrix Workspace Environment Management puppet module #

This modules install an enterprise production grade Citrix Workspace Environment Management 4.5 broker, including WEM database creation and administrator rights setup.

The following options are available for a production-grade installation :
- Fault tolerance : AlwaysOn database membership activation for Citrix WEM database

## Integration informations
The Citrix WEM database will be installed in the default MSSQLSERVER SQL Server instance. This module does not provide the capability to install the databases in another SQL intance.

The database failover mecanism integrated in this module is SQL Server AlwaysOn.

The module can be installed on a Core, Standard, Datacenter version of Windows 2012R2 or Windows 2016. **Core OS is now supported by Citrix Workspace Environment Management**.

## Usage

## Installing a Citrix Workspace Environment Management broker

~~~puppet
node 'WEM' {
	class{'wembroker':
	    setup_svc_username=>'DOMAIN-TEST\Administrator',
		setup_svc_password=>'P@ssw0rd',
		infrastructureServicesSourcePath => 'C:\Workspace-Environment-Management-v-4-05-00\Citrix Workspace Environment Management Infrastructure Services Setup.exe',
		infrastructureServicesProductId => '6F9F03C1-C707-4148-B45D-8DF3AE0033DC',
		managementConsoleSourcePath => 'C:\Workspace-Environment-Management-v-4-05-00\Citrix Workspace Environment Management Console Setup.exe',
		managementConsoleProductId => 'EB282EB6-C33F-4DB7-AEDA-B8F672347987',
		wem_svc_username => 'svc-wem-puppet',
		wem_svc_password => 'P@ssw0rd',
		defaultAdministratorsGroup=>'DOMAIN-TEST\Domain Admins',
		vuemUserSqlPassword=>'P@ssw0rd',
		databaseServer=>'CLDB01LI.domain-test.com',
		databaseName=>'CitrixWEMPuppet01',
		databaseFilesFolder=>'c:\\Program Files\\Microsoft SQL Server\\MSSQL13.MSSQLSERVER\\MSSQL\\Data',
		citrixLicenseServer=>'SRV-LIC01.domain-test.com',
		loadbalandedWem => true,
		loadbalancedWemFqdn => 'wem.domain-test.com',
	}
}
~~~
