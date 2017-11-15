# Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed at [Our CHANGELOG Guidelines](https://github.com/sensu-plugins/community/blob/master/HOW_WE_CHANGELOG.md).
Which is based on [Keep A Changelog](http://keepachangelog.com/)

## [Unreleased]
### Added
- Add Ruby 2.4.1 testing
- metrics-jenkins.rb: Add --timeout parameter + report of the request duration

### Fixed
- lock dependency on `rb-readline` to remove deprecation warnings about fixnum (@majormoses)
- metrics-jenkins.rb: timeout not timing out properly

### Changed
- update changelog format location (@majormoses)

## [1.3.0] - 2017-05-04
### Added
- Additional parameter -w to report unstable jobs as a Sensu warning

## [1.2.0] - 2016-11-11
### Added
- Additional information given on errors in check-jenkins-health.rb
- Add configuration option for timeout in check-jenkins-health.rb

## [1.1.0] - 2016-10-06
### Added
- Added authentication options to check-jenkins-build-time.rb and check-jenkins-job-status.rb

## [1.0.0] - 2016-10-04
### Added
- Ruby 2.3.0 support

### Removed
- Ruby 1.9.3 support

### Changed
- check-jenkins-job-status.rb: if a job is in progress, use the result of the last completed build instead
- Update to rubocop 0.40 and cleanup
- Relax `sensu-plugin` dependency

## [0.1.0] - 2015-12-14
### Added
- Enhanced error messages in particular when the check configuration is wrong
- Update dependent jenkins-api version to 1.4.2
- Changed check-jenkins-job-status.rb and check-jenkins-build-time.rb to use server_url to allow
  passing credentials

## [0.0.5] - 2015-08-24
### Added
- PR #5
    - Fixed default uri for ping check to include leading forward-slash.

## [0.0.4] - 2015-07-14
### Changed
- updated sensu-plugin gem to 1.2.0

## [0.0.3] - 2015-06-4
### Added
- New check `bin/check-jenkins-build-time.rb` which alerts when Jenkins builds
  fail to succeed within a certain duration or configurable time window.

## [0.0.2] - 2015-06-03
### Added
- PR #1
    - Added ability to specify Jenkins port.  Will default to 8080

## 0.0.1 - 2015-05-04
### Added
- initial release

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-jenkins/compare/1.3.0...HEAD
[1.3.0]: https://github.com/sensu-plugins/sensu-plugins-jenkins/compare/1.2.0...1.3.0
[1.2.0]: https://github.com/sensu-plugins/sensu-plugins-jenkins/compare/1.1.0...1.2.0
[1.1.0]: https://github.com/sensu-plugins/sensu-plugins-jenkins/compare/1.0.0...1.1.0
[1.0.0]: https://github.com/sensu-plugins/sensu-plugins-jenkins/compare/0.1.0...1.0.0
[0.1.0]: https://github.com/sensu-plugins/sensu-plugins-jenkins/compare/0.0.5...0.1.0
[0.0.5]: https://github.com/sensu-plugins/sensu-plugins-jenkins/compare/0.0.4...0.0.5
[0.0.4]: https://github.com/sensu-plugins/sensu-plugins-jenkins/compare/0.0.3...0.0.4
[0.0.3]: https://github.com/sensu-plugins/sensu-plugins-jenkins/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/sensu-plugins/sensu-plugins-jenkins/compare/0.0.1...0.0.2
