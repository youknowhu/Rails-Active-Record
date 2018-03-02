class CreateAnswerChoicesTable < ActiveRecord::Migration[5.1]
  def change
    create_table :answer_choices do |t|
      t.integer :question_id
      t.text :answer_choice
      t.timestamps
    end
  end
end
