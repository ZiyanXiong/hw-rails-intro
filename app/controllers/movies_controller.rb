class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @all_ratings = ['G','PG','PG-13','R']
      @checked_ratings = params[:ratings]
      @sort_order = params[:sort_order]
      if not session.empty?
        read_session
      end
      
      if not @checked_ratings
        @checked_ratings = @all_ratings
      else
        @checked_ratings = @checked_ratings.keys
      end
      @movies = Movie.with_ratings(@checked_ratings)

      if @sort_order
        @movies = Movie.with_ratings(@checked_ratings).order @sort_order
      end
      session['ratings'] = @checked_ratings
      session['sort_order'] = @sort_order
    end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
    
    def read_session
      if not @checked_ratings
        @checked_ratings = session[:ratings].map{ |rating| [rating, '1'] }.to_h
      end
      
      if not @sort_order
        @sort_order = session[:sort_order]
      end
    end
  end