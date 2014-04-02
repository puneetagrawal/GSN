# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Neo4jApp::Application.config.secret_key_base = 'a02a09e68f70bbdb8cd4756c1f7326ccf4581bcee403ccbd5700066b1a65f742e2774066e493756312212564809ffd1bbea9fd8ce14cb0e1654ac3df1c3755f0'
