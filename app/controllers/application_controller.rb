class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # to auto load lib/ directory
  # config.autoload_paths += %W(#{config.root}/lib)
  # config.assets.paths << "#{Rails.root}/vendor/assets/fonts" 
end
