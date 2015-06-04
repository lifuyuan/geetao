class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  before_action :configure_permitted_parameters, if: :devise_controller?

  def commentable_comment_path(comment, anchor)
    commentable = comment.commentable
    case commentable.class.name.underscore
    when "trip"
      "#{trip_path(commentable)}##{anchor}"
    end
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
  end

  private
  # 获取http:/xxx.xxxxx.com/xxx.json?token=aMUj5kiyLbmZdjpr_iAu
  # 判断token的值是否存在，若存在且能在User表中找到相应的，就登录此用户
  def authenticate_user_from_token!
    token = params[:token].presence
    user = token && User.where(authentication_token: token.to_s).first
    if user
      sign_in user, store: false
    end
  end
end
