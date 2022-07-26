# frozen_string_literal: true
module Hooks::RedmineTestlink
class RedmineTestlink < Redmine::Hook::ViewListener
  def controller_issues_new_after_save(context = {})
    issue = context[:issue]

    return unless allowed_projects.include?(issue.project_id)

    TestSuiteUploader.new(issue.project, issue, context).call
  end

  def view_issues_show_details_bottom(context = {})
    return unless allowed_projects.include?(context[:project].id)

    context[:hook_caller].instance_eval do
      @test_cases = @issue.test_cases.decorate
      render(partial: 'test_cases/list')
    end
  end

  private

  def allowed_projects
    Setting['plugin_redmine_testlink']['testlink_projects'].map(&:to_i)
  end
end
end
