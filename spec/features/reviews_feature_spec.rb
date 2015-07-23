require 'rails_helper'

feature 'reviewing' do
  before do
    user = User.create email: 'tansaku@gmail.com', password: '12345678', password_confirmation: '12345678'
    user.restaurants.create(name: 'Nandos')
  end

  scenario 'allows users to leave a review using a form' do
    visit '/restaurants'
    click_link 'Review Nandos'
    fill_in 'Thoughts', with: 'awesome'
    select '5', from: 'Rating'
    click_button 'Leave Review'

    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('awesome')
  end
end