require 'open-uri'
require 'json'


class PagesController < ApplicationController

  include PagesHelper
  
  before_filter :mobile_redirect
  
  def mobile_redirect
    if cookies[:mobile_param]
      redirect_to mobile2_url
    end
  end

  def home
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
      if key[/subreddit/]
        name = value.downcase
        @subreddits << name
        if filter_subreddits name
          collect_embeds name, all_embeds
        end
      end
    end
    if all_embeds.empty?
      flash[:notice] = "You have chosen...poorly. No content there: try again!"
      redirect_to root_url
    end
    
    all_embeds.shuffle!
    all_embeds.each do |embed|
      @titles << embed[:title]
      @embeds << embed[:embed]
      @subs << embed[:subreddit]
      @types << embed[:type]
      @permalinks << "http://reddit.com" + embed[:permalink]
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
  
  def add_sub
    @last = params[:sub].to_i
    @next = @last + 1
    
    respond_to do |format|
      format.js
    end
  end
  
  def remove_sub
    @remove = params[:sub]
    
    respond_to do |format|
      format.js
    end
  end
  
  def sesame
    respond_to do |format|
      format.js
    end
  end
  
  def test
  end

end