class Patron
  attr_reader :name, :id

  def initialize(attributes)
    @name = attributes[:name]
    @id = attributes[:id]
  end

  def save
    DB.exec("INSERT INTO patrons (name) VALUES ('#{@name}');")
    @id = DB.exec("SELECT id FROM patrons WHERE name = '#{@name}';")[0]['id']
  end

  def self.read_all
    results = DB.exec("SELECT * FROM patrons;")
    patrons = []
    # binding.pry
    results.each do |result|
      patrons.push(Patron.new({:name => result['name'], :id => result['id']}))
    end
    return patrons
  end

  def ==(other_patron)
    same_name = @name.eql?(other_patron.name)
    same_id = @id.eql?(other_patron.id)
    same_name.&(same_id)
  end
end

  #
  # def self.read_all
  #   variable = DB.exec("SELECT * FROM patients;")
  #   patients = []
  #   variable.each do |x|
  #     patients.push(x)
  #   end
  #   return patients
  # end

  # def assign_dr(doctor_id)
  #   @doctorid = doctor_id
  #   DB.exec("UPDATE patients SET doctorid = '#{doctor_id}' WHERE name='#{@name}'")
  # end
  #
  # def self.find(id)
  #   info = DB.exec("SELECT * FROM patients WHERE id='#{id}';")[0]
  #   Patient.new({:name => "#{info['name']}", :dob => "#{info['dob']}", :need => "#{info['need']}"})
  # end
