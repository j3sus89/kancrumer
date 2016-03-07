class Comment
  include Mongoid::Document
  field :body, type: String
  field :date, type: String
  field :user, type: BSON::ObjectId
  embedded_in :user_story#, inverse_of: :comments
  
  validates :body, presence: true

  def isAuthor?(person)
    aux = false
    if self.user.eql?(person.id)
      aux = true
    end
    return aux
  end

  def getUser
    User.find(self.user)
  end

  def setUserToNil
    self.user = nil
  end
  
end
