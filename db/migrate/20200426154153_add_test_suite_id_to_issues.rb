# frozen_string_literal: true

class AddTestSuiteIdToIssues < ActiveRecord::Migration[5.2]
  def change
    add_column :issues, :test_suite_id, :integer
  end
end
