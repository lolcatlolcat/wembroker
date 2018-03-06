# Citrix Workspace Environment Management puppet module #

This modules install an enterprise production grade Citrix Workspace Environment Management 4.5 broker, including WEM database creation and administrator rights setup.

The following options are available for a production-grade installation :
- Fault tolerance : AlwaysOn database membership activation for Citrix WEM database

## Integration informations
The Citrix WEM database will be installed in the default MSSQLSERVER SQL Server instance. This module does not provide the capability to install the databases in another SQL intance.

The database failover mecanism integrated in this module is SQL Server AlwaysOn.

The module can be installed on a Core, Standard, Datacenter version of Windows 2012R2 or Windows 2016. **Core OS is now supported by Citrix Workspace Environment Management**.

## Usage
* **`[String]` setup_svc_username** _(Required)_: Privileged account used by Puppet for installing the software and creating the service account (spn creation, computer registration, local administrator privileges needed)
* **`[String]` setup_svc_password** _(Required)_: Password of the privileged account. Should be encrypted with hiera-eyaml.
* **`[String]` infrastructureservicessourcepath** _(Required)_: Path of the WEM infrastructure services installer EXE file. Can be a local or an UNC path.
* **`[String]` infrastructureservicesproductid** _(Optional)_: WEM infrastructure service EXE installer ProductID. The following line of code will list all products installed, including their name and IdentifyingNumber, which is the same as the ProductID `Get-WmiObject Win32_Product | Format-Table IdentifyingNumber, Name, Version`. Default is 40BF3158-89BA-44A4-96B0-6D806FFD5AA3 for WEM 4.5 installation.
* **`[String]` managementconsolesourcepath** _(Required)_: Path of the WEM management console installer EXE file. Can be a local or an UNC path.
* **`[String]` managementconsoleproductid** _(Optional)_: WEM management console EXE installer ProductID. The following line of code will list all products installed, including their name and IdentifyingNumber, which is the same as the ProductID `Get-WmiObject Win32_Product | Format-Table IdentifyingNumber, Name, Version`. Default is 0FC446DF-9BE8-4808-A838-208C2D80A2EC for WEM 4.5 installation.
* **`[String]` sqlservermodulesource** _(Optional)_: Default is 'internet'.
* **`[String]` sqlservermodulesourcepath** _(Optional)_:
* **`[String]` wem_svc_username** _(Required)_: Windows service account of WEM infrastructure service.
* **`[String]` wem_svc_password** _(Required)_: Password of the service account of WEM infrastructure service. Should be encrypted with hiera-eyaml.
* **`[String]` defaultadministratorsgroup** _(Required)_: Citrix WEM default administrators group. Should be a valid Active Directory group.
* **`[String]` vuemusersqlpassword** _(Required)_: Specific password for the Citrix WEM vuemUser SQL user account.
* **`[String]` databaseserver** _(Required)_: Microsoft SQL Server hostname hosting the WEM database.
* **`[String]` databasename** _(Required)_: Citrix WEM database name.
* **`[String]` databasefilesfolder** _(Required)_: Path to the data and log files location on the SQL Server. You must provide a valid filepath on the database server, otherwise the puppet run will fail.
* **`[Boolean]` sqlalwayson** _(Optional)_:  Activate Citrix WEM database AlwaysOn availability group membership ? Default is false. Needs to be true for a production grade environment.
* **`[String]` sqlavailabilitygroup** _(Optional if sqlalwayson = false)_: Name of the SQL Server Availability group on which to add the Citrix WEM database.
* **`[String]` sqldbbackuppath** _(Optional if sqlalwayson = false)_:  UNC path of a writable network folder to backup/restore databases during AlwaysOn availability group membership configuration. Needs to be writable from the SQL Server nodes. Has to be prefixed with \\\\ instead of the classical \\ if using Puppet >= 4.x or Puppet 3.x future parser.
* **`[String]` citrixlicenseserver** _(Required)_: Citrix License Server name. A valid Citrix license file is required to run Citrix Workspace Environment Management infrastructure services.
* **`[Boolean]` loadbalandedwem** _(Optional)_: Are multiple WEM broker deployed behind a loat balancer ? Default is false. Needs to be true for a production grade environment.
* **`[String]` loadbalancedwemfqdn** _(Optional if loadbalandedwem = false)_: If Citrix WEM is deployed behind a load-balancer, FQDN associated to the WEM virtual-ip configured in the load balancer.

## Installing a Citrix Workspace Environment Management broker

~~~puppet
node 'WEM' {
	class{'wembroker':
    setup_svc_username               =>'DOMAIN-TEST\Administrator',
		setup_svc_password               =>'P@ssw0rd',
		infrastructureservicessourcepath => '\\\\fileserver.local\sources\Workspace-Environment-Management-v-4-05-00\Citrix Workspace Environment Management Infrastructure Services Setup.exe',
		infrastructureServicesProductId  => '6F9F03C1-C707-4148-B45D-8DF3AE0033DC',
		managementconsolesourcepath      => '\\\\fileserver.domain-test.com\sources\Workspace-Environment-Management-v-4-05-00\Citrix Workspace Environment Management Console Setup.exe',
		managementconsoleproductid       => 'EB282EB6-C33F-4DB7-AEDA-B8F672347987',
		$sqlservermodulesource           => 'offline',
	  $sqlservermodulesourcepath       => '\\\\fileserver.domain-test.com\sources\sqlserver_powershell_21.0.17199.zip',
		wem_svc_username                 => 'svc-wem-puppet',
		wem_svc_password                 => 'P@ssw0rd',
		defaultadministratorsgroup       =>'DOMAIN-TEST\Domain Admins',
		vuemusersqlpassword              =>'P@ssw0rd',
		databaseserver                   =>'CLDB01LI.domain-test.com',
		databasename                     =>'CitrixWEMPuppet01',
		databasefilesfolder              =>'c:\\Program Files\\Microsoft SQL Server\\MSSQL13.MSSQLSERVER\\MSSQL\\Data',
		citrixlicenseserver              =>'SRV-LIC01.domain-test.com',
		loadbalandedwem                  => true,
		loadbalancedwemfqdn              => 'wem.domain-test.com',
	}
}
~~~
