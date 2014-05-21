class CreateQuestion < ActiveRecord::Migration
  def change
    create_table :questions, :id => false, :primary_key => :id  do |t|
      t.string :id, null: false
      t.text :question
      t.text :answer
      t.text :reference_law
      t.text :excerpt_law
    end
  end
end
