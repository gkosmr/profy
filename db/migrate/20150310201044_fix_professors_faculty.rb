class FixProfessorsFaculty < ActiveRecord::Migration
  def change
  	add_column :professors, :faculty_id, :integer
  	remove_column :professors, :faculty, :string
  end
end
