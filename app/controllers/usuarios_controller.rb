class Admin::UsuariosController < AdminController
  layout 'cruds'

  before_action :set_usuario, only: [:show, :edit, :update, :destroy, :edit_password, :update_password, :edit_permission, :update_permission, :ativar, :desativar]
  load_and_authorize_resource

  # GET /usuarios
  def index
    unless request.format.in?(['html', 'js'])
      @usuarios = Usuario.all
    end
    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  # GET /usuarios/1
  def show
  end

  # GET /usuarios/new
  def new
    @usuario = Usuario.new(usuario_params)
  end

  # GET /usuarios/1/edit
  def edit
  end

  # POST /usuarios
  def create
    @usuario = Usuario.new(usuario_params)
    notice = 'Usuário cadastrado(a) com sucesso.'
    respond_to do |format|
      if @usuario.save
        location = [@usuario]
        location.unshift(params[:controller].split("/")[0].to_sym) if params[:controller].split("/").length > 1
        format.html { redirect_to location, notice: notice}
        format.json { render :show, status: :created, location: @usuario }
        format.js { flash[:notice] = notice}
      else
        format.html { render :new }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
        format.js { render :new }
      end
    end
  end

  # PATCH/PUT /usuarios/1
  def update
    notice = 'Usuário alterado(a) com sucesso.'
    respond_to do |format|
      if @usuario.update(usuario_params)
        location = [@usuario]
        location.unshift(params[:controller].split("/")[0].to_sym) if params[:controller].split("/").length > 1
        format.html { redirect_to location, notice: notice }
        format.json { render :show, status: :ok, location: location }
        format.js { flash[:notice] = notice}
      else
        format.html { render :edit }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
        format.js { render :edit }
      end
    end
  end

  # DELETE /usuarios/1
  def destroy
    @usuario.destroy
    notice = 'Usuário removido(a) com sucesso.'
    respond_to do |format|
      format.html { redirect_to params[:controller].split("/").map(&:to_sym), notice: notice }
      format.json { head :no_content }
      format.js { flash[:notice] = notice}
    end
  end

  def datatable
    respond_to do |format|
      format.json { render json: UsuariosDatatable.new(view_context) }
    end
  end

  def search
    respond_to do |format|
      format.json { render json: Usuario.search(params[:search]) }
    end
  end

  def edit_password
  end

  def update_password
    respond_to do |format|
      if @usuario.update_with_password(password_params)
        format.js { flash[:notice] = 'Senha atualizada com sucesso.' }
      else
        format.js { render :edit_password }
      end
    end
  end

  def ativar
    @usuario.ativo = true
    @usuario.save
  end

  def desativar
    @usuario.ativo = false
    @usuario.save
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_usuario
    @usuario = Usuario.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def usuario_params
    if params[:usuario]
      params.require(:usuario).permit(
          :nome,
          :email,
          :username,
          :foto,
          :ativo,
          :password,
          :password_confirmation,
          :permissao_id
      )
    end
  end

  def password_params
    if params[:usuario]
      params.require(:usuario).permit(
          :current_password,
          :password,
          :password_confirmation
      )
    end
  end


end
