class Comment < Sequel::Model
  plugin :schema
  include Rakismet::Model
  
  attr_accessor :user_ip, :user_agent, :referrer
  
  unless table_exists?
    set_schema  do
      primary_key :id
      text        :entry_id
      text        :author
      text        :content
      timestamp   :created_at
    end
    create_table
  end
  
end