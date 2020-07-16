require 'rails_helper'

feature 'It can delete comment. ' do
  given!(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users.first) }
  given!(:answer) { create(:answer, question: question, user: users.second) }
  given!(:comment) { create(:comment, commentable: question, user_id: users.first.id) }
  given!(:comment2) { create(:comment, commentable: answer, user_id: users.second.id) }

  describe 'Authenticated user', js: true do
    background do
      Capybara.using_session('user') do
        sign_in(users.first)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end
    end

    scenario 'can see delete button' do
      Capybara.using_session('user') do
        within ".question_#{question.id}_comments" do
          expect(page).to have_selector(:link_or_button, 'Delete')
        end
      end
    end

    scenario 'guest can not see delete button' do
      Capybara.using_session('guest') do
        within ".question_#{question.id}_comments" do
          expect(page).to_not have_selector(:link_or_button, 'Delete')
        end
      end
    end

    scenario 'can delete only own comment' do
      Capybara.using_session('user') do
        within ".question_#{question.id}_comments" do
          click_link 'Delete'

          expect(page).to_not have_content "#{comment.body}"
        end
        within ".answer_#{answer.id}_comments" do
          expect(page).to have_content "#{comment2.body}"
        end
      end
    end

    scenario 'can not delete allien comment' do
      Capybara.using_session('user') do
        within ".answer_#{answer.id}_comments" do
          expect(page).to_not have_selector(:link_or_button, 'Delete')
        end
      end
    end
  end
end
