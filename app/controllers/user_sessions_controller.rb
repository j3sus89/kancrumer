class UserSessionsController < ApplicationController
	skip_before_filter :require_login, except: [:destroy]

	def new
		unless current_user
			@user = User.new
		else 
			redirect_to projects_path, notice: 'You have already logged in.'
		end
	end

	def create
		if @user = login(params[:email], params[:password])
			redirect_to(projects_path)
			flash.now[:notice] = 'Login successful'
	  	else
	  		flash.now[:alert] = "Login failed"
	  		render action: "new"
	  	end
	end

	def destroy
		logout
		redirect_to(root_path, notice: 'Logged out!')
	end

end
