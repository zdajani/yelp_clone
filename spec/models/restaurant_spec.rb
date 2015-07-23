require 'spec_helper'

describe Restaurant, :type => :model do
  it { is_expected.to have_many :reviews }
  
  before do
    user = User.create email: 'fake@gmail.com', password: '12345678', password_confirmation: '12345678'
    user.restaurants.create(name: 'Nandos')
  end

  it 'is not valid with a name of less than three characters' do
    restaurant = Restaurant.new(name: 'Na')
    expect(restaurant).to have(1).error_on(:name)
    expect(restaurant).not_to be_valid
  end

  it 'is not valid unless it has a unique name' do
    restaurant = Restaurant.new(name: 'Nandos')
    expect(restaurant).to have(1).error_on(:name)
  end
  
  
  it 'can only be deleted by the user who created it' do
    nandos = Restaurant.find_by(name: 'Nandos')
    current_user = User.find_by(email: 'fake@gmail.com')
    nandos.destroy_as current_user
    expect(Restaurant.find_by(name: 'Nandos')).to be nil
  end

  it 'cannot be deleted by a user other then the one who created it' do 
    nandos = Restaurant.find_by(name: 'Nandos')
    user2 = User.create email: 'fake2@gmail.com', password: '12345678', password_confirmation: '12345678'
    expect(nandos.destroy_as user2).to be false
  end
end

describe 'reviews' do
  describe 'build_with_user' do

    let(:user) { User.create email: 'test@test.com' }
    let(:restaurant) { Restaurant.create name: 'Test' }
    let(:review_params) { {rating: 5, thoughts: 'yum'} }

    subject(:review) { restaurant.reviews.build_with_user(review_params, user) }

    it 'builds a review' do
      expect(review).to be_a Review
    end

    it 'builds a review associated with the specified user' do
      expect(review.user).to eq user
    end
  end
end