class Api::V1::AppliesController < ApplicationController
  before_action :set_apply, only: [:show, :update, :destroy]

  def index
    if params[:job_id]
      @applies = Job.find(params[:job_id]).applies.where(where_params)
    elsif params[:geek_id]
      @applies = Geek.find(params[:geek_id]).applies.where(where_params)
    elsif params[:company_id]
      @applies = []
      Company.find(params[:company_id]).jobs.map do |job|
        @applies = @applies + job.applies
      end
    else
      @applies = Apply.where(where_params)
    end
    render json: { applies: @applies }, except: [:id, :created_at, :updated_at]
  end

  def show
    render json: @apply
  end

  def create
    @apply = Apply.new(apply_params)
    if @apply.save
      render json: @apply.as_json, status: :created
    else
      render json: {user: @apply.errors, status: :no_content}
    end
  end

  def update
    if @apply.update(apply_params)
      render json: @apply
    else
      render json: @apply.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @apply.destroy
      render json: {deleted_apply: @apply, code: 200, status: 'success'}
    else
      render json: @apply.errors, status: :unprocessable_entity
    end
  end

  private
  def set_apply
    @apply = Apply.find(params[:id])
  end

  def where_params
    params.permit(:read, :invited)
  end

  def apply_params
    params.permit(:job_id, :geek_id, :read, :invited)
  end
end
