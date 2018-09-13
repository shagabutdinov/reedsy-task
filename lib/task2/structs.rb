module Task2
  User = Struct.new(:name)
  Author = Struct.new(:name)
  Book = Struct.new(:author, :title, :published_on)
  Upvote = Struct.new(:user, :book)
  Follow = Struct.new(:user, :author)
end
