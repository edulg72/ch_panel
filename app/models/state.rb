class State < ActiveRecord::Base

#  has_many :cities, foreign_key: 'state_id', class_name: 'City'
  has_many :urs, foreign_key: 'state_id', class_name: 'UR'
  has_many :mps, foreign_key: 'state_id', class_name: 'MP'
  has_many :pus, foreign_key: 'state_id', class_name: 'PU'
end
