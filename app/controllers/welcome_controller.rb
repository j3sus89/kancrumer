class WelcomeController < ApplicationController
	skip_before_filter :require_login, only: [:index]
  def index
  	if current_user
  		redirect_to projects_path
  	end
  end
end
