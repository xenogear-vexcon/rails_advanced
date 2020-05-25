require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of the question
  I'd like to be able to edit my question
} do

  given!(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users.first) }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user' do
    describe 'edit own question', js: true do

      background do
        sign_in(users.first)
        visit question_path(question)
        click_on 'Edit question'
      end

      scenario 'without errors' do
        within '.question' do
          fill_in 'Title', with: 'edited question title'
          fill_in 'Body', with: 'edited body'
          click_on 'Confirm'

          expect(page).to_not have_content question.title
          expect(page).to_not have_content question.body
          expect(page).to have_content 'edited question title'
          expect(page).to have_content 'edited body'
          expect(page).to_not have_selector 'textfield'
        end
      end

      scenario 'with errors' do
        fill_in 'Title', with: ''
        save_and_open_page
        click_on 'Confirm'

        expect(page).to have_content "Title can't be blank"
      end
    end

    scenario "tries to edit other user's question" do
      sign_in(users.second)
      visit question_path(question)

      expect(page).to_not have_link 'Edit question'
    end
  end
end