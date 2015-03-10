class Professor < ActiveRecord::Base
	validates :first_name, :last_name, :faculty_id, presence: true

	has_many :reviews
	belongs_to :faculty

	def full_name
		"#{first_name} #{last_name}"
	end

	def average_rating
		reviews.count > 0 ? (reviews.sum(:rating).to_f / reviews.count).round(2) : 0
	end

	def name_with_faculty_and_average_rating
		"#{full_name} (#{faculty.short_name}) - #{average_rating}"
	end
end
