require 'rails_helper'

feature 'reviewing' do
  before do
    @user = User.create email: 'fake@gmail.com', password: '12345678', password_confirmation: '12345678'
    @user.restaurants.create(name: 'Nandos')
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

  scenario 'reviews can be deleted by the user who created them' do
    login_as @user
    visit '/restaurants'
    click_link 'Review Nandos'
    fill_in 'Thoughts', with: 'awesome'
    select '5', from: 'Rating'
    click_button 'Leave Review'
    click_link 'Nandos'
    click_link 'Delete review'
    expect(page).not_to have_content('awesome')
  end
end
