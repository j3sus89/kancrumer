# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :userStory1, class: UserStory do
    title "User_Story 1"
    code "AB1"
    description "This is about the user_story1"
    state 0
    verticalOrder 0
    effort 3
    priority "Low"
    responsibles []
  end

  factory :userStory2, class: UserStory do
  	title "User_Story 2"
    code "CD2"
    description "This is about the user_story2"
    state 0
    verticalOrder 0
    effort 3
    priority "Low"
  end

  factory :userStory_with, class: UserStory do
    title "User_Story 2"
    code "AE4"
    description "This is about the user_story2"
    state 0
    verticalOrder 0
    effort 3
    priority "Low"
    comments {}
  end

end