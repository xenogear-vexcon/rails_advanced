require 'rails_helper'

feature 'User can create answer', %q{
  In order to help community with question
  As an authenticated user
  I'd like to be able to give an answer for a question
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question, user: user)}

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'answer the question' do
      fill_in 'Body', with: 'answer for a question'
      click_on 'Answer'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      within '.answers' do
        expect(page).to have_content 'answer for a question'
      end
    end

    scenario 'answer the question with errors' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer the question', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Answer'
  end
end