# On new installations, agent is disabled by default...
puppet agent --enable

# Explicitly run the agent in test (i.e. extended output) mode
puppet agent --test

# With --test enabled, puppet will return exit code 2 when there were changes. Vagrant expects exit code 0.
puppetExitCode=$?
if [[ $? -eq 2 ]]; then
  echo "Puppet agent executed with changes (exit code 2)"
fi