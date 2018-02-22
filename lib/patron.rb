require 'book'

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
    results.each do |result|
      patrons.push(Patron.new({:name => result['name'], :id => result['id']}))
    end
    return patrons
  end

  def all_checkouts
    results = DB.exec("SELECT books.title, checkouts.patron_id FROM checkouts JOIN books ON checkouts.book_id = books.id WHERE checkouts.patron_id = #{@id};")
    #parse results
    return results
  end

  def ==(other_patron)
    same_name = @name.eql?(other_patron.name)
    same_id = @id.eql?(other_patron.id)
    same_name.&(same_id)
  end
end
