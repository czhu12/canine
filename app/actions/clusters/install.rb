class Clusters::Install
  extend LightService::Organizer

  def self.call(cluster)
    cluster.installing!
    result = with(cluster:).reduce(
      Clusters::IsReady,
      Clusters::InstallCertManager,
    )
    cluster.running! if result.success?
    cluster.failed! if result.failure?
  rescue StandardError => e
    cluster.failed!
    raise e
  end
end