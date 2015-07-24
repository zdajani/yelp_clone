require 'rails_helper'

feature 'restaurants' do

  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before do
      user = User.create email: 'fake@gmail.com', password: '12345678', password_confirmation: '12345678'
      user.restaurants.create(name: 'Nandos')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('Nandos')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    before do
      user = User.create email: 'tansaku@gmail.com', password: '12345678', password_confirmation: '12345678'
      login_as user
    end

    scenario 'does not let you submit a name that is too short' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'Na'
      click_button 'Create Restaurant'
      expect(page).not_to have_css 'h2', text: 'Na'
      expect(page).to have_content 'error'
    end

    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'Nandos'
      click_button 'Create Restaurant'
      expect(page).to have_content 'Nandos'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'a user that is not signed in cannot create a restaurant' do
      visit '/restaurants'
      click_link 'Sign out'
      click_link 'Add a restaurant'
      expect(current_path).not_to eq '/restaurants/new'
    end
  end

  context 'viewing restaurants' do
    before do
      user = User.create email: 'fake@gmail.com', password: '12345678', password_confirmation: '12345678'
      @nandos = user.restaurants.create(name: 'Nandos')
    end

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'Nandos'
      expect(page).to have_content 'Nandos'
      expect(current_path).to eq "/restaurants/#{@nandos.id}"
    end
  end

  context 'editing restaurants' do
    before do
      @user = User.create email: 'fake@gmail.com', password: '12345678', password_confirmation: '12345678'
      @user2 = User.create email: 'fake2@gmail.com', password: '12345678', password_confirmation: '12345678'
      @nandos = @user.restaurants.create(name: 'Nandos')
    end

    scenario 'let a user edit a restaurant' do
      login_as @user
      visit '/restaurants'
      click_link 'Edit Nandos'
      fill_in 'Name', with: 'Nandos awesome chicken'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Nandos'
      expect(current_path).to eq '/'
    end

    scenario 'do not let a user edit a restaurant if they did not create it' do
      login_as @user2
      visit '/'
      click_link 'Edit Nandos'
      expect(page).to have_content 'You can only edit restaurants which you added'
    end
  end

  context 'deleting restaurants' do

    before do
      @user = User.create email: 'tansaku@gmail.com', password: '12345678', password_confirmation: '12345678'
      login_as @user
    end

    before do
      @nandos = @user.restaurants.create(name: 'Nandos')
    end

    scenario 'removes a restaurant when the user who created it clicks delete link' do
      visit '/'
      click_link 'Delete Nandos'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    scenario 'does not let a user delete a restaurant which they did not create' do
      visit('/')
      click_link 'Sign out'
      sign_up_other
      click_link('Delete Nandos')
      expect(page).to have_content 'You can only delete restaurants which you added'
    end
  end

  def sign_up_other
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'k@j.com')
    fill_in('Password', with: 'kjkjkjkj')
    fill_in('Password confirmation', with: 'kjkjkjkj')
    click_button('Sign up')
  end
end
