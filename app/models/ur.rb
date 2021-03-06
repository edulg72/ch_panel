class UR < ActiveRecord::Base
  self.table_name = 'vw_ur'
  self.primary_key = 'id'

  belongs_to :commentator, foreign_key: 'last_comment_by', class_name: 'User'
  belongs_to :operator, foreign_key: 'resolved_by', class_name: 'Editor'
  belongs_to :state, foreign_key: 'state_id'

  scope :national, -> { where("state_id is not null") }
  scope :without_comments, -> { where("comments = 0")}
  scope :with_answer, -> { where("comments > 0 and last_comment_by = -1")}
  scope :without_answer, -> { where("comments > 0 and last_comment_by > 0")}
  scope :open, -> { where("resolved_on is null and open")}
  scope :closed, -> { where("resolved_on is not null or not open")}
end
