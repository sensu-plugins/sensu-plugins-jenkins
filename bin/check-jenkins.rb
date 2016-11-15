#! /usr/bin/env ruby
#
#   check-jenkins
#
# DESCRIPTION:
#   This plugin checks that the Jenkins Metrics ping url returns pong with status 200 OK
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

#
# Jenkins Metrics Pin Pong Check
#
class JenkinsMetricsPingPongChecker < Sensu::Plugin::Check::CLI
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
         description: 'Jenkins Metrics Ping URI',
         short: '-u URI',
         long: '--uri URI',
         default: '/metrics/currentUser/ping'

  option :https,
         short: '-h',
         long: '--https',
         boolean: true,
         description: 'Enabling https connections',
         default: false

  def run
    https ||= config[:https] ? 'https' : 'http'
    testurl = "#{https}://#{config[:server]}:#{config[:port]}#{config[:uri]}"
    r = RestClient::Resource.new(testurl, timeout: 5).get
    if r.code == 200 && r.body.include?('pong')
      ok 'Jenkins Service is up'
    else
      critical 'Jenkins Service is not responding'
    end
  rescue Errno::ECONNREFUSED
    critical 'Jenkins Service is not responding'
  rescue RestClient::RequestTimeout
    critical 'Jenkins Service Connection timed out'
  rescue
    critical "Couldn't get: '#{testurl}' is the server option set correctly and the Jenkins metrics plugin installed?"
  end
end
