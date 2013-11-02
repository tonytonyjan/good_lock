Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, Settings.google.key, Settings.google.secret, scope: 'userinfo.email userinfo.profile plus.me calendar.readonly'
end