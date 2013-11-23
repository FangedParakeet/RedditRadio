class User < ActiveRecord::Base
  attr_accessible :cookie, :modhash, :username
  
  has_many :subscriptions
  has_many :subreddits, through: :subscriptions
  
end
