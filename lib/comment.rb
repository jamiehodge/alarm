class Comment
  include Mongoid::Document
  include Rakismet::Model
  include Gravtastic
  
  attr_accessor :user_ip, :user_agent, :referrer
  
  field :author
  field :email
  field :content
  field :created_at
  
  field :entry_id
  
end