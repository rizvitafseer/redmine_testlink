# frozen_string_literal: true

module RedmineTestlinkSettingsHelper
  def testlink_plugin_setting_text_field(setting, value, options = {})
    safe_join(
      [
        setting_label(setting, options),
        text_field_tag("settings[#{setting}]", value, options)
      ]
    )
  end

  def testlink_plugin_setting_multiselect(setting, choices, values, options = {})
    setting_values = values
    setting_values = [] unless setting_values.is_a?(Array)

    safe_join(
      [
        content_tag('label', l(options[:label] || "setting_#{setting}")),
        hidden_field_tag("settings[#{setting}][]", ''),
        multiselect_values(setting, choices, setting_values, options)
      ]
    )
  end

  private

  def multiselect_values(setting, choices, setting_values, options)
    safe_join(
      choices.map do |choice|
        text, value = (choice.is_a?(Array) ? choice : [choice, choice])
        content_tag(
          'label',
          check_box_tag("settings[#{setting}][]", value, setting_values.include?(value), id: nil) + text.to_s,
          class: (options[:inline] ? 'inline' : 'block')
        )
      end
    )
  end
end
