# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_weatherapp_session',
  :secret      => '487b3a0ba378bfc4dd2dfdc550acab15d04d19126b28a1b530bd2d7b089a061201c9e2918735824073f30bf252ac3779ca125b5d3615716772519ba6d7837d4d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
