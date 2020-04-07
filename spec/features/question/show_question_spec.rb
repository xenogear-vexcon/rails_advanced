require 'rails_helper'

feature 'User can see a question and answers if exist', %q{ All users can see any question with existing answers } do

  given(:user) {create(:user)}
  given!(:question) {create(:question_with_answers)}
  given!(:answers) { question.answers }

  scenario 'Authenticated user can see a question with answers' do
    sign_in(user)
    visit(question_path(question))

    expect(page).to have_content("#{question.title}")
    expect(page).to have_content("#{question.body}")
    answers.each { |answer| expect(page).to have_content("#{answer.body}") }
  end

  scenario 'Unauthenticated user can see a question with answers' do
    visit(question_path(question))

    expect(page).to have_content("#{question.title}")
    expect(page).to have_content("#{question.body}")
    answers.each { |answer| expect(page).to have_content("#{answer.body}") }
  end
end