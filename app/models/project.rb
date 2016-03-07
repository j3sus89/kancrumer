class Project
  include Mongoid::Document
  field :name, type: String
  field :scrumMaster, type: BSON::ObjectId
  field :productOwner, type: BSON::ObjectId
  field :description, type: String

  has_and_belongs_to_many :users, after_add: :darBienvenida, after_remove: :causarBaja


  after_update :sendEmailIfChanges
  after_create :sendEmailNewProject


  
  embeds_many :sprints do
    def find_by_order(n)
      where(order: n).first
    end
  end

  validates :name, presence: true
  validates :scrumMaster, presence: true
  validates :productOwner, presence: true

  attr_reader :scrumMember


  def darBienvenida(user)
    if !user.eql?(User.find(productOwner)) and !user.eql?(User.find(scrumMaster))
      UserMailer.new_scrumMember(user, self).deliver
    end
  end



  def causarBaja(user)
    if !user.eql?(User.find(productOwner)) and !user.eql?(User.find(scrumMaster))
      UserMailer.reject_scrumMember(user, self).deliver
    end
    self.deleteFromUserStories(user)
    user.project_ids.delete(self.id)
    user.save
  end



  def getScrumMaster
  	User.find(scrumMaster)
  end



  def getProductOwner
  	User.find(productOwner)
  end


 
  def scrumMember=(ids) 
    if ids!=""
      nueva = ids +","+User.find(productOwner).email+","+User.find(scrumMaster).email
    else
      nueva = User.find(productOwner).email+","+User.find(scrumMaster).email
    end

    self.users.each do |u|
      if !nueva.include?(User.find(u).email)
        self.users.delete(User.find(u))
      end
    end 

    nueva.split(",").each do |e|
        aux = User.where(email: e)
        if !self.users.include?(User.find(aux))
          self.users << aux
        end
    end
  end



  def getDevelopers
    developers = []
    user_ids.each do |f|
      if !f.eql?(self.scrumMaster) and !f.eql?(self.productOwner)
        developers << User.find(f).as_json(only: [:email, :name])
      end
    end
    developers.to_json
  end



  def isScrumMaster?(person)
    aux = false
    if self.scrumMaster.eql?(person.id)
      aux = true
    end
    return aux
  end



  def isScrumMasterOrProductOwner?(person)
    aux = false
    if self.scrumMaster.eql?(person.id) or self.productOwner.eql?(person.id)
      aux = true
    end
    return aux
  end



  def belongsToProject?(person)
    aux = false
    if isScrumMasterOrProductOwner?(person)
      aux = true
    else
      user_ids.each do |u|
        if u.eql?(person.id)
          aux = true
          break
        end
      end
    end
    return aux
  end



  def sendEmailNewProject
      aux = User.find(self.scrumMaster)
      aux.project_ids << self.id
      aux.save
      UserMailer.new_project(self).deliver
      if !self.productOwner.eql?(self.scrumMaster)
        aux = User.find(self.productOwner)
        aux.project_ids << self.id
        aux.save
      end
      UserMailer.new_productOwner(self).deliver
  end



  def sendEmailIfChanges
    if scrumMaster_changed?
      UserMailer.reject_scrumMaster(User.find(self.changes["scrumMaster"][0]), self).deliver
      UserMailer.new_scrumMaster(self).deliver
    end
    if productOwner_changed?
      UserMailer.reject_productOwner(User.find(self.changes["productOwner"][0]), self).deliver
      UserMailer.new_productOwner(self).deliver
    end
  end



  def deleteFromComments(person)
    sprints.each do |s|
      s.user_stories.each do |us|
        us.comments.each do |c|
          if c!=nil and c.user.eql?(person)
            c.setUserToNil
          end
        end 
      end
    end
  end



  def deleteFromUserStories(person)
    self.sprints.each do |s|
      s.user_stories.each do |us|
        aux = User.find(person).email
        if us.responsibles.include?(aux)
          us.responsibles.delete(aux)
        end
      end
    end
  end

end
