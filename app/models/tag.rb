class Tag < ActiveRecord::Base
  belongs_to :question, foreign_key: :id_question
end
