Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,  "523801491004858",  "c1ed460eb76f1ef5bf8e7aef8778d5b1"
  provider :twitter, "DyYDHqEtefUT3e2RmG6lew", "2Y2g9j27NwRwF1idGc5SDD0IxuCfWOgmt8YKYAQv0"
end