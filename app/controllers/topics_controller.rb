class TopicsController < ApplicationController
  before_action :set_topic, only: [:edit, :update, :show, :destroy]
  layout "blog"
  access all: [:show, :index], user: {except: [:destroy, :new, :update, :edit]}, site_admin: :all

  def new
    @topic = Topic.new
    @page_title = "Create Topic"
  end

  def edit
    @page_title = "Edit Topic"
  end

  def show
    @topics = Topic.all
    @page_title = "Topic Show Page"
    @featured_blogs = Topic.find(params[:id]).blogs.page(params[:page]).per(5)
  end

  def index
    @topics = Topic.all
    @page_title = "Create Topic"

  end

  def destroy
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to topics_url, notice: 'Topic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def create
    @topic = Topic.new(topic_params)

    respond_to do |format|
      if @topic.save
        format.html { redirect_to @topic, notice: 'Topic was successfully created.' }
        format.json { render :show, status: :created, location: @topic }
      else
        format.html { render :new }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to @topic, notice: 'Topic was successfully updated.' }
        format.json { render :show, status: :ok, location: @topic }
      else
        format.html { render :edit }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:title)
  end

  def set_topic
    @topic = Topic.find(params[:id])
  end
end
