class {'ciclgpack':
  ensure      => installed,
  locales     => ['fr'],
  cic_version => '2015_R2',
}