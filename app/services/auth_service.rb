class AuthService
  def self.authenticate(email, password)
    AppLogger.debug "Login attempt for email: #{email}"
    user = User.find_by(email: email)
    AppLogger.debug "User found: #{user ? "ID #{user.id}" : 'nil'}"

    return { success: false, error: "no user found with email #{email}" } unless user
    return { success: false, error: "incorrect password for #{email}" } unless user.authenticate(password)

    AppLogger.info "User #{user.id} (#{email}) authenticated successfully"
    { success: true, user: user }
  end

  def self.register(email, password, password_confirmation)
    AppLogger.info "Registration attempt for #{email}"

    user = build_user(email, password, password_confirmation)

    if user.save
      registration_success(user, email)
    else
      registration_failure(user, email)
    end
  rescue StandardError => e
    handle_registration_error(e)
  end

  def self.build_user(email, password, password_confirmation)
    User.new(
      email: email,
      password: password,
      password_confirmation: password_confirmation
    )
  end

  def self.registration_success(user, email)
    AppLogger.info "User #{user.id} (#{email}) registered successfully"
    { success: true, user: user }
  end

  def self.registration_failure(user, email)
    AppLogger.warn "Registration failed for #{email}: #{user.errors.full_messages.join(', ')}"
    { success: false, errors: user.errors.full_messages }
  end

  def self.handle_registration_error(err)
    AppLogger.error "Registration exception: #{err.class} - #{err.message}"
    AppLogger.error err.backtrace.join("\n")
    { success: false, errors: ["An error occurred: #{err.message}"] }
  end
end
