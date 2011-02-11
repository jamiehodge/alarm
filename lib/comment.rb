class Comment
  include Mongoid::Document
  include Rakismet::Model
  include Gravtastic
  gravtastic
  
  attr_accessor :user_ip, :user_agent, :referrer
  
  field :author
  field :email
  field :content
  field :created_at
  
  field :entry_id
  
  validates_presence_of :author
  validates_presence_of :email
  validates_presence_of :content
  
end