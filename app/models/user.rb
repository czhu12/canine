class User < ApplicationRecord
  has_prefix_id :user

  include Accounts
  include Agreements
  include Authenticatable
  include Mentions
  include Notifiable
  include Searchable
  include Theme

  has_one_attached :avatar
  has_person_name

  validates :avatar, resizable_image: true
  validates :name, presence: true
  has_many :clusters, dependent: :destroy
  has_many :projects, through: :clusters
  has_one :docker_hub_credential, dependent: :destroy
end
