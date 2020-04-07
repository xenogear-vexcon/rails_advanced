FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { '12345678' }
    password_confirmation { '12345678' }
  end

  factory :question do
    user
    sequence(:title) { |n| "Title for question #{n}" }
    sequence(:body) { |n| "Question body № #{n}" }
    
    trait :invalid do
      title { nil }
    end

    factory :question_with_answers do
        transient do
          answers_count { 5 }
        end

        after(:create) do |question, evaluator|
          create_list(:answer, evaluator.answers_count, question: question)
        end
    end
  end

  factory :answer do
    question
    user
    sequence(:body) { |n| "Answer body № #{n}" }
    
    trait :invalid do
      body { nil }
    end
  end
end