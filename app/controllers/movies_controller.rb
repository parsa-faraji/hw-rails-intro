class MoviesController < ApplicationController
  before_action :set_movie, only: %i[show edit update destroy]

  SORTABLE_COLUMNS = %w[title release_date].freeze

  # GET /movies or /movies.json
  def index
    @all_ratings = Movie.all_ratings

    @ratings_to_show =
      if params[:ratings].present?
        params[:ratings].keys
      else
        @all_ratings
      end

    @sort_by =
      if SORTABLE_COLUMNS.include?(params[:sort_by])
        params[:sort_by]
      else
        "title"
      end

    @movies = Movie.with_ratings(@ratings_to_show)
                   .order(@sort_by => :asc)
  end

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html do
          redirect_to @movie, notice: "Movie was successfully created."
        end

        format.json do
          render :show, status: :created, location: @movie
        end
      else
        format.html do
          render :new, status: :unprocessable_entity
        end

        format.json do
          render json: @movie.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html do
          redirect_to @movie, notice: "Movie was successfully updated."
        end

        format.json do
          render :show, status: :ok, location: @movie
        end
      else
        format.html do
          render :edit, status: :unprocessable_entity
        end

        format.json do
          render json: @movie.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy!

    respond_to do |format|
      format.html do
        redirect_to movies_path,
                    status: :see_other,
                    notice: "Movie was successfully destroyed."
      end

      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_movie
    @movie = Movie.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def movie_params
    params.require(:movie).permit(
      :title,
      :rating,
      :description,
      :release_date
    )
  end
end