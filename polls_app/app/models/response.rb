# == Schema Information
#
# Table name: responses
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  answer_choice_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Response < ApplicationRecord

  validate :respondent_already_answered?, :respondent_created_poll?

  belongs_to :answer_choice,
  class_name: :AnswerChoice,
  foreign_key: :answer_choice_id,
  primary_key: :id

  belongs_to :respondent,
  class_name: :User,
  foreign_key: :user_id,
  primary_key: :id

  has_one :question,
  through: :answer_choice,
  source: :question

  has_one :poll,
  through: :question,
  source: :poll

  def sibling_responses
    self.question.responses.where.not(id: self.id)
  end

  def respondent_already_answered?
    if sibling_responses.exists?(user_id: self.user_id)
      errors[:body] << "Respondent already answered"
    end
  end

  def respondent_created_poll?
    if self.question.poll.user_id == self.user_id
      errors[:body] << "Respondent can't be author!"
    end
  end
end
