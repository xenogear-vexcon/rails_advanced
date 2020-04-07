require 'rails_helper'

feature 'User can see all question', %q{ All users can see list of questions } do

  given(:user) {create(:user)}
  given!(:questions) {create_list(:question, 2)}

  background { visit questions_path }

  scenario 'Authenticated user can see list of questions' do
    sign_in(user)

    questions.each do |question|
      expect(page).to have_content("#{question.title}")
      expect(page).to have_content("#{question.body}")
    end
  end

  scenario 'Unauthenticated user can see list of questions' do
    questions.each do |question|
      expect(page).to have_content("#{question.title}")
      expect(page).to have_content("#{question.body}")
    end
  end
end