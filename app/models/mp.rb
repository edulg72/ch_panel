class MP < ActiveRecord::Base
  self.table_name = 'vw_mp'

  belongs_to :operator, foreign_key: 'resolved_by', class_name: 'Editor'
  belongs_to :state, foreign_key: 'state_id'

  scope :national, -> { where("state_id is not null") }
  scope :open, -> { where("resolved_on is null")}
  scope :closed, -> { where("resolved_on is not null")}
end
