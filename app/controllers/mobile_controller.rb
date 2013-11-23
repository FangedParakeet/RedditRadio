require 'open-uri'
require 'json'

class MobileController < ApplicationController
  before_filter :mobile_setup
  
  include PagesHelper
  
  def mobile_setup
    unless cookies[:mobile_param]
      redirect_to root_url(subdomain: false)
    end
  end
  
  def home
    if cookies[:repeat]
      cookies.delete(:repeat, domain: :all)
    end
  end
  
  def shuffler
    all_embeds = []
    @subreddits = []
    @embeds = []
    @titles = []
    @types = []
    @subs = []
    @permalinks = []
    params.each do |key, value|
      if key[/subin/]
        name = value.downcase
        @subreddits << name
        if filter_subreddits name
          collect_embeds name, all_embeds
        end
      end
    end
    if all_embeds.empty?
      flash[:notice] = "You have chosen...poorly. No content there: try again!"
    end
    
    all_embeds.shuffle!
    all_embeds.each do |embed|
      @titles << embed[:title]
      @embeds << embed[:embed]
      @subs << embed[:subreddit]
      @types << embed[:type]
      @permalinks << "http://reddit.com" + embed[:permalink]
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def next
    @embed = params[:embed]
    @title = params[:title]
    @sub = params[:sub]
    @type = params[:type]
    @permalink = params[:permalink]
    respond_to do |format|
      format.js
    end
  end
  
end