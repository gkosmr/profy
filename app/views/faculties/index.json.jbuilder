json.array!(@faculties) do |faculty|
  json.extract! faculty, :id, :name, :short_name, :university, :address
  json.url faculty_url(faculty, format: :json)
end
