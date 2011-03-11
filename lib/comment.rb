class Comment
  include Mongoid::Document
  include Rakismet::Model
  
  attr_accessor :user_ip, :user_agent, :referrer
  
  field :author
  field :email
  field :content
  field :published
  
  field :feed_id
	field :episode_id
  
  validates_presence_of :author
  validates_presence_of :email
  validates_presence_of :content
  
  def avatar_url
    default_url = 'http://larm.media.hum.ku.dk/wp-content/themes/larm/images/avatar.jpg'
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?d=#{default_url}"
  end
end