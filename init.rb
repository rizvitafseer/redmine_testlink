# frozen_string_literal: true

ActiveSupport::Reloader.to_prepare do
  SettingsHelper.include RedmineTestlinkSettingsHelper
  require_dependency 'hooks/redmine_testlink'
  require_dependency 'patches/issue_patch'
  require_dependency 'patches/issues_controller_patch'
end

reloader = defined?(ActiveSupport::Reloader) ? ActiveSupport::Reloader : ActionDispatch::Reloader
reloader.to_prepare do
  paths = '/app/helpers/*.rb'
  Dir.glob(File.dirname(__FILE__) + paths).each do |file|
    require_dependency file
  end
end

Redmine::Plugin.register :redmine_testlink do
  name 'Redmine Testlink integration plugin'
  author 'Semen Formatorov'
  description 'Plugin for Redmine and Testlink integration'
  version '1.0.0'

  settings default: {
    'testlink_base_url' => 'http://localhost/testlink',
    'testlink_api_key' => '',
    'testlink_projects' => []
  }, partial: 'settings/testlink_settings'
end
