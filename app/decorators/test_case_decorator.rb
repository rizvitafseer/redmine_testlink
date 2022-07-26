# frozen_string_literal: true

class TestCaseDecorator < Draper::Decorator
  delegate_all

  def humanize_test_case_id
    "##{test_case_id}"
  end

  def humanize_status
    statuses_map[status]
  end

  private

  def statuses_map
    {
      '1' => I18n.t('status_draft'),
      '2' => I18n.t('status_ready_for_review'),
      '3' => I18n.t('status_review_in_progress'),
      '4' => I18n.t('status_rework'),
      '5' => I18n.t('status_obsolete'),
      '6' => I18n.t('status_future'),
      '7' => I18n.t('status_final')
    }
  end
end
