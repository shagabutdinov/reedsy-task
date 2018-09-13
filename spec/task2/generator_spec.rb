require 'task2'

module Task2
  describe Task2::Generator do
    describe '#generate' do
      let(:db) do
        { users: [], authors: [], books: [], upvotes: [], follows: [] }
      end

      subject { Task2::Generator.new(db) }

      it 'generates non empty users array' do
        subject.generate
        expect(db[:users].empty?).to be(false)
      end

      it 'generates Users' do
        subject.generate
        expect(db[:users].first).to be_an_instance_of(User)
      end

      it 'generates non empty authors array' do
        subject.generate
        expect(db[:authors].empty?).to be(false)
      end

      it 'generates Authors' do
        subject.generate
        expect(db[:authors].first).to be_an_instance_of(Author)
      end

      it 'generates non empty books array' do
        subject.generate
        expect(db[:books].empty?).to be(false)
      end

      it 'generates Books' do
        subject.generate
        expect(db[:books].first).to be_an_instance_of(Book)
      end

      it 'generates non empty upvotes array' do
        subject.generate
        expect(db[:upvotes].empty?).to be(false)
      end

      it 'generates Upvotes' do
        subject.generate
        expect(db[:upvotes].first).to be_an_instance_of(Upvote)
      end

      it 'generates non empty follows array' do
        subject.generate
        expect(db[:follows].empty?).to be(false)
      end

      it 'generates Follows' do
        subject.generate
        expect(db[:follows].first).to be_an_instance_of(Follow)
      end
    end
  end
end
