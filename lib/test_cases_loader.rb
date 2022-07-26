# frozen_string_literal: true

class TestCasesLoader
  ATTRIBUTES = %w[name external_id status summary].freeze

  private_constant :ATTRIBUTES

  def initialize(issue)
    @issue = issue
  end

  def call
    return true unless issue.test_suite_id && testlink_projects.include?(issue.project_id)

    load_test_cases.either(
      lambda do |test_cases|
        test_cases.each do |test_case|
          TestCase.find_or_initialize_by(test_case_id: test_case['id'], issue: issue).tap do |c_f|
            c_f.assign_attributes(test_case.slice(*ATTRIBUTES))
          end.save!
        end

        true
      end,
      ->(*) { false }
    )
  end

  private

  attr_reader :issue

  def testlink_projects
    Setting['plugin_redmine_testlink']['testlink_projects'].map(&:to_i)
  end

  def load_test_cases
    TestlinkApiClient.test_cases_for_test_suit(issue.test_suite_id)
  end
end
