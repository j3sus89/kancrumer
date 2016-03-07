# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  	factory :sprint1, class: Sprint do
    	name "Sprint 1"
    	description "Mi Sprint"
    	startdate "25-01-1989"
    	deadline "20-06-2014"
    	order 1
	end

	factory :sprint2, class: Sprint do
    	name "Sprint 2"
    	description "Second Sprint"
    	startdate "25-01-1989"
    	deadline "20-06-2014"
    	order 1
  	end

    factory :sprint_with, class: Sprint do
        name "Sprint 3"
        description "Another Sprint"
        startdate "25-01-1989"
        deadline "20-06-2014"
        order 1
        user_stories {}
    end


end

