class Question < ActiveRecord::Base
  self.primary_key  = "id"
  has_many :tags, foreign_key: :id_question
end
