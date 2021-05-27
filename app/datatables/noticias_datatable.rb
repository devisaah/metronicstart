class NoticiasDatatable
  delegate :params, :h, :t, :link_to, :content_tag, :noticia_path, :edit_noticia_path, :desativar_noticia_path, :ativar_noticia_path,  to: :@view
  include EnumI18nHelper

  def initialize(view)
    @view = view
    @remote = params[:remote] == 'true'
  end

  def as_json(options = {})
    {
        draw: params[:draw].to_i,
        recordsTotal: total,
        recordsFiltered: noticias.total_count,
        data: data
    }
  end

  private
  def data
    noticias.each_with_index.map do |noticia, index|
      {
        "index" => (index + 1) + ((page - 1) * per_page),
        "titulo" => column_titulo(noticia),
        "created_at" => column_created_at(noticia),
        "ativo" => column_ativo(noticia),
        "opcoes" => column_opcoes(noticia)
      }
    end
  end

  def column_titulo(noticia)
    html = "#{link_to noticia.try(:titulo), noticia_path(noticia), :remote => @remote}"
    html.html_safe
  end

  def column_ativo(noticia)
    noticia.try(:ativo) ? 'SIM' : 'NÃO'
  end

  def column_created_at(noticia)
    noticia.try(:created_at).try(:strftime, "%d/%m/%Y %H:%M")
  end
  
  def column_opcoes(noticia)
    opcoes = "#{link_to(noticia_path(noticia), {:remote =>  @remote, :class => 'btn btn-primary btn-icon btn-sm', title: "Visualizar", data: {toggle: "tooltip", placement: "top"}}) do
      content_tag(:i, '', :class => 'la la-search')
    end}" +
        "#{link_to(edit_noticia_path(noticia), {:remote =>  @remote, :class => 'btn btn-warning btn-icon btn-sm', title: "Editar", data: {toggle: "tooltip", placement: "top"}}) do
          content_tag(:i, '', :class => 'la la-pencil-square')
        end}" +
        "#{link_to noticia_path(noticia),
                   method: :delete,
                   data: { confirm: t('helpers.links.confirm_destroy', :model => noticia.model_name.human), toggle: "tooltip", placement: "top" },
                   :remote =>  @remote,
                   class: "btn btn-danger btn-icon btn-sm", title: "Remover" do
          content_tag(:i, '', :class => 'la la-trash')
        end}"


    if noticia.ativo?
      opcoes << "#{link_to(desativar_noticia_path(noticia), {:remote =>  true, :class => 'btn btn-icon btn-sm btn-danger', title: "Desativar Noticia", data: {toggle: "tooltip", placement: "top"}}) do
        content_tag(:i, '', :class => 'la la-close')
      end}"
    else
      opcoes << "#{link_to(ativar_noticia_path(noticia), {:remote =>  true, :class => 'btn btn-icon btn-sm btn-success', title: "Ativar Noticia", data: {toggle: "tooltip", placement: "top"}}) do
        content_tag(:i, '', :class => 'la la-check')
      end}"
    end

    return opcoes.html_safe
  end

  def noticias
    @noticias ||= fetch
  end

  def query
    str_query = 'Noticia'
    str_query << '.where(categoria_id: params[:categoria_id])' if params[:categoria_id].present?
    return str_query
  end



  def fetch
    str_query = query
    params[:columns].each do |column|
      str_query << ".where(#{column[1][:data]}: '#{column[1][:search][:value]}')" if column[1][:search][:value].present?
    end
    str_query << '.search(params[:search][:value])' if params[:search][:value].present?
    str_query << '.order("#{sort_column}" => "#{sort_direction}").page(page).per(per_page)'
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
    columns = %w[created_at titulo created_at ativo]
    columns[params[:order]["0"][:column].to_i]
  end

  def sort_direction
    params[:order]["0"][:dir] == "desc" ? "desc" : "asc"
  end

end