module ReviewsHelper

	def class_for rating
		if rating < 3
			"panel-danger"
		elsif rating == 3
			"panel-warning"
		else
			"panel-success"
		end
	end

end
