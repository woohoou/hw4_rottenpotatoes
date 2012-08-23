require 'spec_helper'
require 'debugger'

describe MoviesController do

  describe "Find Similar Movies" do
    before :each do
      @movies_mock = []      
      @movies_mock << FactoryGirl.create(:movie, id: 1, title: 'Milk', rating: 'R', director: 'George Lucas')
      @movies_mock << FactoryGirl.create(:movie, id: 2, title: 'Spiderman', rating: 'GR', director: 'Another Director')
      @movies_mock << FactoryGirl.create(:movie, id: 3, title: 'Milk 2', rating: 'R', director: 'George Lucas')
      
      @m = @movies_mock.first
    end
    
    it "returns http success" do
      Movie.stub(:find_similar_movies).with("#{@m.id}").and_return(@movies_mock)
      get 'similar', id: @m.id
      response.should be_success
    end
    
    it "should call model method that perform find similar movies" do
      Movie.should_receive(:find_similar_movies).with("#{@m.id}").and_return(@movies_mock)
      get 'similar', id: @m.id
    end
    
    context "after call method" do
      context "found movies" do
        before (:each) do
          Movie.stub(:find_similar_movies).with("#{@m.id}").and_return(@movies_mock)
          get 'similar', {id: @m.id}
        end
        
        it "should make available movies for the view" do
          assigns(:movies).should == @movies_mock
        end
        
        it "should render to index" do
          response.should render_template('similar')
        end    
      end
      
      context "not found movies" do
        before (:each) do
          Movie.stub(:find_similar_movies).with("#{@m.id}").and_return([])
          get 'similar', {id: @m.id}
        end
        
        it "should make available warning to the view" do
          flash[:notice].should be_present
        end
        
        it "should render to home" do
          response.should redirect_to(root_path)
        end
      end
    end
  end

end
