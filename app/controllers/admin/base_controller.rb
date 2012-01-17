module Admin
  class BaseController < ApplicationController
    def authenticate_admin!
      unless authenticate_user! && current_user.admin?
        redirect_to root_path
      end
    end  
  end
end
