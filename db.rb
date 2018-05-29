require "active_record"

# DB接続設定
ActiveRecord::Base.establish_connection(
  adapter:  "mysql2",
  host:     "localhost",
  username: "root",
  password: "",
  database: "mercari",
)


class Item < ActiveRecord::Base
end
class Brand < ActiveRecord::Base
end
class Category < ActiveRecord::Base
end
