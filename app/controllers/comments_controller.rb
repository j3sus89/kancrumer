class CommentsController < ApplicationController
  before_action :set
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    if @project.belongsToProject?(current_user) or current_user.isAdmin?
      redirect_to project_sprint_user_story_path(@user_story.sprint.project, @user_story.sprint, @user_story)
    else
     redirect_to root_path
     flash[:notice] = 'Action not allowed'
   end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    if @project.belongsToProject?(current_user) or current_user.isAdmin?
      redirect_to project_sprint_user_story_path(@user_story.sprint.project, @user_story.sprint, @user_story)
    else
     redirect_to root_path
     flash[:notice] = 'Action not allowed'
   end
  end

  # GET /comments/new
  def new
    if @project.belongsToProject?(current_user) or current_user.isAdmin?
      @comment = @user_story.comments.build
    else
      redirect_to root_path
      flash[:notice] = 'Action not allowed'
    end
  end

  # GET /comments/1/edit
  def edit
    if !@comment.isAuthor?(current_user) and !current_user.isAdmin?
      redirect_to root_path
      flash[:notice] = 'Action not allowed'
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = @user_story.comments.create(comment_params)#Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to project_sprint_user_story_comments_path, notice: 'Comment was successfully created.' }
        format.json { render action: 'show', status: :created, location: [@comment.user_story.sprint.project, @comment.user_story.sprint, @comment.user_story, @comment] }
      else
        format.html { render action: 'new' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to project_sprint_user_story_comments_path, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to project_sprint_user_story_comments_path }
      format.json { head :no_content }
    end
  end

  private
    #
    def set
      @project = Project.find(params[:project_id])  
      @sprint = @project.sprints.find(params[:sprint_id])
      @user_story = @sprint.user_stories.find(params[:user_story_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = @user_story.comments.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:body, :user, :date)
    end
end
