# == Schema Information
#
# Table name: domains
#
#  id          :bigint           not null, primary key
#  domain_name :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  service_id  :bigint           not null
#
# Indexes
#
#  index_domains_on_service_id  (service_id)
#
# Foreign Keys
#
#  fk_rails_...  (service_id => services.id)
#
class Domain < ApplicationRecord
  belongs_to :project
  has_one :cluster, through: :project
  validates :domain_name, presence: true, uniqueness: { scope: :project_id }
  validate :domain_name_has_tld
  before_save :downcase_domain_name
  before_save :strip_protocol

  private

  def domain_name_has_tld
    errors.add(:domain_name, "is not valid") unless domain_name.split(".").length > 1
  end

  def downcase_domain_name
    self.domain_name = domain_name.downcase
  end

  def strip_protocol
    self.domain_name = domain_name.gsub(/^https?:\/\//, "")
  end
end
