require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users.first) }
  given!(:answer) { create(:answer, question: question, user: users.second) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end

  describe 'Authenticated user' do
    describe 'edit his answer', js: true do

      background do
        sign_in(users.second)
        visit question_path(question)
        click_on 'Edit answer'
      end

      scenario 'without errors' do
        within '.answers' do
          fill_in 'Body', with: 'edited answer'
          click_on 'Confirm'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'with errors' do
        within '.answers' do
          fill_in 'Body', with: ''
          click_on 'Confirm'

          expect(page).to have_content "Body can't be blank"
        end
      end
    end

    scenario "tries to edit other user's question" do
      sign_in(users.first)
      visit question_path(question)

      expect(page).to_not have_link 'Edit answer'
    end
  end
end