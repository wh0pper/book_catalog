#!/home/linuxbrew/.linuxbrew/bin/env ruby
require 'sinatra'
require 'sinatra/reloader'
require 'pry'
also_reload('lib/**/*.rb')
require './lib/book'
require './lib/patron'
require 'pg'

DB = PG.connect({:dbname => 'library'})

get('/') do
  erb(:home)
end

get('/librarian') do
  @book_list = Book.read_all
  erb(:librarian)
end

post('/librarian') do
  new_book = Book.new({:title => params[:title], :author => params[:author], :genre => params[:genre]})
  new_book.save
  @book_list = Book.read_all
  erb(:librarian)
end

get('/librarian/book/:id') do
  book_id = params[:id]
  @this_book = Book.search_by('id',book_id)[0]
  erb(:book)
end

delete('/librarian/book/:id') do
  book_id = params[:id]
  this_book = Book.search_by('id',book_id)[0]
  this_book.delete
  erb(:book)
end

patch('/librarian/book/:id') do
  book_id = params[:id]
  updates = "title = '#{params[:title]}', author = '#{params[:author]}', genre = '#{params[:genre]}'"
  this_book = Book.search_by('id',book_id)[0]
  @this_book = this_book.update(updates)
  erb(:book)
end

post('/librarian/search') do
  column = params[:search_field]
  value = params[:search_value]
  @search_list = Book.search_by(column, value)
  erb(:search)
end

get('/patron') do

  erb(:patron)
end

# get('/doctors') do
#   erb(:doctors)
# end
#
# post('/doctors') do
#   @doc_id = params[:doctor_id]
#   @doc_name = Doctor.get_name(@doc_id)
#   @patient_list = Doctor.get_patients(@doc_id)
#   erb(:doctors)
# end
#
# get('/patients') do
#   erb(:patients)
# end
#
# get('/administrators') do
#   @doctors = Doctor.read_all
#   @patients = Patient.read_all
#   erb(:administrators)
# end
#
# post('/administrators') do
#   doctor_name = params[:name_doc]
#   specialty = params[:specialty]
#   patient_name = params[:name_patient]
#   dob = params[:dob]
#   need = params[:need]
#   if doctor_name
#     doctor = Doctor.new({:name => doctor_name, :specialty => specialty})
#     doctor.save
#   end
#   if patient_name
#     patient = Patient.new({:name => patient_name, :dob => dob, :need => need})
#     patient.save
#   end
#   @doctors = Doctor.read_all
#   @patients = Patient.read_all
#   erb(:administrators)
# end
#
# get('/patients/:id') do
#   @this_patient = Patient.find(params[:id])
#   @this_patient.get_id
#   @doctors = Doctor.read_all
#   erb(:patients)
# end
#
# post('/patients/:id/assign') do
#   @this_patient = Patient.find(params[:id])
#   @this_patient.get_id
#   @doctors = Doctor.read_all
#   @doc_id = params[:doclist]
#   @this_patient.assign_dr(@doc_id)
#   @doc_name = Doctor.get_name(@doc_id)
#   erb(:patients)
# end
