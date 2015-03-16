class {'ciclgpack':
  ensure      => installed,
  locales     => ['fr-FR'],
  cic_version => '2015_R2',
}