class Review < ActiveRecord::Base
	validates :professor_id, :rating, presence: true
	validates :rating, numericality: { only_integer: true, greater_than: 0, less_than: 6	}

	belongs_to :professor
end
