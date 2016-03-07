class UserStoriesController < ApplicationController
  before_action :set
  before_action :set_user_story, only: [:show, :edit, :update, :destroy]

  # GET /user_stories
  # GET /user_stories.json
  def index
    if @project.belongsToProject?(current_user) or current_user.isAdmin?
      redirect_to project_sprint_path(@sprint.project, @sprint)
    else
     redirect_to root_path
     flash[:notice] = 'Action not allowed'
    end
 end

  
  # GET /user_stories/1
  # GET /user_stories/1.json
  def show
    if !@project.belongsToProject?(current_user) and !current_user.isAdmin?
      redirect_to root_path
      flash[:notice] = 'Action not allowed'
    end
  end

  # GET /user_stories/new
  def new
    if @project.isScrumMasterOrProductOwner?(current_user) or current_user.isAdmin?
      @user_story = @sprint.user_stories.build
    else
      forbidden
    end
  end

  # GET /user_stories/1/edit
  def edit
    if !@project.isScrumMasterOrProductOwner?(current_user) and !current_user.isAdmin?
      forbidden
    end
  end

  # POST /user_stories
  # POST /user_stories.json
  def create
    @user_story = @sprint.user_stories.create(user_story_params)
    respond_to do |format|
      if @user_story.save
        format.html { redirect_to project_sprint_user_stories_path, notice: 'User story was successfully created.' }
        format.json { render action: 'show', status: :created, location: [@user_story.sprint.project, @user_story.sprint, @user_story] }
      else
        format.html { render action: 'new' }
        format.json { render json: @user_story.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_stories/1
  # PATCH/PUT /user_stories/1.json
  def update
    respond_to do |format|
      if @user_story.update(user_story_params)
        format.html { redirect_to project_sprint_user_story_path, notice: 'User story was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_story.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_stories/1
  # DELETE /user_stories/1.json
  def destroy
    if @project.isScrumMaster?(current_user) or current_user.isAdmin?
      @user_story.destroy
      respond_to do |format|
        format.html { redirect_to project_sprint_user_stories_path }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set
      @project = Project.find(params[:project_id])  
      @sprint = @project.sprints.find(params[:sprint_id])
    end

    def set_user_story
      @user_story = @sprint.user_stories.find(params[:id])
    end

    def forbidden
      redirect_to project_sprint_path(@sprint.project, @sprint)
      flash[:notice] = 'Action not allowed'
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_story_params
      params.require(:user_story).permit(:title, :description, :state, :verticalOrder, :us_resp, :effort, :priority, :code)
    end
end
