# == Schema Information
#
# Table name: metrics
#
#  id          :bigint           not null, primary key
#  metadata    :jsonb            not null
#  metric_type :integer          default("cpu"), not null
#  tags        :jsonb            not null, is an Array
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  cluster_id  :bigint           not null
#
# Indexes
#
#  index_metrics_on_cluster_id  (cluster_id)
#
class Metric < ApplicationRecord
  belongs_to :cluster
  enum metric_type: {
    cpu: 0,
    memory: 1,
    storage: 2
  }
end