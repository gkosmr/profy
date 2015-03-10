class Faculty < ActiveRecord::Base
	validates :name, :short_name, :university, presence: true

	has_many :professors

	def average_rating
		reviews_number > 0 ? professors.map{ |p| p.reviews.map{ |r| r.rating }.sum }.sum / reviews_number : 0
	end

	def name_with_rating
		"#{name} - #{average_rating}"
	end

	def reviews_number
		professors.map{ |p| p.reviews.count }.sum
	end
end
