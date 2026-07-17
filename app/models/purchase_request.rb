class PurchaseRequest < ApplicationRecord
  belongs_to :user

  enum :status, {
    draft: 0,
    submitted: 1,
    approved: 2,
    rejected: 3
  }

# Reading the maximum title length from the YAML configuration
# makes it easy to change without modifying the application code.
validates :title,
          presence: true,
          length: {
            maximum: APPROVAL_SETTINGS.dig(:approval, :max_title_length)
          }

  validates :amount,
            presence: true,
            numericality: { greater_than: 0 }

  before_validation :set_default_status

  after_create :log_creation
  after_save :notify_on_status_change
  after_commit :log_commit, on: [:create, :update]

  private

  def set_default_status
    self.status ||= :draft
  end

  def log_creation
    Rails.logger.info "PurchaseRequest ##{id} created: #{title}"
  end

  def notify_on_status_change
  if saved_change_to_status?
    old_status, new_status = saved_change_to_status

    Rails.logger.info(
      "PurchaseRequest ##{id} status changed from #{old_status} to #{new_status}"
    )
  end
end

  def log_commit
    Rails.logger.info "PurchaseRequest ##{id} committed to DB"
  end
end