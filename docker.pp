$appuser    = 'vagrant'

group { 'docker':
  ensure => 'present',
}

user { $appuser:
  ensure           => 'present',
  groups           => ['wheel', 'docker'],
  home             => "/home/${appuser}",
  password         => '$6$eVECWbuT$6PZ6cqTwG11jrwpgB0g1Q5GyV3Y.UvEiXfT/KR3XP8RfHhHvJsp1.zU1H0ljuhFnw39r.HoSQiXm/RxcqCBQ7/',
  password_max_age => '99999',
  password_min_age => '0',
  shell            => '/bin/bash',
  require          => Group['docker'],
}

class { '::docker':
  use_upstream_package_source => false,
  log_driver                  => 'journald',
  package_name                => 'docker',
  service_overrides_template  => false,
}

::docker::image { 'genebean/d2s':
  docker_dir => '/vagrant',
}

::docker::run { 'slacker':
  image           => 'genebean/d2s',
  ports           => '3000:3000',
  env             => "SLACK_WEBHOOK=https://hooks.slack.com/services/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",
  restart_service => true,
  privileged      => false,
}
