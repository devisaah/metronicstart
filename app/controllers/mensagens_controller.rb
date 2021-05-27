class Admin::MensagensController < AdminController
  layout 'cruds'
  
  before_action :set_mensagem, only: [:show, :responder, :respondido]
  load_and_authorize_resource
  
    # GET /mensagens
    def index
      unless request.format.in?(['html', 'js'])
        @mensagens = Mensagem.all
      end
      respond_to do |format|
        format.html
        format.json
        format.js
      end
    end
  
    # GET /mensagens/1
    def show
    end
  
    
    def responder 
      @mensagem.respondido = true 
    end
  
    # PATCH/PUT /mensagens/1/respondido
    def respondido
      notice = 'Mensagem respondida com sucesso.'
      respond_to do |format|
        if @mensagem.update(mensagem_params)
          MensagemMailer.resposta_mensagem(@mensagem).deliver_later!
          @mensagens = Mensagem.where(respondido: [false, nil]) 
          location = [@mensagem]
          location.unshift(params[:controller].split("/")[0].to_sym) if params[:controller].split("/").length > 1
          format.html { redirect_to location, notice: notice }
          format.json { render :show, status: :ok, location: location }
          format.js { flash[:notice] = notice}
        else
          format.html { render :edit }
          format.json { render json: @mensagem.errors, status: :unprocessable_entity }
          format.js { render :edit }
        end
      end
    end
  
    def datatable
      respond_to do |format|
        format.json { render json: MensagensDatatable.new(view_context) }
      end
    end
  
    def search
      respond_to do |format|
        format.json { render json: Mensagem.search(params[:search])  }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_mensagem
        @mensagem = Mensagem.find(params[:id])
      end
  
    # Never trust parameters from the scary internet, only allow the white list through.
    def mensagem_params
      if params[:mensagem]
        params.require(:mensagem).permit(
          :nome, 
          :telefone,
          :assunto,
          :email,
          :texto,
          :respondido, 
          :resposta
        )
      end
    end
  
  
end
