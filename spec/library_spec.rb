require 'rspec'
require 'pg'
require 'pry'
require 'book'
require 'patron'

DB = PG.connect({:dbname => 'library_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM checkouts *;")
    DB.exec("DELETE FROM books *;")
    DB.exec("DELETE FROM patrons *;")
  end
end

test_attr = {:title => 'Brave New World', :author => 'Aldous Huxley', :genre => 'science fiction'}

describe('Book') do
  describe('#save and #self.read_all') do
    it('creates new book instance') do
      book = Book.new(test_attr)
      book.save
      list = Book.read_all
      expect(list).to(eq([book]))
    end

    it('generates DB id for book and saves this value within instance') do
      book = Book.new(test_attr)
      book.save
      expect(DB.exec("SELECT id FROM books WHERE title='Brave New World'")[0]['id']).to(eq(book.id))
    end

    it('increases DB inventory when adding existing books') do
      book1 = Book.new(test_attr)
      book2 = Book.new(test_attr)
      book1.save
      book2.save
      expect(DB.exec("SELECT inventory FROM books WHERE title='Brave New World'")[0]['inventory']).to(eq('2'))
    end
  end

  describe('#self.search_by') do
    it('returns all books matching certain column value') do
      book1 = Book.new(test_attr)
      book2 = Book.new({:title => 'Crome Yellow', :author => 'Aldous Huxley', :genre => 'historical fiction'})
      book1.save
      book2.save
      list = Book.search_by('author', 'Aldous Huxley')
      expect(list).to(eq([book1, book2]))
    end
  end

  describe('#delete') do
    it('deletes a particular book from database') do
      book1 = Book.new(test_attr)
      book1.save
      book1.delete
      list = Book.read_all
      expect(list).to(eq([]))
    end
  end

  describe('#update') do
    it('updates book in database and returns updated book object') do
      book1 = Book.new(test_attr)
      book1.save
      updated_book = book1.update("title = 'The Doors of Perception'")
      expect(Book.search_by('title', 'The Doors of Perception')).to(eq(updated_book))
    end
  end

  describe('#checkout') do
    it('checks out a book by adding it to checkouts table and decreasing its inventory') do
      book1 = Book.new(test_attr)
      book1.save
      patron = Patron.new({:name => 'test patron'})
      patron.save
      book1.checkout(patron.id)
      expect(DB.exec("SELECT * FROM checkouts;")[0]).to(eq({'patron_id' => patron.id, 'book_id' => book1.id}))
    end
  end
end

describe('Patron') do
  describe('#save and #self.read_all') do
    it('saves new patron into patrons table') do
      patron = Patron.new({:name => 'John Smith'})
      patron.save
      expect(Patron.read_all).to(eq([patron]))
    end
  end

  describe('#all_checkouts') do
    it('returns list of all currently checked out books') do
      #finish test
    end
  end
end
