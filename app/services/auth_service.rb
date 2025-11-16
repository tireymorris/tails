class AuthService
  def self.authenticate(email, password)
    user = User.find_by(email:)

    unless user
      AppLogger.warn "Authentication failed: no user found with email #{email}"
      return { success: false, error: "no user found with email #{email}" }
    end

    unless user.authenticate(password)
      AppLogger.warn "Authentication failed: incorrect password for user #{user.id} (#{email})"
      return { success: false, error: "incorrect password for #{email}" }
    end

    { success: true, user: }
  end

  def self.register(email, password, password_confirmation)
    user = User.new(email:, password:, password_confirmation:)

    unless user.save
      AppLogger.warn "Registration failed for #{email}: #{user.errors.full_messages.join(', ')}"
      return { success: false, errors: user.errors.full_messages }
    end

    { success: true, user: }
  rescue StandardError => e
    AppLogger.error "Registration exception: #{e.class} - #{e.message}"
    AppLogger.error e.backtrace.join("\n")
    { success: false, errors: ["An error occurred: #{e.message}"] }
  end
end
