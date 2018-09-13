module Task2
  # Feed calculator class
  class Feed
    def initialize(db, user)
      @db = db
      @user = user
      @last_retrived_book_index = -1
    end

    def retrieve
      retrieve_books(@db[:books])
    end

    def refresh
      # index-based approach is used for refresh because user may expect of
      # buying a book from our store even if it was published somewhere else
      # already
      retrieve_books(@db[:books][@last_retrived_book_index + 1..-1])
    end

    private

    def retrieve_books(books)
      @last_retrived_book_index = @db[:books].length - 1

      result =
        books_by_authors(books, followed_authors) +
        books_by_authors(books, upvoted_authors) -
        upvoted_books

      result.uniq.sort_by(&:published_on)
    end

    def followed_authors
      @db[:follows]
        .select { |follow| follow.user == @user }
        .map(&:author)
    end

    def upvoted_authors
      upvoted_books
        .map(&:author)
        .uniq
    end

    def upvoted_books
      @db[:upvotes]
        .select { |upvote| upvote.user == @user }
        .map(&:book)
    end

    def books_by_authors(books, authors)
      books.select do |book|
        authors.include?(book.author)
      end
    end
  end
end
