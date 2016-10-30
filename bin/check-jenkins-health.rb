#! /usr/bin/env ruby
#
#   check-jenkins
#
# DESCRIPTION:
#   This plugin checks that the Jenkins Metrics healthcheck is healthy throughout
#   See the Jenkins Metric plugin: https://wiki.jenkins-ci.org/display/JENKINS/Metrics+Plugin
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: rest-client
#   gem: json
#
# USAGE:
#   #YELLOW
#
# NOTES:
#
# LICENSE:
#   Copyright 2015, Cornel Foltea cornel.foltea@gmail.com
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'
require 'rest-client'
require 'json'

#
# Jenkins Metrics Health Check
#
class JenkinsMetricsHealthChecker < Sensu::Plugin::Check::CLI
  option :server,
         description: 'Jenkins Host',
         short: '-s SERVER',
         long: '--server SERVER',
         default: 'localhost'

  option :port,
         description: 'Jenkins Port',
         short: 'p PORT',
         long: '--port PORT',
         default: '8080'

  option :uri,
         description: 'Jenkins Metrics Healthcheck URI',
         short: '-u URI',
         long: '--uri URI',
         default: '/metrics/currentUser/healthcheck'

  option :https,
         short: '-h',
         long: '--https',
         boolean: true,
         description: 'Enabling https connections',
         default: false

  option :timeout,
         short: '-t SECS',
         long: '--timeout SECS',
         description: 'Request timeout in seconds',
         proc: proc(&:to_i),
         default: 5

  def run
    https ||= config[:https] ? 'https' : 'http'
    r = RestClient::Resource.new("#{https}://#{config[:server]}:#{config[:port]}#{config[:uri]}", timeout: config[:timeout]).get
    if [200, 500].include? r.code
      healthchecks = JSON.parse(r)
      healthchecks.each do |healthcheck, healthcheck_hash_value|
        if healthcheck_hash_value['healthy'] != true
          critical "Jenkins health check '#{healthcheck}' reported unhealthy state. Message: #{healthcheck_hash_value['message']}"
        end
      end
      ok 'Jenkins Health Parameters are OK'
    else
      critical "Jenkins Service is replying with status code #{r.code}. Body: #{r.body}"
    end
  rescue Errno::ECONNREFUSED => e
    critical "Jenkins Service is not responding: #{e}"
  rescue RestClient::RequestTimeout => e
    critical "Jenkins Service Connection timed out after #{config[:timeout]} seconds: #{e}"
  end
end
