require("pry")

class Book
  attr_reader :id
  attr_accessor :name, :specialty

  def initialize(attributes)
    @title = attributes[:title]
    @author = attributes[:author]
    @genre = attributes[:genre]
    @id = attributes[:id]
  end

  def save
    if (DB.exec("SELECT EXISTS(SELECT * FROM books WHERE title='#{@title}' AND author='#{@author}');")[0]['exists'])=='t'
      DB.exec("UPDATE books SET inventory=inventory+1 WHERE title='#{@title}' AND author='#{@author}';")
    else
      DB.exec("INSERT INTO books (title, author, genre, inventory) VALUES ('#{@title}', '#{@author}', '#{@genre}', 1)")
    end
    @id = DB.exec("SELECT id FROM books WHERE title='#{@title}' AND author='#{@author}';")[0]['id']
  end

  def self.read_all
    results = DB.exec("SELECT * FROM books;")
    books = []
    results.each do |result|
      books.push(Book.new({:title => result['title'], :author => result['author'], :genre => result['genre'], :id => result['id']}))
    end
    return books
  end
end
#   def save
#     if !(DB.exec("SELECT * FROM books WHERE title='#{@title}';").column_values(1).include?(@name))
#       DB.exec("INSERT INTO doctors (name, specialty) VALUES ('#{@name}', '#{@specialty}');")
#     end
#   end
#
#   def self.read_all
#     result = DB.exec("SELECT * FROM doctors;")
#     doctors = []
#     result.each do |doctor|
#       doctors.push(doctor)
#     end
#     return doctors
#   end
#
#   def get_id
#     @id = DB.exec("SELECT id FROM doctors WHERE name='#{@name}';")[0]['id'].to_i
#   end
#
#   def self.get_name(id)
#     DB.exec("SELECT name FROM doctors WHERE id='#{id}';")[0]['name']
#   end
#
#   def self.get_patients(id)
#     result = DB.exec("SELECT * FROM patients WHERE doctorid='#{id}';")
#     patients = []
#     result.each do |patient|
#       patients.push(patient)
#     end
#     return patients
#   end
#
#   def ==(other_doctor)
#     same_name = self.name.eql?(other_doctor.name)
#     same_specialty = self.specialty.eql?(other_doctor.specialty)
#     same_name.&(same_specialty)
#   end
# end
