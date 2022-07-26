# frozen_string_literal: true

class TestSuiteUploader
  def initialize(project, issue, context)
    @project = project
    @issue = issue
    @context = context
  end

  def call
    testlink_project(project).either(
      lambda do |project_id|
        create_test_suite(project_id, issue).either(
          ->(test_suite_id) { issue.update!(test_suite_id: test_suite_id) },
          ->(error) { flash_error(error, context) }
        )
      end,
      lambda do |_error|
        create_test_project(project).either(
          lambda do |project_id|
            create_test_suite(project_id, issue).either(
              ->(test_suite_id) { issue.update!(test_suite_id: test_suite_id) },
              ->(error) { flash_error(error, context) }
            )
          end,
          ->(error) { flash_error(error, context) }
        )
      end
    )
  end

  private

  attr_reader :project, :issue, :context

  def testlink_project(project)
    TestlinkApiClient.test_project_by_name(project)
  end

  def create_test_project(project)
    TestlinkApiClient.create_test_project(project)
  end

  def create_test_suite(project_id, issue)
    TestlinkApiClient.create_test_suite(project_id, issue)
  end

  def flash_error(error, context)
    context[:hook_caller].instance_eval do
      flash[:error] = error
    end
  end
end
