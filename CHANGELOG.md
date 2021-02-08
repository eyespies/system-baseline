# system-baseline Inspec Tests CHANGELOG

## 2.1.3

- Justin Spies - (fix) properly compare booleans for the NTPD tests

## 2.1.2

- Justin Spies - (fix) properly compare booleans for the Chronyd tests

## 2.1.1

- Justin Spies - (fix) exclude NTP / include Chrony for EL >= 8

## 2.1.0

- Justin Spies - (feature) lock to Gems compatible with Chef 15
- Justin Spies - (feature) support Chrony for NTP
- Justin Spies - (fix) use new "value" instead of "default"
- Justin Spies - (fix) only support on RHEL platforms less than 8 since ntpd is removed in RHEL8 and higher
- Justin Spies - (fix) incorrect namespace
- Justin Spies - (tidy) rubocop cleanup
- Justin Spies - (tidy) add YAML start marker
- Justin Spies - (doc) update copyright

## 2.0.3

- Justin Spies - (fix) cannot "chomp" a class

## 2.0.2

- Justin Spies - '(fix) remove insecure SSH protocols'

## 2.0.1

- Update sshd control to look for 'Macs' instead of 'MACs'

## 1.1.5

- Fix incorrect hostname test that always looked for _hostname._ instead of just _hostname_

## 1.1.4

- Fix additional issues in the host_naming control

## 1.1.3

- Fix syntax errors in the YUM repo tests
- Use newest Rubocop
- Address RuboCop items
- Add Overcommit

## 1.1.2

- Fix syntax errors in Papertrail tests

## 1.1.1

- Fix incorrect syntax when preventing the papertrail tests from running
- Update Papertrail test description

## 1.1.0

- Add tests for proper configuration of Papertrail remote syslog

## 1.0.1

- Allow overriding the default domain name for cases where a custom domain is not specified for the Chef attributes in
`.kitchen.yml`

## 1.0.0

- First release
