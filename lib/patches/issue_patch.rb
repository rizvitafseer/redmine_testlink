# frozen_string_literal: true

module IssuePatch
module Patches::IssuePatch
  def self.included(base)
    base.class_eval do
      unloadable
      has_many :test_cases, dependent: :destroy, class_name: 'TestCase'
    end
  end
end
end
Issue.include IssuePatch
