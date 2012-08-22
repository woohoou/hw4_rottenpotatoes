class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  def self.find_similar_movies(id)
    debugger if id == 1
    movie = Movie.find_by_id id
    
    unless movie.nil? || movie.director.nil?
      Movie.where('id != ? and director = ?',id,movie.director)
    else
      []
    end 
  end
end
