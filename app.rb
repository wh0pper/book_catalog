#!/home/linuxbrew/.linuxbrew/bin/env ruby
require 'sinatra'
require 'sinatra/reloader'
require 'pry'
also_reload('lib/**/*.rb')
require './lib/doctor'
require './lib/patient'
require 'pg'

DB = PG.connect({:dbname => 'doctor_patient'})

get('/') do
  erb(:home)
end

get('/doctors') do
  erb(:doctors)
end

post('/doctors') do
  @doc_id = params[:doctor_id]
  @doc_name = Doctor.get_name(@doc_id)
  @patient_list = Doctor.get_patients(@doc_id)
  erb(:doctors)
end

get('/patients') do
  erb(:patients)
end

get('/administrators') do
  @doctors = Doctor.read_all
  @patients = Patient.read_all
  erb(:administrators)
end

post('/administrators') do
  doctor_name = params[:name_doc]
  specialty = params[:specialty]
  patient_name = params[:name_patient]
  dob = params[:dob]
  need = params[:need]
  if doctor_name
    doctor = Doctor.new({:name => doctor_name, :specialty => specialty})
    doctor.save
  end
  if patient_name
    patient = Patient.new({:name => patient_name, :dob => dob, :need => need})
    patient.save
  end
  @doctors = Doctor.read_all
  @patients = Patient.read_all
  erb(:administrators)
end

get('/patients/:id') do
  @this_patient = Patient.find(params[:id])
  @this_patient.get_id
  @doctors = Doctor.read_all
  erb(:patients)
end

post('/patients/:id/assign') do
  @this_patient = Patient.find(params[:id])
  @this_patient.get_id
  @doctors = Doctor.read_all
  @doc_id = params[:doclist]
  @this_patient.assign_dr(@doc_id)
  @doc_name = Doctor.get_name(@doc_id)
  erb(:patients)
end
