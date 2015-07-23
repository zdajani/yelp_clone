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
    # before do
    #   Restaurant.create(name: 'Nandos', user_id:)
    # end

    scenario 'display restaurants' do
      sign_up
      visit '/restaurants'
      expect(page).to have_content('Nandos')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do

    scenario 'does not let you submit a name that is too short' do
      sign_up
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'Na'
      click_button 'Create Restaurant'
      expect(page).not_to have_css 'h2', text: 'Na'
      expect(page).to have_content 'error'
    end

    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      sign_up
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'Nandos'
      click_button 'Create Restaurant'
      expect(page).to have_content 'Nandos'
      expect(current_path).to eq '/restaurants'
    end
  end

    scenario 'a user that is not signed in cannot create a restaurant' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      expect(current_path).not_to eq '/restaurants/new'
    end

  context 'viewing restaurants' do
    let!(:nandos){Restaurant.create(name:'Nandos')}

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'Nandos'
      expect(page).to have_content 'Nandos'
      expect(current_path).to eq "/restaurants/#{nandos.id}"
    end
  end

  context 'editing restaurants' do
    before {Restaurant.create name: 'Nandos'}

    scenario 'let a user edit a restaurant' do
      sign_up
      visit '/restaurants'
      click_link 'Edit Nandos'
      fill_in 'Name', with: 'Nandos awesome chicken'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Nandos'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'do not let a user edit a restaurant if they did not create it' do
      sign_up
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      click_link 'Sign out'
      click_link 'Edit KFC'
      expect(page).to have_content 'You can only edit restaurants which you added'
    end
  end

  context 'deleting restaurants' do
    # before {Restaurant.create name: 'Nandos'}
    scenario 'removes a restaurant when the user who created it clicks ra delete link' do
      sign_up
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'Ippudo'
      click_button 'Create Restaurant'
      click_link 'Delete Ippudo'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    scenario 'does not let a user delete a restaurant which they did not create' do
      sign_up
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'Ippudo'
      click_button 'Create Restaurant'
      click_link 'Sign out'
      visit('/')
      sign_up_other
      click_link('Delete Ippudo')
      expect(page).to have_content 'You can only delete restaurants which you added'
    end
  end


  def sign_up
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')
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
