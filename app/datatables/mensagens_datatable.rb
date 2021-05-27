class MensagensDatatable
  delegate :params, :h, :t, :link_to, :content_tag, :mensagem_path, :edit_mensagem_path, :responder_mensagem_path,  to: :@view
  include EnumI18nHelper

  def initialize(view)
    @view = view
    @remote = params[:remote] == 'true'
  end

  def as_json(options = {})
    {
        draw: params[:draw].to_i,
        recordsTotal: total,
        recordsFiltered: mensagens.total_count,
        data: data
    }
  end

  private
  def data
    mensagens.each_with_index.map do |mensagem, index|
      {
        "index" => (index + 1) + ((page - 1) * per_page),
        "nome" => column_nome(mensagem),
        "email" => column_email(mensagem),
        "assunto" => column_assunto(mensagem),
        "respondido" => column_respondido(mensagem),
        "created_at" => column_created_at(mensagem),
        "opcoes" => column_opcoes(mensagem)
      }
    end
  end

  def column_nome(mensagem)
    html = "#{link_to mensagem.try(:nome), mensagem_path(mensagem), :remote => @remote}"
    html.html_safe
  end

  def column_respondido(mensagem)
    mensagem.try(:respondido) ? 'SIM' : 'NÃO'
  end

  def column_email(mensagem)
    mensagem.try(:email)
  end

  def column_assunto(mensagem) 
    mensagem.try(:assunto)
  end

  def column_created_at(mensagem) 
    mensagem.created_at.strftime("%d/%m/%Y %H:%M")
  end

  def column_opcoes(mensagem)
    opcoes = "#{link_to(mensagem_path(mensagem), {:remote =>  @remote, :class => 'btn btn-primary btn-icon btn-sm', title: "Visualizar", data: {toggle: "tooltip", placement: "top"}}) do
      content_tag(:i, '', :class => 'la la-search')
    end}"
    if !mensagem.respondido?
      opcoes << "#{link_to(responder_mensagem_path(mensagem), {:remote =>  true, :class => 'btn btn-icon btn-sm btn-success', title: "Responder Mensagem", data: {toggle: "tooltip", placement: "top"}}) do
        content_tag(:i, '', :class => 'la la-check')
      end}"
    end

    return opcoes.html_safe
  end

  def mensagens
    @mensagens ||= fetch
  end

  def query
    str_query = 'Mensagem'
    return str_query
  end



  def fetch
    str_query = query
    params[:columns].each do |column|
      str_query << ".where(#{column[1][:data]}: '#{column[1][:search][:value]}')" if column[1][:search][:value].present?
    end
    str_query << '.search(params[:search][:value])' if params[:search][:value].present?
    str_query << '.order(respondido: :asc).order("#{sort_column}" => "#{sort_direction}").page(page).per(per_page)'
    eval str_query
  end

  def total
    str_query = query
    str_query << '.count'
    eval str_query
  end

  def page
    params[:start].to_i/per_page + 1
  end

  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : 10
  end

  def sort_column
    columns = %w[created_at nome email assunto respondido created_at]
    columns[params[:order]["0"][:column].to_i]
  end

  def sort_direction
    params[:order]["0"][:dir] == "desc" ? "desc" : "asc"
  end

end