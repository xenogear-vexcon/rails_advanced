require 'rails_helper'

feature 'User can create answer', %q{
  In order to help community with question
  As an authenticated user
  I'd like to be able to give an answer for a question
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question)}

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_link 'Show'
    end

    scenario 'answer the question' do
      fill_in 'Body', with: 'answer for a question'
      click_on 'Answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'MyString'
      expect(page).to have_content 'MyText'
      expect(page).to have_content 'answer for a question'
    end

    scenario 'answer the question with errors' do
      click_on 'Answer'

      expect(page).to have_content "Answer can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit questions_path
    click_link 'Show'
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end