class UserStory
  include Mongoid::Document
  field :title, type: String
  field :description, type: String
  field :state, type: Integer
  field :verticalOrder, type: Integer
  field :responsibles, type: Array
  field :effort, type: Integer
  field :priority, type: String
  field :code, type: String
  

  attr_reader :us_resp

  embeds_many :comments
  embedded_in :sprint, inverse_of: :user_stories
  accepts_nested_attributes_for :comments
  
  validates :code, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates_numericality_of :state
  validates_numericality_of :effort
  validates_numericality_of :verticalOrder

  after_update :checkResponsibles
  after_create :setNew

  def setNew
    self.responsibles = Array.new
    self.sprint.project.save
  end



  def us_resp=(ids)
    self.responsibles=[]
    ids.split(",").each do |e|
        self.responsibles << e
    end
  end



  def getResponsibles
    developers = []
    if responsibles!=nil
     responsibles.each do |f|
      id = User.where(email: f)
       developers << User.find(id).as_json(only: [:email, :name])
     end
   end
    developers.to_json
  end



    def checkResponsibles
    if self.responsibles_changed?
      filtro = []
      self.responsibles.each do |u|
        usuario = User.find(User.where(email: u))._id
        quitar = true
        self.sprint.project.user_ids.each do |r|
          if r.eql?(usuario)
            filtro << u
          end
        end
      end
      self.responsibles = filtro
      self.sprint.project.save
    end
  end


end