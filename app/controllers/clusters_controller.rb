class ClustersController < ApplicationController
  before_action :set_cluster, only: [:show, :edit, :update, :destroy]

  # GET /clusters
  def index
    @pagy, @clusters = pagy(current_user.clusters.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @clusters
  end

  # GET /clusters/1 or /clusters/1.json
  def show
  end

  # GET /clusters/new
  def new
    @cluster = Cluster.new

    # Uncomment to authorize with Pundit
    # authorize @cluster
  end

  # GET /clusters/1/edit
  def edit
  end

  # POST /clusters or /clusters.json
  def create
    @cluster = current_user.clusters.new(cluster_params)

    # Uncomment to authorize with Pundit
    # authorize @cluster

    respond_to do |format|
      if @cluster.save
        format.html { redirect_to @cluster, notice: "Cluster was successfully created." }
        format.json { render :show, status: :created, location: @cluster }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cluster.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clusters/1 or /clusters/1.json
  def update
    respond_to do |format|
      if @cluster.update(cluster_params)
        format.html { redirect_to @cluster, notice: "Cluster was successfully updated." }
        format.json { render :show, status: :ok, location: @cluster }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cluster.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clusters/1 or /clusters/1.json
  def destroy
    @cluster.destroy!
    respond_to do |format|
      format.html { redirect_to clusters_url, status: :see_other, notice: "Cluster was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cluster
    @cluster = current_user.clusters.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @cluster
  rescue ActiveRecord::RecordNotFound
    redirect_to clusters_path
  end

  # Only allow a list of trusted parameters through.
  def cluster_params
    kubeconfig_json = params[:cluster][:kubeconfig]
    params[:cluster][:kubeconfig] = JSON.parse(kubeconfig_json) if kubeconfig_json.present?

    params.require(:cluster).permit(:name, :kubeconfig)

    # Uncomment to use Pundit permitted attributes
    # params.require(:cluster).permit(policy(@cluster).permitted_attributes)
  end
end
