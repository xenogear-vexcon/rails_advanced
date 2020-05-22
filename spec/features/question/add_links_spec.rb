require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:image_url) { 'https://badges-2019.s3.eu-west-3.amazonaws.com/loxmhpru0kfl84uhcfzljhvvqrcn' }

  scenario 'User adds link when asks question', js: true do
    sign_in(user)
    visit new_question_path

    within '.question_form' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
    end

    fill_in 'Link name', with: 'My image'
    fill_in 'Url', with: image_url

    click_on 'Confirm'

    expect(page).to have_link 'My image', href: image_url
  end

end