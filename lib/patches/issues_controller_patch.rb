# frozen_string_literal: true

module IssuesControllerPatch
module Patches::IssuesControllerPatch
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
      alias_method :show_without_mod, :show
      alias_method :show, :show_with_mod
    end
  end

  module InstanceMethods
    def show_with_mod
      flash[:error] = 'Unable to load test cases' unless TestCasesLoader.new(@issue).call

      show_without_mod
    end
  end
end
end
IssuesController.include IssuesControllerPatch
