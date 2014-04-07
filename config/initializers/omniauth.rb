Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,  "523801491004858",  "c1ed460eb76f1ef5bf8e7aef8778d5b1"
  # provider :facebook,  "793145320716213",  "4bb009b5c1f927f6f8b67a9f7263d5bd"
  provider :twitter, "DyYDHqEtefUT3e2RmG6lew", "2Y2g9j27NwRwF1idGc5SDD0IxuCfWOgmt8YKYAQv0"
  provider :linkedin, "75yyfobt0sn48u", "WltoGwjsnzXje9G3"
  provider :gplus, "519215666192-m0u8umhk9uvl9metqf80qnf4280u5bdi.apps.googleusercontent.com", "QDEGAkTrblEq1lgj_CDCP_3I"
end