#!/usr/bin/env ruby
#
#   check-jenkins-build-time
#
# DESCRIPTION:
#   Alert if the last successful build timestamp of a jenkins job is older than
#   a specified time duration OR not within a specific daily time window.
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Linux
#
# USAGE:
#   check-jenkins-build-time -u JENKINS_URL -j job_1_name=30min,job_2_name=1:30am-2:30am
#
#   -j parameter should be a comma-separated list of JOB_NAME=TIME_EXPRESSION
#   where TIME_EXPRESSION is either a relative time duration from now (30m, 1h) or
#   a daily time window (1am-2am, 1:01am-2:01am), without spaces.
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   jenkins_api_client
#   chronic_duration
#
#
# LICENSE:
#   Copyright Matt Greensmith  mgreensmith@cozy.co  matt@mattgreensmith.net
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'
require 'jenkins_api_client'
require 'chronic_duration'

class JenkinsBuildTime < Sensu::Plugin::Check::CLI
  ONE_DAY = 86_400

  option :url,
         description: 'URL to Jenkins API',
         short: '-u JENKINS_URL',
         long: '--url JENKINS_URL',
         required: true

  option :jobs,
         description: 'Jobs to check. Comma-separated list of JOB_NAME=TIME_EXPRESSION',
         short: '-j JOB_NAME=TIME_EXPRESSION,[JOB_NAME=TIME_EXPRESSION]',
         long: '--jobs JOB_NAME=TIME_EXPRESSION,[JOB_NAME=TIME_EXPRESSION]',
         required: true

  option :username,
         description: 'Username for Jenkins instance',
         short: '-U USERNAME',
         long: '--username USERNAME',
         required: false

  option :password,
         description: "Password for Jenkins instance. Either set ENV['JENKINS_PASS'] or provide it as an option",
         short: '-p PASSWORD',
         long: '--password PASSWORD',
         required: false,
         default: ENV['JENKINS_PASS']

  def run
    @now = Time.now
    critical_jobs = []

    jobs = parse_jobs_param

    jobs.each do |job_name, time_expression|
      begin
        last_build_time = build_time(job_name, last_successful_build_number(job_name))
      rescue
        critical "Error looking up Jenkins job: #{job_name}"
      end

      if time_expression_is_window?(time_expression)
        unless time_within_window?(last_build_time,
                                   parse_window_start(time_expression),
                                   parse_window_end(time_expression))
          critical_jobs << critical_message(job_name, last_build_time, time_expression)
        end
      else
        unless time_within_allowed_duration?(last_build_time,
                                             parse_duration_seconds(time_expression))
          critical_jobs << critical_message(job_name, last_build_time, time_expression)
        end
      end
    end

    critical "#{critical_jobs.length} failure(s): #{critical_jobs.join(', ')}" unless critical_jobs.empty?
    ok "#{jobs.keys.length} job(s) had successful builds within allowed times"
  end

  private

  def jenkins
    @jenkins ||= JenkinsApi::Client.new(server_url: config[:url], username: config[:username], password: config[:password], log_level: 3)
  end

  def last_successful_build_number(job_name)
    jenkins.job.list_details(job_name)['lastSuccessfulBuild']['number']
  end

  def build_time(job_name, build_number)
    # Jenkins expresses timestamps in epoch millis
    Time.at(jenkins.job.get_build_details(job_name, build_number)['timestamp'] / 1000)
  end

  def time_expression_is_window?(time_expression)
    time_expression.index('-') ? true : false
  end

  def parse_window_start(time_expression)
    Time.parse(time_expression.split('-')[0])
  end

  def parse_window_end(time_expression)
    Time.parse(time_expression.split('-')[1])
  end

  def time_within_window?(time, window_start, window_end)
    time_after_window_start_today = window_start < time
    time_in_window_today = time_after_window_start_today && window_end > time

    time_after_window_start_yesterday = (window_start - ONE_DAY) < time
    time_in_window_yesterday = time_after_window_start_yesterday && (window_end - ONE_DAY) > time

    time_ok = if @now < window_end && @now > window_start # we are in the window, so we will accept today or yesterday
                (time_in_window_today || time_in_window_yesterday)
              elsif @now < window_end
                # we are before the window, so we only accept yesterday
                time_in_window_yesterday
              else
                # we are after the window, so we only accept today
                time_in_window_today
              end
    time_ok
  end

  def parse_duration_seconds(time_expression)
    ChronicDuration.parse(time_expression)
  end

  def time_within_allowed_duration?(time, duration_seconds)
    time > (@now - duration_seconds)
  end

  def critical_message(job_name, last_build_time, time_expression)
    "#{job_name}: last built at #{last_build_time}, not within allowed time: #{time_expression}"
  end

  def parse_jobs_param
    jobs = {}
    job_param = config[:jobs].split(',')
    job_param.each do |j|
      name, time_expression = j.split('=')
      raise "Jobs mut be expressed as JOB_NAME=TIME_EXPRESSION. Invalid parameter: '#{j}'" if time_expression.nil?
      jobs[name] = time_expression
    end
    jobs
  end
end
