#!/usr/bin/env ruby
# Encoding: utf-8
#
# Author:: jimper@google.com (Jonathon Imperiosi)
#
# Copyright:: Copyright 2013, Google Inc. All Rights Reserved.
#
# License:: Licensed under the Apache License, Version 2.0 (the "License");
#           you may not use this file except in compliance with the License.
#           You may obtain a copy of the License at
#
#           http://www.apache.org/licenses/LICENSE-2.0
#
#           Unless required by applicable law or agreed to in writing, software
#           distributed under the License is distributed on an "AS IS" BASIS,
#           WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
#           implied.
#           See the License for the specific language governing permissions and
#           limitations under the License.
#
# This example illustrates how to list all files for a report
#
# Tags: reports.files.list

require_relative 'dfareporting_utils'

def get_all_report_files(dfareporting, args)
  # Get all report files
  result = dfareporting.reports.files.list(
    :profileId => args['profile_id'],
    :reportId => args['report_id']
  ).execute()

  while not result.nil? do
    # Display results.
    result.data.items.each do |file|
      puts 'File with ID "%s" and file name "%s" has status "%s".' %
          [file.id, file.fileName, file.status]
    end

    token = result.data.next_page_token

    unless result.data.items.empty? or token.empty?
      result = result.next_page().execute()
    else
      result = nil
    end
  end
end

if __FILE__ == $0
  # Retrieve command line arguments
  args = DfaReportingUtils.get_arguments(ARGV, 'profile_id', 'report_id')

  # Authenticate and initialize API service
  dfareporting = DfaReportingUtils.setup()

  get_all_report_files(dfareporting, args)
end
