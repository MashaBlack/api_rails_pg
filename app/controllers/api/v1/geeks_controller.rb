class Api::V1::GeeksController < ApplicationController
  before_action :set_geek, only: [:show, :update, :destroy]

  def index
    if params[:job_id]
      @geeks = Job.find(params[:job_id]).applies.map{|apply| apply.geek}
    elsif params[:company_id]
      @geeks = []
      Company.find(params[:company_id]).jobs.map do |job|
        @geeks = @geeks + job.applies.map{|apply| apply.geek}
      end
      @geeks = @geeks.uniq{|x| x.id}
    else
      @geeks = Geek.where(geek_params)
    end
    render json: { geeks: @geeks }, except: [:id, :created_at, :updated_at]
  end

  def show
    render json: @geek
  end

  def create
    @geek = Geek.new(geek_params)
    if @geek.save
      render json: @geek.as_json, status: :created
    else
      render json: {user: @geek.errors, status: :no_content}
    end
  end

  def update
    if @geek.update(geek_params)
      render json: @geek
    else
      render json: @geek.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @geek.destroy
      render json: {deleted_geek: @geek, code: 200, status: 'success'}
    else
      render json: @geek.errors, status: :unprocessable_entity
    end
  end

  private
  def set_geek
    @geek = Geek.find(params[:id])
  end

  def geek_params
    params.permit(:stack, :name, :resume)
  end

end