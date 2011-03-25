class Comment
  include Mongoid::Document
  include Rakismet::Model
  
  attr_accessor :user_ip, :user_agent, :referrer
  
  field :author
  field :author_email
  field :content
  field :published
  
  field :episode_id
	field :permalink
  
  validates_presence_of :author
  validates_presence_of :author_email
  validates_presence_of :content
	validates_presence_of :episode_id
	validates_presence_of :permalink
  
	index :episode_id
	
  def avatar_url
    default_url = 'http://larm.media.hum.ku.dk/wp-content/themes/larm/images/avatar.jpg'
    gravatar_id = Digest::MD5.hexdigest(author_email.downcase) if author_email
    "http://gravatar.com/avatar/#{gravatar_id}.png?d=#{default_url}"
  end
end