# == Class: ciclgpack
#
# Installs a CIC language pack
#
# === Parameters
#
# [locales]
#   List of locales (country and language) of the language packs to install
#   e.g. "fr_FR" for French (France) or "en_UK" for English (United Kingdom)
#   Supported locales are here: https://my.inin.com/products/cic/Pages/Localization.aspx
#
# [cic_version]
#   Current version of CIC (i.e. "2015_R2")
#
# === Examples
#
#  class { 'ciclgpack':
#    ensure      => installed,
#    locale      => [ 'fr_FR', 'en_UK', 'nl_NL' ],
#    cic_version => '2015_R2',
#  }
#
# === Authors
#
# Pierrick Lozach <pierrick.lozach@inin.com>
#
# === Copyright
#
# Copyright 2015 Interactive Intelligence, Inc.
#
class ciclgpack (
  $locales,
)
{
  $daascache = 'C:\\daas-cache'

  if ($operatingsystem != 'Windows')
  {
    err('This module works on Windows only!')
    fail('Unsupported OS')
  }

case $ensure
  {
  	installed:
  	{
  	  each ($locales) |$locale|
  	  {
        debug("Installing Language Pack for ${locale}")
        $languagepackmsi = "LanguagePack_${locale}_${cic_version}.msi"
        exec {"language-pack-install-${locale}":
          command => "msiexec /i ${languagepackmsi} STARTEDBYEXEORIUPDATE=1 REBOOT=ReallySuppress /l*v ${languagepackmsi}.log /qn /norestart",
        }

        debug("Creating/updating media server analysis language model server parameter")

        debug("Setting Windows Culture to ${locale}")
        exec {"set-windows-culture-${locale}":
          command  => "Set-Culture ${locale}",
          provider => powershell,
          timeout  => 30,
          require  => Exec["language-pack-install-${locale}"]
        }
  	  }
  	}
  }
}
