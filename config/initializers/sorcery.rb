Sorcery::Controller::Config.submodules = []

Sorcery::Controller::Config.user_class = 'User'

Sorcery::Controller::Config.configure do |config|
  config.user_config do |user|
    user.stretches = 1 if ENV['RACK_ENV'] == 'test'
    user.user_lookup_method = :find_by_email
    user.username_attribute_names = [:email]
    user.downcase_username_before_authenticating = true
  end

  config.user_config do |user|
    user.authentications_class = nil
  end
end
