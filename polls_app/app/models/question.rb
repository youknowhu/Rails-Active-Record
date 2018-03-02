# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  question   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  poll_id    :integer
#

class Question < ApplicationRecord

  has_many :answer_choices,
  class_name: :AnswerChoice,
  foreign_key: :question_id,
  primary_key: :id

  belongs_to :poll,
  class_name: :Poll,
  foreign_key: :poll_id,
  primary_key: :id

  has_many :responses,
  through: :answer_choices,
  source: :responses

  def results
    choices = self.answer_choices.includes(:responses)

    results = Hash.new(0)

    choices.each do |choice|
      results[choice.answer_choice] = choice.responses.length
    end

    results
  end

  def results_sql
    choices = Question
      .select('answer_choices.*, COUNT(responses.id) as response_count')
      .left_outer_joins(:responses)
      .where(id: self.id)
      .group('answer_choices.id')
      .order('response_count DESC')

    result = Hash.new(0)
    choices.each do |choice|
      result[choice.answer_choice] = choice.response_count
    end
    results
  end

end
