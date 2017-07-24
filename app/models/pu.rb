class PU < ActiveRecord::Base
  self.table_name = 'vw_pu'

  belongs_to :state, foreign_key: 'state_id'

  scope :national, -> { where("state_id is not null") }
  scope :editable, -> { where("not staff")}
  scope :blocked, -> { where("staff")}
end
