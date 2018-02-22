require("pry")

class Book
  attr_reader :id, :title, :author, :genre, :inventory

  def initialize(attributes)
    @title = attributes[:title]
    @author = attributes[:author]
    @genre = attributes[:genre]
    @id = attributes[:id]
    @inventory = 1
  end

  def save
    if (DB.exec("SELECT EXISTS(SELECT * FROM books WHERE title='#{@title}' AND author='#{@author}');")[0]['exists'])=='t'
      DB.exec("UPDATE books SET inventory=inventory+1 WHERE title='#{@title}' AND author='#{@author}';")
    else
      DB.exec("INSERT INTO books (title, author, genre, inventory) VALUES ('#{@title}', '#{@author}', '#{@genre}', 1)")
    end
    @id = DB.exec("SELECT id FROM books WHERE title='#{@title}' AND author='#{@author}';")[0]['id']
    @inventory = DB.exec("SELECT inventory FROM books WHERE id='#{@id}';")[0]['iventory']
  end

  def update(updates)
    DB.exec("UPDATE books SET #{updates} WHERE id = #{@id};")
    Book.search_by('id', @id)
  end

  def delete
    DB.exec("DELETE FROM books WHERE id = #{@id};")
  end

  def self.read_all
    results = DB.exec("SELECT * FROM books;")
    books = []
    results.each do |result|
      books.push(Book.new({:title => result['title'], :author => result['author'], :genre => result['genre'], :id => result['id']}))
    end
    return books
  end

  def self.search_by(column, value)
    results = DB.exec("SELECT * FROM books WHERE #{column}='#{value}';")
    books = []
    results.each do |result|
      books.push(Book.new({:title => result['title'], :author => result['author'], :genre => result['genre'], :id => result['id']}))
    end
    return books
  end

  def checkout(patron_id)
    DB.exec("INSERT INTO checkouts (patron_id, book_id) VALUES (#{patron_id}, #{@id});")
  end

  def ==(other_book)
    same_title = @title.eql?(other_book.title)
    same_author = @author.eql?(other_book.author)
    same_title.&(same_author)
  end
end
