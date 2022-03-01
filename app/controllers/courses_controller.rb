class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show index]
  before_action :set_course, only: %i[show edit update destroy approve analytics]

  # GET /courses or /courses.json
  def index
    if params[:title]
      @courses = Course.where('title ILIKE ?', "%#{params[:title]}%") #case-insensitive
    else
      @courses = Course.all
    end
  end

  # GET /courses/1 or /courses/1.json
  def show
    
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)
    @course.user = current_user

    if @course.save
      redirect_to course_path(@course), notice: 'Course was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to course_url(@course), notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    if @course.destroy
      redirect_to courses_path, notice: 'Course was successfully destroyed.'
    else
      redirect_to @course, alert: 'Course has enrollments. Can not be destroyed.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:title, :description)
    end
end
