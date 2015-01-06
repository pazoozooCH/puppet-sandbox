# Contains docker configuration for client1
class inftec::docker::client1 {
	# Install Docker
	include 'docker'
	
	# Load JIRA Image
	docker::image { 'cptactionhank/atlassian-jira':
		image_tag => '6.3.12',
	}
	
	# Run JIRA Image in a container
	docker::run { 'jira':
		image => 'cptactionhank/atlassian-jira',
		# Expose container port 8080 to client1 port 8080
		ports => '8080:8080',
		# expose => '8080',
/*
  command         => '/bin/sh -c "while true; do echo hello world; sleep 1; done"',
  ports           => ['8080', '4555'],
  expose          => ['8080', '4777'],
  links           => ['mysql:db'],
  use_name        => true,
  volumes         => ['/var/lib/couchdb', '/var/log'],
  volumes_from    => '6446ea52fbc9',
  memory_limit    => 10m, # (format: <number><unit>, where unit = b, k, m or g)
  cpuset          => ['0', '3'],
  username        => 'example',
  hostname        => 'example.com',
  env             => ['FOO=BAR', 'FOO2=BAR2'],
  dns             => ['8.8.8.8', '8.8.4.4'],
  restart_service => true,
  privileged      => false,
  pull_on_start   => false,
  depends         => [ 'container_a', 'postgres' ],
  */
	}
}