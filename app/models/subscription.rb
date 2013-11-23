class Subscription < ActiveRecord::Base
  attr_accessible :subreddit_id, :user_id
  
  belongs_to :user
  belongs_to :subreddit
end
