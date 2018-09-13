module Task2
  # Database items generator
  class Generator
    def initialize(db)
      @db = db
    end

    def generate
      @db[:users].concat(generate_users)
      @db[:authors].concat(generate_authors)
      @db[:books].concat(generate_books)

      generate_upvotes_and_follows
    end

    def generate_upvotes_and_follows
      @db[:upvotes].concat(generate_upvotes).uniq
      @db[:follows].concat(generate_follows).uniq
    end

    private

    def generate_users
      Array.new(4) { User.new(Faker::Name.name) }
    end

    def generate_authors
      Array.new(4) { Author.new(Faker::Book.author) }
    end

    def generate_books
      Array.new(16) do
        Book.new(
          @db[:authors].sample,
          Faker::Book.title,
          Date.today - rand(512)
        )
      end
    end

    def generate_upvotes
      Array.new(32) { Upvote.new(@db[:users].sample, @db[:books].sample) }
    end

    def generate_follows
      Array.new(8) { Follow.new(@db[:users].sample, @db[:authors].sample) }
    end
  end
end
