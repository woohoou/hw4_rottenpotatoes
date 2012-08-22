require 'spec_helper'

describe Movie do
  before :each do
    FactoryGirl.create(:movie, id: 1, title: 'test2', rating: 'PG', director: 'Another Director')
    FactoryGirl.create(:movie, id: 2, title: 'test3', rating: 'R', director: 'George Lucas')
    FactoryGirl.create(:movie, id: 3, title: 'test1', rating: 'G', director: 'George Lucas')
    FactoryGirl.create(:movie, id: 4, title: 'test4', rating: 'G', director: 'Another Director')
    FactoryGirl.create(:movie, id: 5, title: 'test5', rating: 'G', director: 'George Lucas')
   
    @movies_mock = Movie.all
    @m = Movie.first
  end

  describe "searching similar movies" do
    it "should ask in database for movies with same director" do
      Movie.should_receive(:where).with('id != ? and director = ?',@m.id,@m.director).and_return(@movies_mock)
      Movie.find_similar_movies(@m.id)
    end
    
    context "if data found" do
      it "should return correct data" do
        directors = Movie.select(:director).where(director: @m.director).map{|t| t.director}.uniq
        directors.size.should == 1
        directors.first == @m.director
      end
    end
    
    context "if data not found" do
      it "should return nothing" do
        Movie.find_similar_movies(0).should be_empty
      end 
    end
  end
end
