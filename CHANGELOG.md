# system-baseline Inspec Tests CHANGELOG

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
