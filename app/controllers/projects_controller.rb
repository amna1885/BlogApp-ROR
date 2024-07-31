# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]
  before_action :authorize_project, only: %i[edit update destroy]

  def index
    @projects = policy_scope(Project)
  end

  def show; end

  def new
    @project = Project.new
    authorize @project
  end

  def create
    @project = Project.new(project_params)
    authorize @project

    if @project.save
      redirect_to @project, notice: t('projects.create.success')
    else
      render :new
    end
  end

  def edit; end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: t('projects.update.success')
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_url,  notice: t('projects.destroy.success')
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :content)
  end

  def authorize_project
    authorize @project
  end
end
