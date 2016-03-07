class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :changeOrder]
  #before_filter :get_list, :only => [:new]

  # GET /projects
  # GET /projects.json
  def index
    if current_user.isAdmin?
      @allProjects = Project.all
    else
      @projectsAsScrumMaster = Project.where(scrumMaster: current_user.id)
      @projectsAsProductOwner = Project.where(productOwner: current_user.id)
      @projectAsScrumMember = []
      current_user.projects.each do |p|
        if !@projectsAsScrumMaster.include?(p) and !@projectsAsProductOwner.include?(p)
          @projectAsScrumMember << p
        end
      end 
    end
  end

  def changeOrder
    pos = 1
    params[:data].split(";").each do |e|
      @project.sprints.find(e).order = pos
      pos = pos + 1
    end
    @project.save

    respond_to do |format|
      format.html { redirect_to @project }
        format.json { head :no_content }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    if !current_user.isAdmin?
        if !@project.belongsToProject?(current_user)
          redirect_to projects_path
          flash[:notice] = 'You can only access your projects'
        end   
      end 
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
    if !current_user.isAdmin?
        if !@project.isScrumMasterOrProductOwner?(current_user)
          redirect_to projects_path
          flash[:notice] = 'You can only access your projects'
        end   
      end 
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render action: 'show', status: :created, location: @project }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        #@project.sendEmailIfChanges(beforeSM, beforePO)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    if current_user.isAdmin? or @project.isScrumMaster?(current_user)
      @project.destroy
      respond_to do |format|
        format.html { redirect_to projects_url }
        format.json { head :no_content }
      end
    else
      redirect_to projects_path
      flash[:notice] = 'You are not allowed to delete this project'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :scrumMaster, :productOwner, :scrumMember, :description)#, :developers)
    end

end
