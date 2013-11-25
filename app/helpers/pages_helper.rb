module PagesHelper
  
  def filter_subreddits subreddit
    if Subreddit.find_by_name(subreddit)
      return true
    elsif there_are_posts(subreddit)
      Subreddit.create(name: subreddit)
      return true
    else
      return false
    end
  end
  
  def collect_embeds name, anArray
    subreddit = JSON.parse(open("http://reddit.com/r/#{name}.json").read)
    subreddit["data"]["children"].each do |post|
      if post["data"]["domain"] == "youtube.com"
        if post["data"]["media"]
          if post["data"]["media"]["oembed"]["url"]
            url = post["data"]["media"]["oembed"]["url"]
          else
            url = post["data"]["url"]
          end
        else
          url = post["data"]["url"]
        end
        begin
          if url.include?("watch?v=")
            if cookies[:mobile_param]
              url = url.split(/\?v=/)[1]
            else
              url.sub!("watch?v=", "v/")
              url << "&enablejsapi=1&playerapiid=ytplayer"
            end
            title = post["data"]["title"]
            permalink = post["data"]["permalink"]
            post = {title: title, embed: url, subreddit: name, permalink: permalink, type: "yt"}
            anArray << post
          end
        rescue Timeout::Error
          flash[:notice] = "Sorry, something snapped. Try again please!"
        rescue
          flash[:notice] = "Sorry, something snapped. Try again please!"
        end
        
      elsif post["data"]["domain"] == "youtu.be"
        if post["data"]["media"]
          if post["data"]["media"]["oembed"]["url"]
            url = post["data"]["media"]["oembed"]["url"]
          else
            url = post["data"]["url"]
          end
        else
          url = post["data"]["url"]
        end
        begin
          if url.include?("watch?v=")
            if cookies[:mobile_param]
              url = url.split(/\?v=/)[1]
            else
              url.sub!("watch?v=", "v/")
              url << "&enablejsapi=1&playerapiid=ytplayer"
            end
            title = post["data"]["title"]
            permalink = post["data"]["permalink"]
            post = {title: title, embed: url, subreddit: name, permalink: permalink, type: "yt"}
            anArray << post
          elsif url.include?("tu.be")
            id = url.split(/.be\//)[1]
            if cookies[:mobile_param]
              url = id
            else
              url = "http://www.youtube.com/v/" + id + "&enablejsapi=1&playerapiid=ytplayer"
            end
            title = post["data"]["title"]
            permalink = post["data"]["permalink"]
            post = {title: title, embed: url, subreddit: name, permalink: permalink, type: "yt"}
            anArray << post
          end
        rescue Timeout::Error
          flash[:notice] = "Sorry, something snapped. Try again please!"
        rescue
          flash[:notice] = "Sorry, something snapped. Try again please!"
        end
          
        
      elsif post["data"]["domain"] == "vimeo.com"
        if post["data"]["url"]
          url = post["data"]["url"]
        end
        begin
          if url[/\d+/]
            id = url[/\d+/]
            url = "http://player.vimeo.com/video/" + id + "?api=1&player_id=vimeoplayer"
            title = post["data"]["title"]
            permalink = post["data"]["permalink"]
            post = {title: title, embed: url, subreddit: name, permalink: permalink, type: "vimeo"}
            anArray << post
          end
        rescue Timeout::Error
          flash[:notice] = "Sorry, something snapped. Try again please!"
        rescue
          flash[:notice] = "Sorry, something snapped. Try again please!"
        end
        
      elsif (post["data"]["domain"] == "soundcloud.com")
        if post["data"]["url"]
          url = post["data"]["url"]
          if cookies[:mobile_param]
            begin 
              resolve = JSON.parse(open("http://api.soundcloud.com/resolve.json?url=#{url}&client_id=d3750bf74d82aac4548040d9af90fcef").read)
              if resolve["id"]
                url = resolve["id"].to_s
              else
                url = ""
              end
            rescue
              url = ""
            end
          end
        end
        begin
          if url[/(soundcloud)/] || url[/^\d+$/]
            title = post["data"]["title"]
            permalink = post["data"]["permalink"]
            post = {title: title, embed: url, subreddit: name, permalink: permalink, type: "soundcloud"}
            anArray << post
          end
        rescue Timeout::Error
          flash[:notice] = "Sorry, something snapped. Try again please!"
        rescue
          flash[:notice] = "Sorry, something snapped. Try again please!"
        end
      end      
    end
  end
  
  def there_are_posts name
    result = true
    begin 
      JSON.parse(open("http://reddit.com/r/#{name}.json").read)
    rescue
      result = false
    end
    result
  end

end