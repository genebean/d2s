[![][microbadger-img]][microbadger]

# d2s

Builds a Docker container containing [dockerhub2slack][d2snpm] in Node 6.10 LTS.
The container put out by the author of the module is running on an out-dated
version of Node so I decided to build my own.

> Note that currently the [Dockerfile](Dockerfile) patches dockerhub2slack
> module using the code that was submitted in
> https://github.com/chamerling/dockerhub2slack/pull/2


## Deploying with Puppet

```puppet
# Before using the manifest below be sure to install the module:
# puppet module install garethr-docker --version 5.3.0

class { '::docker':
  use_upstream_package_source => false,
  log_driver                  => 'journald',
  package_name                => 'docker',
  service_overrides_template  => false,
}

::docker::image { 'genebean/d2s':
  image_tag => 'latest',
}

::docker::run { 'slacker':
  image           => 'genebean/d2s',
  ports           => '127.0.0.1:3000:3000',
  env             => 'SLACK_WEBHOOK=https://hooks.slack.com/services/your-hook-address-here',
  restart_service => true,
  privileged      => false,
}
```


## Fronting with Nginx

The deployment above makes the container only listen at http://127.0.0.1:3000.
I want all communications with my sites to be over https so I front all my sites
with Nginx and take advantage of [Let’s Encrypt][le] certs with Subject
Alternative Names. The location block below directs anything sent to `/d2s/` to
the container.

```
location /d2s/ {
    proxy_set_header   X-Real-IP         $remote_addr;
    proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
    proxy_set_header   Host              $http_host;
    proxy_set_header   X-Forwarded-Proto $scheme;
    proxy_pass         http://127.0.0.1:3000/;
}
```

[d2snpm]:https://www.npmjs.com/package/dockerhub2slack
[le]:https://letsencrypt.org/
[microbadger]:https://microbadger.com/images/genebean/d2s
[microbadger-img]:https://images.microbadger.com/badges/image/genebean/d2s.svg
