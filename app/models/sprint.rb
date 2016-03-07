class Sprint
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :startdate, type: String
  field :deadline, type: String
  field :order, type: Integer

  validates_presence_of :name
  validates_numericality_of :order
  validates_format_of :deadline, with: /\A(\d{2})-(\d{2})-(\d{4})\z/, message: "must be like DD-MM-YYYY"
  validates_format_of :startdate, with: /\A(\d{2})-(\d{2})-(\d{4})\z/, message: "must be like DD-MM-YYYY"
  embedded_in :project, inverse_of: :sprints
  
  embeds_many :user_stories do
    def find_by_state(n)
      where(state: n).order_by(:verticalOrder.asc)
    end
  end


  def setNew
  	self.order = project.sprints.count + 1
  	self.save
  end


  def changeOrder
  	project.sprints.each do |sp| 
    	if sp.order > self.order 
    		aux = sp.order - 1
          	sp.order = aux  
          	sp.save     
        end
    end
  end

  def getCompleteness
    total = self.user_stories.count
    completed = 0
    ret = 0
    self.user_stories.each do |f|
      if f.state == 3
        completed = completed + 1;
      end
    end
    if completed!=0 and total!=0 
      ret = (completed*100)/total
    end

    return ret
  end

end
