require "sinatra"
require "sinatra/reloader" if development?
require "pg"
require "active_record"

ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  database: "tiy-database"
)

class Employee < ActiveRecord::Base
  self.primary_key = :id

  def monthly_salary
    salary / 12.0
  end
end

# Sinatra code starts here

# This magic tells Sinatra to close the database connection
# after each request
after do
  ActiveRecord::Base.connection.close
end

get "/" do
  erb :home
end

get "/employees" do
  @employees = Employee.all

  erb :employees
end

get "/new_employee" do
  erb :new_employee
end

post "/create_employee" do
  Employee.create(params)

  redirect to("/employees")
end

get '/show_employee' do
  @employee = Employee.find(params["id"])

  erb :employee
end

get '/edit_employee' do
  @employee = Employee.find(params["id"])

  erb :edit_employee
end

post '/update_employee' do
  employee = Employee.find(params["id"])

  employee.update_attributes(params)

  redirect to("/employees")
end

get '/search_employee' do
  @employees = Employee.where(name: params["search"])

  erb :employees
end

get '/delete_employee' do
  employee = Employee.find(params["id"])
  employee.delete

  redirect to('/employees')
end
