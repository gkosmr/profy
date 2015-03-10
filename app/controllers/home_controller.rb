class HomeController < ApplicationController
  def index
  	@professors = Professor.all.select{ |p| p.reviews.count > 0 }.sort_by{ |p| p.average_rating }
  	@faculties = Faculty.all.select{ |f| f.reviews_number > 0 }.sort_by{ |f| f.average_rating }
  end
end
