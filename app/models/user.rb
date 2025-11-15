class User < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || password.present? }

  after_validation :log_validation_errors, if: -> { errors.any? }

  private

  def log_validation_errors
    AppLogger.debug "User validation failed: #{errors.full_messages.join(', ')}"
  end
end
