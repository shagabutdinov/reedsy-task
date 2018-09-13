require 'task2'

module Task2
  RSpec.shared_examples 'Feed#retrieve - user follows author' do |_parameter|
    it 'returns a book ' do
      db[:books].push(book)
      expect(subject).to eq([book])
    end

    it 'returns two books ' do
      db[:books].concat([book, other_book])
      expect(subject).to eq([book, other_book])
    end

    it 'not returns book for other author' do
      other_book.author = Author.new('OTHER AUTHOR')
      db[:books].concat([book, other_book])
      expect(subject).to eq([book])
    end
  end

  RSpec.shared_examples 'Feed#retrieve - user upvoted a book' do |_parameter|
    it 'returns a book of same author' do
      expect(subject).to eq([other_book])
    end

    it 'returns two book of same author' do
      db[:books].push(Book.new(author, 'New Book', Date.today))
      expect(subject.length).to eq(2)
    end

    it 'not returns a book of other author' do
      other_book.author = Author.new('OTHER AUTHOR')
      expect(subject).to eq([])
    end
  end

  describe Task2::Feed do
    let(:user) { User.new('USER') }
    let(:author) { Author.new('AUTHOR') }
    let(:book) { Book.new(author, 'BOOK', Date.today) }
    let(:other_book) { Book.new(author, 'OTHER BOOK', Date.today) }

    let(:db) do
      {
        users: [user],
        authors: [author],
        books: [],
        upvotes: [],
        follows: []
      }
    end

    describe '#retrieve' do
      subject { Task2::Feed.new(db, user).retrieve }

      it 'returns no books if books are empty' do
        expect(subject).to eq([])
      end

      it 'returns no books if user not follows and not upvotes' do
        db[:books].push(book)
        expect(subject).to eq([])
      end

      context 'user follows author' do
        before :each do
          db[:follows].push(Follow.new(user, author))
        end

        include_examples 'Feed#retrieve - user follows author'
      end

      context 'user upvoted the book' do
        before :each do
          db[:upvotes].push(Upvote.new(user, book))
          db[:books].concat([book, other_book])
        end

        include_examples 'Feed#retrieve - user upvoted a book'
      end
    end

    describe '#refresh' do
      let(:feed) { Feed.new(db, user) }
      subject { feed.refresh }

      it 'returns no books if books are empty' do
        expect(subject).to eq([])
      end

      it 'returns no books if user not follows and not upvotes' do
        db[:books].push(book)
        expect(subject).to eq([])
      end

      it 'returns books if it is called first time' do
        db[:follows].push(Follow.new(user, author))
        db[:books].push(book)
        expect(subject).to eq([book])
      end

      context 'user follows author' do
        before :each do
          db[:follows].push(Follow.new(user, author))
          db[:books].push(Book.new('Old Book', author, Date.today))
          feed.retrieve
        end

        include_examples 'Feed#retrieve - user follows author'
      end

      context 'user upvoted the book' do
        before :each do
          db[:upvotes].push(Upvote.new(user, book))
          db[:books].concat([book, other_book])
        end

        include_examples 'Feed#retrieve - user upvoted a book'
      end
    end
  end
end
