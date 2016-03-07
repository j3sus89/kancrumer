class SprintsController < ApplicationController
  before_action :set_project
  before_action :set_sprint, only: [:show, :edit, :update, :destroy, :saveOrder]

  # GET /sprints
  # GET /sprints.json
  # ScrumMaster, ScrumMember y ProductOwner
  def index
    if @project.belongsToProject?(current_user) or current_user.isAdmin?
      redirect_to project_path(@project)
    else
     redirect_to root_path
      flash[:notice] = 'Action not allowed'
    end
  end


  # GET /sprints/1
  # GET /sprints/1.json
  # ScrumMaster, ScrumMember y ProductOwner
  def show
    if !@project.belongsToProject?(current_user) and !current_user.isAdmin?
      redirect_to root_path
      flash[:notice] = 'Action not allowed'
    end
  end

  # GET /sprints/new
  # ScrumMaster y ProductOwner
  def new
    if @project.isScrumMasterOrProductOwner?(current_user) or current_user.isAdmin?
      @sprint = @project.sprints.build
    else
      forbidden
    end
  end

  # GET /sprints/1/edit
    # ScrumMaster y ProductOwner
  def edit
    if !@project.isScrumMasterOrProductOwner?(current_user) and !current_user.isAdmin?
      forbidden
    end
  end

  # POST /sprints
  # POST /sprints.json
  def create    
    @sprint = @project.sprints.create(sprint_params)
    @sprint.setNew

    respond_to do |format|
      if @sprint.save
        format.html { redirect_to(project_sprints_path, notice: 'Sprint was successfully created.') }
        format.json { render action: 'show', status: :created, location: [@sprint.project, @sprint] }
      else
        format.html { render action: 'new' }
        format.json { render json: @sprint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sprints/1
  # PATCH/PUT /sprints/1.json
  def update
    respond_to do |format|
      if @sprint.update(sprint_params)
        format.html { redirect_to(project_sprint_path, notice: 'Sprint was successfully updated.') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sprint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sprints/1
  # DELETE /sprints/1.json
  def destroy
    if @project.isScrumMaster?(current_user) or current_user.isAdmin?
      @sprint.changeOrder
      @sprint.destroy
      respond_to do |format|
        format.html { redirect_to project_sprints_path }
        format.json { head :no_content }
      end
    else
      forbidden
    end
  end

  def saveOrder
    aux = params[:data].split(":");
    contadorVertical = 1
    aux[1].split(",").each do |e|
      @sprint.user_stories.find(e.to_s).state = aux[0].to_i
      @sprint.user_stories.find(e.to_s).verticalOrder = contadorVertical
      contadorVertical = 1 + contadorVertical
    end
    @project.save

    respond_to do |format|
      format.html { redirect_to project_sprints_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_sprint
      #@sprint = Sprint.find(params[:id])
      @sprint = @project.sprints.find(params[:id])
    end

    def forbidden
      redirect_to projects_path
      flash[:notice] = 'Action not allowed'
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sprint_params
      params.require(:sprint).permit(:name, :description, :startdate, :deadline, :order)
    end
end
