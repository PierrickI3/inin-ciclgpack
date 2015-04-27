# == Class: ciclgpack
#
# Installs a CIC language pack
#
# === Parameters
#
# [locale]
#   Country and language of the language packs to install
#   e.g. "fr-FR" for French (France) or "en-UK" for English (United Kingdom)
#   Supported locales are here: https://my.inin.com/products/cic/Pages/Localization.aspx
#
# [cic_version]
#   Current version of CIC (i.e. "2015_R2")
#
# === Examples
#
#  class { 'ciclgpack':
#    ensure      => installed,
#    locales     => [ 'fr-FR', 'en-UK', 'nl-NL' ],
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
  $ensure,
  $locales,
  $cic_version,
)
{
  $mountdriveletter = 'e:'
  $daascache        = 'C:\\daas-cache'
  $ciciso           = "CIC_${cic_version}.iso"
  $languagepackmsi  = 'LanguagePack'

  if ($::operatingsystem != 'Windows')
  {
    err('This module works on Windows only!')
    fail('Unsupported OS')
  }

  case $locale
  {
    'fr-FR':
    {
      $currentlanguagepackmsi = "${languagepackmsi}_fr_${cic_version}.msi"
    }
    default:
    {
      fail("Language ${locale} not supported")
    }
  }

case $ensure
  {
    installed:
    {
      # Mount CIC ISO
      debug('Mounting CIC ISO')
      exec {'mount-cic-iso':
        command => "cmd.exe /c imdisk -a -f \"${daascache}\\${ciciso}\" -m ${mountdriveletter}",
        path    => $::path,
        cwd     => $::system32,
        creates => "${mountdriveletter}/Installs/Install.exe",
        timeout => 30,
        before  => Exec['unmount-cic-iso'],
      }

      debug("Installing Language Pack for ${locale}")
      package {"language-pack-install":
        ensure          => installed,
        source          => "${daascache}\\${currentlanguagepackmsi}",
        install_options => [  '/qn',
                              '/norestart',
                              {'STARTEDBYEXEORIUPDATE' => '1'},
                              {'REBOOT' => 'ReallySuppress'},
                          ],
        require         => Exec['mount-cic-iso'],
      }

      debug('Adding media server analysis language model instructions on desktop')
      file {'C:/Users/Vagrant/Desktop/MediaServer Language Analysis Instructions.txt':
        ensure  => present,
        content => 'To configure Media Server speech for your language, create or update the "Call Analysis Language" server parameter to one of the values listed on page 67 of the following document: https://my.inin.com/products/cic/Documentation/mergedProjects/wh_tr/bin/media_server_tr.pdf',
        after   => Package["language-pack-install-${locale}"],
        require => Exec['mount-cic-iso'],
      }

      debug("Setting Windows Culture to ${locale}")
      exec {"set-windows-culture":
        command  => "Set-Culture ${locale}",
        provider => powershell,
        path     => $::path,
        cwd      => $::system32,
        timeout  => 30,
        require  => Package["language-pack-install"],
      }

      # Create a localized dial plan? https://my.inin.com/products/cic/Pages/Localization.aspx

      # Unmount CIC ISO
      debug('Unmounting CIC ISO')
      exec {'unmount-cic-iso':
        command => "cmd.exe /c imdisk -d -m ${mountdriveletter}",
        path    => $::path,
        cwd     => $::system32,
        timeout => 30,
        require => Exec['set-windows-culture'],
      }
    }
    default:
    {
      debug("Unknown command ${ensure}")
    }
  }
}
