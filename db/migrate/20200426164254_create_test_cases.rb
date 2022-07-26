# frozen_string_literal: true

class CreateTestCases < ActiveRecord::Migration[5.2]
  def change
    create_table :test_cases do |t|
      t.references :issue, index: true
      t.integer :test_case_id, null: false
      t.string :name
      t.string :external_id
      t.string :status, null: false
      t.text :summary

      t.timestamps
    end
  end
end
