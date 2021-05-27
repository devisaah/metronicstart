class Admin::NoticiasController < AdminController
  layout 'cruds'

  before_action :set_noticia, only: [:show, :edit, :update, :destroy, :ativar, :desativar]
  load_and_authorize_resource

  # GET /noticias
  def index
    unless request.format.in?(['html', 'js'])
      @noticias = Noticia.all
    end
    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  # GET /noticias/1
  def show
  end

  # GET /noticias/new
  def new
    @noticia = Noticia.new(noticia_params)
    @noticia.autor = Usuario.current 
  end

  # GET /noticias/1/edit
  def edit
  end

  # POST /noticias
  def create
    @noticia = Noticia.new(noticia_params)
    notice = 'Noticia cadastrado(a) com sucesso.'
    respond_to do |format|
      if @noticia.save
        location = [@noticia]
        location.unshift(params[:controller].split("/")[0].to_sym) if params[:controller].split("/").length > 1
        format.html { redirect_to location, notice: notice}
        format.json { render :show, status: :created, location: @noticia }
        format.js { flash[:notice] = notice}
      else
        format.html { render :new }
        format.json { render json: @noticia.errors, status: :unprocessable_entity }
        format.js { render :new }
      end
    end
  end

  # PATCH/PUT /noticias/1
  def update
    notice = 'Noticia alterado(a) com sucesso.'
    respond_to do |format|
      if @noticia.update(noticia_params)
        location = [@noticia]
        location.unshift(params[:controller].split("/")[0].to_sym) if params[:controller].split("/").length > 1
        format.html { redirect_to location, notice: notice }
        format.json { render :show, status: :ok, location: location }
        format.js { flash[:notice] = notice}
      else
        format.html { render :edit }
        format.json { render json: @noticia.errors, status: :unprocessable_entity }
        format.js { render :edit }
      end
    end
  end

  # DELETE /noticias/1
  def destroy
    @noticia.destroy
    notice = 'Noticia removido(a) com sucesso.'
    respond_to do |format|
      format.html { redirect_to params[:controller].split("/").map(&:to_sym), notice: notice }
      format.json { head :no_content }
      format.js { flash[:notice] = notice}
    end
  end

  def datatable
    respond_to do |format|
      format.json { render json: NoticiasDatatable.new(view_context) }
    end
  end

  def search
    respond_to do |format|
      format.json { render json: Noticia.search(params[:search])  }
    end
  end

  def ativar
    @noticia.ativo = true
    @noticia.save
  end

  def desativar
    @noticia.ativo = false
    @noticia.save
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_noticia
      @noticia = Noticia.friendly.find(params[:id])
    end

  # Never trust parameters from the scary internet, only allow the white list through.
  def noticia_params
    if params[:noticia]
      params.require(:noticia).permit(:titulo, :titulobreve, :descricaobreve, :descricao, :imagem, :remove_imagem, :autor_id, :ativo)
    end
  end
  
  
end
