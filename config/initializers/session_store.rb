# Be sure to restart your server when you modify this file.

if Rails.env.development?
  RedditRadioApp::Application.config.session_store :cookie_store, key: '_RedditRadioApp_session', domain: :all, tld_length: 2
elsif Rails.env.production?
  RedditRadioApp::Application.config.session_store :cookie_store, key: '_RedditRadioApp_session', domain: :all, tld_length: 3
end


# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# RedditRadioApp::Application.config.session_store :active_record_store
