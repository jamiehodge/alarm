class Comment
  include Mongoid::Document
  include Rakismet::Model
  
  attr_accessor :user_ip, :user_agent, :referrer
  
  field :author
  field :email
  field :content
  field :created_at
  
  field :entry_id
  
  validates_presence_of :author
  validates_presence_of :email
  validates_presence_of :content
  
  def avatar_url
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=48"
  end
end