class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_filter :require_login, only: [:index, :new, :create, :activate]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    respond_to do |format|
     format.html and return
     format.json { render :json => User.where(name: /#{params[:q]}/).map(&:attributes) } and return
    end
  end


  # GET /users/1
  # GET /users/1.json
  def show
    if !current_user.isAdmin? and current_user.id != @user.id
     redirect_to user_path(current_user.id)
    end
  end

  # GET /users/new
  def new
    unless current_user
      @user = User.new
    else 
      redirect_to edit_user_path(current_user.id), notice: 'While you are logged in, you can not create new users.'
    end
  end

  # GET /users/1/edit
  def edit
    redirect_to user_path
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if current_user.isAdmin? and User.where(:role => "admin").count == 1 and user_params[:role]=="user" and current_user.id == @user.id
      redirect_to user_path, notice: "It is not possible to update the role while being the only admin."
    else
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end


  # DELETE /users/1
  # DELETE /users/1.json
  def destroy   
    if !current_user.isScrumMasterOrProductOwner?
      if !current_user.isAdmin?
        if current_user.id == @user.id
          borrar
        else
          redirect_to(root_path, notice: "You can not delete other users")
        end
      else
        if User.where(:role => "admin").count > 1  or  @user.role == "user"
          borrar
        else
          redirect_to(users_path, notice: "It is not allowed to delete the admin")
        end
      end
    else
     redirect_to(root_path, notice: "It is not allowed to delete users while being a Scrum Master or Product Owner")
   end
 end


  def activate
    if (@user = User.load_from_activation_token(params[:id]))
      @user.activate!
      redirect_to(login_path, :notice => 'User was successfully activated.')
    else
      not_authenticated
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :role, :email, :password, :password_confirmation, :avatar)
    end

    # To delete an user when requested
    def borrar
      @user.deleteUserFromUserStories
      @user.deleteUserFromComments
      @user.destroy
      respond_to do |format|
        format.html { redirect_to root_path }
        format.json { head :no_content }
      end
    end

end