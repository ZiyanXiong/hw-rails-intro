class Movie < ActiveRecord::Base
  def self.with_ratings(ratings)
    if ratings
      where(rating: ratings.map(&:upcase))
    else
      all
    end
  end
end