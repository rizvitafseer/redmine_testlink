# frozen_string_literal: true

require 'dry/monads'
require 'xmlrpc/client'

class TestlinkApiClient
  extend Dry::Monads[:result, :do]

  API_PATH = '/lib/api/xmlrpc/v1/xmlrpc.php'

  class << self
    def check_dev_key
      send_request('tl.checkDevKey')
    end

    def projects_list
      response = yield send_request('tl.getProjects')

      Success(Hash[response.map { |el| el.slice('name', 'id').values }])
    end

    def test_project_by_name(project)
      args = { testprojectname: project.name }

      response = yield send_request('tl.getTestProjectByName', args)
      Success(response.fetch('id'))
    end

    def create_test_project(project)
      args = {
        testcaseprefix: project.identifier,
        testprojectname: project.name,
        notes: project.description
      }

      response = yield send_request('tl.createTestProject', args)
      Success(response.first.fetch('id'))
    end

    def create_test_suite(project_id, issue)
      args = {
        testprojectid: project_id,
        testsuitename: issue.subject,
        details: issue.description,
        checkduplicatedname: 1,
        actiononduplicatedname: 'generate_new',
        order: 1
      }

      response = yield send_request('tl.createTestSuite', args)
      Success(response.first.fetch('id'))
    end

    def test_cases_for_test_suit(test_suite_id)
      args = { testsuiteid: test_suite_id, deep: true, details: 'full' }

      response = yield send_request('tl.getTestCasesForTestSuite', args)
      Success(response)
    end

    private

    def send_request(method, params = {})
      stat, response = server.call2(method, params.merge(devKey: dev_key))

      if stat && response.is_a?(Array) && response[0]&.key?('code')
        Failure(response[0].fetch('message'))
      elsif stat
        Success(response)
      else
        Failure('Method call to XMLRPC API failed.')
      end
    end

    def server
      @server ||= XMLRPC::Client.new_from_uri(URI.join(base_url, API_PATH))
    end

    def base_url
      Setting['plugin_redmine_testlink']['testlink_base_url']
    end

    def dev_key
      Setting['plugin_redmine_testlink']['testlink_api_key']
    end
  end
end
