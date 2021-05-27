class Admin::ConfiguracoesController < AdminController
    layout 'cruds' 

    before_action :set_configuracao, only: [:edit, :update]
    load_and_authorize_resource

    # GET /configuracoes/1/edit
    def edit
        if @configuracao.empresa.nil? 
            @empresa = @configuracao.build_empresa
            @empresa.contatos << Contato.new 
            @empresa.redes_sociais << RedeSocial.new 
        else
          @empresa = @configuracao.empresa
          @empresa.contatos << Contato.new if @empresa.contatos.blank? 
          @empresa.redes_sociais << RedeSocial.new  if @empresa.redes_sociais.blank?
        end
    end

    # PATCH/PUT /configuracoes/1
    def update
        notice = 'Configuração alterado(a) com sucesso.'
        respond_to do |format|
        if @configuracao.update(configuracao_params)
            location = [@configuracao]
            location.unshift(params[:controller].split("/")[0].to_sym) if params[:controller].split("/").length > 1
            format.html { redirect_to edit_configuracao_url, notice: notice }
            format.json { render :show, status: :ok, location: location }
            format.js { flash[:notice] = notice}
        else
            format.html { render :edit }
            format.json { render json: @configuracao.errors, status: :unprocessable_entity }
            format.js { render :edit }
        end
        end
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_configuracao
            @configuracao = Configuracao.find(params[:id])
        end

        def configuracao_params
            if params[:configuracao]
              params.require(:configuracao).permit(
                :metatag_title,
                :metatag_description,
                :metatag_language,
                :metatag_keywords,
                :metatag_author,
                :metatag_robots,
                :metatag_revisitafter,
                :metatag_charset,
                :metatag_ogimage,
                :metatag_ogurl,
                :metatag_ogtype,
                :metatag_googleboot,
                :metatag_tcard,
                :metatag_tsite,
                :metatag_tcreator,
                :remove_sobre_imagem,
                :google_anlytics,
                :adsence_client,
                :google_search_console,
                :adsense_google_responsive,
                :facebook_pixel,
                :termo_de_uso,
                :politica_privacidade,
                :one_signal,
                :onesignal_appid,
                :onesignal_restapi,
                :jivochat,
                :logo_rodape,
                :remove_logo_rodape,
                :sobre, 
                :visao, 
                :missao, 
                :valores,
                :whatsapp_phone,
                :whatsapp_text, 
                :wc_whatsapp_primary,
                :wc_whatsapp_secondary, 
                empresa_attributes: [
                    :id,
                    :razao_social,
                    :nome,
                    :cnpj,
                    :ans,
                    :inscricao_estadual,
                    :inscricao_municipal,
                    :site,
                    :logo,
                    :favicon,
                    :remove_logo,
                    :remove_favicon,
                    endereco_attributes: [
                        :id,
                        :cep,
                        :logradouro,
                        :numero,
                        :bairro,
                        :complemento,
                        :estado_id,
                        :cidade_id,
                        :lat,
                        :lng
                    ],
                    contatos_attributes: [
                        :id,
                        :tipo,
                        :valor,
                        :_destroy
                    ],
                    redes_sociais_attributes: [
                        :id,
                        :tipo,
                        :url,
                        :_destroy
                    ]
                ]
              )
            end
        end

end