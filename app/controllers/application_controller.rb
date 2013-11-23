class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  
  before_filter :prepare_for_mobile
  
  def mobile_device?
    if cookies[:mobile_param]
      cookies[:mobile_param]
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end
  helper_method :mobile_device?

  def prepare_for_mobile
    if params[:mobile]
      if params[:mobile] == '0'
        cookies.delete(:mobile_param, domain: :all)
      else
        cookies[:mobile_param] = { value: 'ok', domain: :all}
      end
    elsif mobile_device?
      cookies[:mobile_param] = { value: 'ok', domain: :all}
    end
  end
  
  # def select_domain_for_cookie
  #   if Rails.env.production?
  #     3
  #   elsif Rails.env.development?
  #     2
  #   end
  # end
  # helper_method :select_domain_for_cookie
end
