require 'rails_helper'

feature 'User if he is question owner can choose one best answer', %q{
  If user is owner of a question he can choose one best answer for question
} do

  given!(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users.first) }
  given!(:reward) { create(:reward, question: question) }
  given!(:answer) { create(:answer, question: question, user: users.first) }

  scenario 'Unauthenticated user can not see button mark_as_best' do
    visit question_path(question)

    expect(page).to_not have_link 'Mark as best'
  end

  describe 'Authenticated user' do
    scenario 'is question owner and choose best answer', js: true do
      sign_in(users.first)
      visit question_path(question)

      click_on 'Mark as best'

      expect(page).to have_css('.best-of-the-best')
    end

    scenario 'choose best answer in alien question' do
      sign_in(users.second)
      visit question_path(question)

      expect(page).to_not have_button('Mark as best')
    end
  end
end