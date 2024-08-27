class Cluster < ApplicationRecord
  broadcasts_refreshes
  belongs_to :user
  has_many :projects, dependent: :destroy
  validates_presence_of :name
end
