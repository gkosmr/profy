Profy (Professor Rating App)
============================

##FMF workshop Exemplary RoR App##


Models:
-------
Professor: first_name, last_name, position, course_names, faculty, has_many :reviews
Review: professor_id, comment, rating


Procedure:
----------

c=console, s=sublime, b=browser (chrome)

c: rails new profy
c: cd profy
c: sblm

c: ctrl+shift+t (open new tab in console)
c: rails server

b: http://localhost:3000

s: open app/views/layouts/application.html.erb (ugly HTML!)
b: ctrl+t (open new tab in browser); go to rubygems.org, find haml-rails, copy code
s: open Gemfile
     remove: 12th & 13th line (coffee rails)
     add: gem 'haml-rails', '~> 0.8.2' (paste)
  
c: bundle install

s: copy application.html.erb
b: google html2haml; convert
s: create app/views/layouts/application.html.haml & paste the code
s: remove application.html.erb

c: rails generate scaffold professor first_name:string last_name:string position:string course_names:string faculty:string

s: examine files that were created with scaffolding
     migration, model, controller, views, routes
c: rake routes

b: go to localhost:3000/professors (ERROR!)
c: rake db:migrate
b: refresh

b: go to new professor, enter fields and create one; check show, edit, destroy links
b: go to new; create with empty fields; it works, but we want name, ...

s: open app/models/professor.rb
     add: validates :first_name, :last_name, :faculty, presence: true
	 
b: try to add empty professor again (you get errors)
b: create new with first, last name & faculty

let's see what's going on here:

c: rake routes ---> GET /professors -> professors_controller index action, sets @professors, renders app/views/professors/index.html.haml
if we change name of any file, it won't work (Convention over Configuration!!)
we examine all actions, views, routes, controller & model

c: rails console (play around a bit)
s: open professor.rb
    add method: def full_name
					"#{first_name} #{last_name}"
				end
c: rails console -> Professor.first.full_name


c: rails g scaffold review professor_id:integer rating:integer comment:text
s: open config/routes.rb
     remove: resources :reviews
	 add: resources :reviews to resources :professors block	
	 
c: rake routes
c: rake db:migrate

s: add validations to models/review.rb
      	validates :professor_id, :rating, presence: true
     	validates :rating, numericality: { only_integer: true, greater_than: 0, less_than: 6 }
s: associate both models:
    to models/review.rb add:   belongs_to :professor
	to models/professor.rb add:   has_many :reviews

s: reviews_controller, add: before_action: set_professor
s: fix path method calls for reviews (add professor, professors in front) in all review views & reviews_controller
s: reviews/_form.html add: f.hidden_field :professor_id, value: @professor.id

s: professors/show.html: make it nicer, add comments, average rating
	add at the end (brute force):
		%h2 Reviews
		- @professor.reviews.each do |review|
		  .review{ style: "border: 1px gray solid; margin: 10px 0; "}
			.review-head{ style: "background-color: #aaa; padding: 10px;" }
			  %span{ style: "float: right;" }= review.created_at
			  %span{ style: "font-size: 20px; font-weight: bold;"}
				Rating:
				= review.rating
			- if review.comment.present?
			  .review-body{ style: "padding: 20px;" }
				= review.comment

	refactor a bit:
		create file app/views/reviews/_review.html.haml that holds code for one review
		  .review{ style: "border: 1px gray solid; margin: 10px 0; "}
			.review-head{ style: "background-color: #aaa; padding: 10px;" }
			  %span{ style: "float: right;" }= review.created_at
			  %span{ style: "font-size: 20px; font-weight: bold;"}
				Rating:
				= review.rating
			- if review.comment.present?
			  .review-body{ style: "padding: 20px;" }
				= review.comment		  
		and then instead of - @professor.review.each .... add: = render @professor.reviews
		
	remove show action, show route and show view (since we add it here)

	add review form at the end:
		%h2 Add review
		%div{style: "border: 1px gray solid; padding: 20px 10px;"}
			= render 'reviews/form', url: professor_reviews_path(@professor)
	
	add at the beginning of reviews/_form.html.haml:
		- @review ||= Review.new
	
	after create redirect to professor_path; change reviews_controller, action create: 
		on save: redirect_to professor_path(@professor)
		on error: render 'professors/show'
		
	remove new review action, new.html.haml, new from routes
	
	remove index action
	
	add edit & destroy links to review and change redirect links in controller
	
s: add average_rating method to professor.rb:
	def average_rating
		(reviews.sum(:rating).to_f / reviews.count).round 2 if reviews.count > 0
	end
	
s: add to routes.rb: root 'professors#index'

s: to gemfile add: gem 'bootstrap-sass', '~> 3.3.3'
c: bundle install
s: rename application.css to application.scss
s: in application.scss delete everything, and add 
	@import "bootstrap-sprockets";
	@import "bootstrap";
s: in application.js add //= require bootstrap
c: reset server (ctrl+c; rails s)

b: show bootstrap on their webpage

s: improve application.html.haml (add .container, add header partial with navbar, add %meta{name: "viewport", content: "width=device-width, initial-scale=1"})
s: improve professors/index.html (add classes table, table-striped, replace new link with button)
s: improve professors/_form.html (add form-horizontal, form-group, ...)
s: improve reviews/_review.html (use panels; use different colors for different ratings; dodaš .row pred collection in daš pred panel še .col-lg-6; move add review before)

add faculty scaffold:

c: rails g scaffold faculty name:string short_name:string university:string address:string
c: rake db:migrate

s: open models/faculty.rb; add validations, association (validates :name, :short_name, :university, presence: true; has_many :professors)

b: open /faculties; add new one
s: style views with bootstrap
s: add faculties & professors to menu:
	%nav.navbar.navbar-default
	  .container
		.navbar-header
		  %button.navbar-toggle.collapsed{"aria-expanded" => "false", "data-target" => "#navbar", "data-toggle" => "collapse", :type => "button"}
			%span.sr-only Toggle navigation
			%span.icon-bar
			%span.icon-bar
			%span.icon-bar
		  = link_to 'Home', root_path, class: 'navbar-brand'
		#navbar.collapse.navbar-collapse
		  %ul.nav.navbar-nav
			%li= link_to 'Professors', professors_path
			%li= link_to 'Faculties', faculties_path

add faculty_id column to professor, and remove faculty column
c: rails g migration fix_professors_faculty:
s: add to migration:
	  	add_column :professors, :faculty_id, :integer
		remove_column :professors, :faculty, :string
c: rake db:migrate

s: fix models/professor.rb so that it validates faculty_id and has belongs_to :faculty
s: fix professors/_form so that instead of text field it shows select with all faculties
s: fix professors_controller.rb so that it accepts faculty_id
s: fix professors/show & index views to render faculty.name 

c: rails g controller home index		
s: routes.rb, set root to 'home#index'

s: make home/index nicer; add titles, add statistics
s: add @professors = Professor.all.select{ |p| p.reviews.count > 0 }.sort_by{ |p| p.average_rating } to home_controller.rb
s: add to home/index:
	.col-lg-6
		%h4 Top rated professors
		%ol= render partial: 'professor', collection: @professors.last(5)
	.col-lg-6
		%h4 Worst rated professors
		%ol= render partial: 'professor', collection: @professors.first(5)		

s: add file _professor.html.haml to views/home with content: %li= professor.name_with_faculty_and_average_rating
s: add method to models professor:
	def name_with_faculty_and_average_rating
		"#{full_name} (#{faculty.short_name}) - #{average_rating}"
	end
	
s: do similar things for faculties
	@faculties = Faculty.all.select{ |f| f.reviews_number > 0 }.sort_by{ |f| f.average_rating }
	
	home/_faculty.html.haml: %li= faculty.name_with_rating
	
	def average_rating
		reviews_number > 0 ? professors.map{ |p| p.reviews.map{ |r| r.rating }.sum }.sum / reviews_number : 0
	end

	def name_with_rating
		"#{name} - #{average_rating}"
	end

	def reviews_number
		professors.map{ |p| p.reviews.count }.sum
	end
	
	.col-lg-6
		%h4 Best faculties
		%ol= render partial: 'faculty', collection: @faculties.reverse.first(5)
	.col-lg-6
		%h4 Worst faculties
		%ol= render partial: 'faculty', collection: @faculties.first(5)
		
s: refactor home/index (add panels, partial list)
	= render 'list', title: 'Top rated professors', klass: 'success', type: 'professor', col: @professors.reverse.first(5)
	= render 'list', title: 'Worst rated professors', klass: 'danger', type: 'professor', col: @professors.first(5)
	= render 'list', title: 'Best faculties', klass: 'success', type: 'faculty', col: @faculties.reverse.first(5)
	= render 'list', title: 'Worst faculties', klass: 'danger', type: 'faculty', col: @faculties.first(5)

	home/_list.html.haml: 
		.col-lg-6
			.panel{ class: "panel-#{klass}" }
				.panel-heading
					%h4= title
				.panel-body
					%ol= render partial: type, collection: col
