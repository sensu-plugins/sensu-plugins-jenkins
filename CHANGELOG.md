#Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed at [Keep A Changelog](http://keepachangelog.com/)

## [Unreleased][unreleased]

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
