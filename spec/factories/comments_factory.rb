# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :comment1, class: Comment do
    	body 'This is a comment'
    	user '52a779444a657303b9010000'
    	date 'March 17th, 2014 19:44'
  	end
end
