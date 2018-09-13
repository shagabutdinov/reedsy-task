module Task2
  # Application entry-point class
  class App
    def initialize
      @user = User.new('Leo')
      @db = initial_db
      @log = Logger.new(STDOUT)
      @feed = Feed.new(@db, @user)
      @generator = Generator.new(@db)
    end

    def initial_db
      {
        users: [@user],
        authors: [],
        books: [],
        upvotes: [],
        follows: []
      }
    end

    def run
      @log.info('generate sample data...')
      @generator.generate

      @log.info("books in user \"#{@user.name}\" feed:")
      print_books(@feed.retrieve)

      @log.info('generate sample data again...')
      @generator.generate

      @log.info("new books in user's feed:")
      print_books(@feed.refresh)
    end

    def print_books(books)
      books.each do |book|
        @log.info("#{book.title} by #{book.author.name} @#{book.published_on}")
      end
    end
  end
end
