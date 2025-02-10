class Async::Logs::LogViewModel < Async::BaseViewModel
  include LogColorsHelper
  expects :loggable_type, :loggable_id

  def loggable
    loggable_type = params[:loggable_type]
    loggable_id = params[:loggable_id]

    if loggable_type == "AddOn"
      current_user.add_ons.find(loggable_id)
    elsif loggable_type == "Build"
      current_user.builds.find(loggable_id)
    elsif loggable_type == "Cluster"
      current_user.clusters.find(loggable_id)
    elsif loggable_type == "Deployment"
      current_user.deployments.find(loggable_id)
    else
      raise "Unknown loggable type: #{loggable_type}"
    end
  end

  def async_render
    template = <<-HTML
    <div
      class="bg-gray-900 text-gray-100 rounded-lg shadow-lg"
      data-controller="logs"
      data-logs-loggable-id-value="<%= loggable.id %>"
    >
      <div class="overflow-auto h-96 bg-gray-800 p-2 rounded" data-logs-target="container" data-action="scroll->logs#updateScroll">
        <pre class="text-sm font-mono whitespace-pre-wrap"><%= ansi_to_tailwind(loggable.log_output&.output || "Your logs will appear here...").html_safe %></pre>
      </div>
    </div>
    HTML

    ERB.new(template).result(binding)
  end

  def render_error
    "<div class='text-yellow-500'>Error fetching logs.</div>"
  end

  def initial_render
    "<div class='loading loading-spinner loading-sm'></div>"
  end
end
