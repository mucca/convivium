# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_convivium_session',
  :secret      => '0c7b760cc41a3d5a3746a15620d2ca6f4b0c8401aea1cffea25ea4567c4770c8f008cfca3aba734df6ee05cd1907db285c86e33e12261d7ee4063a31f8dfa68a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
