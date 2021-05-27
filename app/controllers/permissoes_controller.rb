class Admin::PermissoesController < AdminController
  layout 'cruds'

  before_action :set_permissao, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /permissoes
  def index
    unless request.format.in?(['html', 'js'])
      @permissoes = Permissao.all
    end
    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end
  
  # GET /permissoes/1
  def show
  end

  # GET /permissoes/new
  def new
    @permissao = Permissao.new(permissao_params)
    @permissao.permissao_itens << PermissaoItem.new 
  end
  
  # GET /permissoes/1/edit
  def edit
  end

  # POST /permissoes
  def create
    @permissao = Permissao.new(permissao_params)
    notice = 'Permissão cadastrado(a) com sucesso.'
    respond_to do |format|
      if @permissao.save
        location = [@permissao]
        location.unshift(params[:controller].split("/")[0].to_sym) if params[:controller].split("/").length > 1
        format.html { redirect_to location, notice: notice}
        format.json { render :show, status: :created, location: @permissao }
        format.js { flash[:notice] = notice}
      else
        format.html { render :new }
        format.json { render json: @permissao.errors, status: :unprocessable_entity }
        format.js { render :new }
      end
    end
  end
  
  # PATCH/PUT /permissoes/1
  def update
    notice = 'Permissão alterado(a) com sucesso.'
    respond_to do |format|
      if @permissao.update(permissao_params)
        location = [@permissao]
        location.unshift(params[:controller].split("/")[0].to_sym) if params[:controller].split("/").length > 1
        format.html { redirect_to location, notice: notice }
        format.json { render :show, status: :ok, location: location }
        format.js { flash[:notice] = notice}
      else
        format.html { render :edit }
        format.json { render json: @permissao.errors, status: :unprocessable_entity }
        format.js { render :edit }
      end
    end
  end
  
  # DELETE /permissoes/1
  def destroy
    @permissao.destroy
    notice = 'Permissão removido(a) com sucesso.'
    respond_to do |format|
      format.html { redirect_to params[:controller].split("/").map(&:to_sym), notice: notice }
      format.json { head :no_content }
      format.js { flash[:notice] = notice}
    end
  end

  def datatable
    respond_to do |format|
      format.json { render json: PermissoesDatatable.new(view_context) }
    end
  end

  def search
    respond_to do |format|
      format.json { render json: Permissao.search(params[:search])  }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_permissao
      @permissao = Permissao.find(params[:id])
    end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def permissao_params
    if params[:permissao]
          params.require(:permissao).permit(
              :descricao,
              permissao_itens_attributes: [
                  :id,
                  :sistema,
                  :acesso,
                  :_destroy
              ]
          )
    end
  end
  
  
end
