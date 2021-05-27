class PermissoesDatatable
  delegate :params, :h, :t, :link_to, :content_tag, :permissao_path, :edit_permissao_path,  to: :@view
  include EnumI18nHelper

  def initialize(view)
    @view = view
    @remote = params[:remote] == 'true'
  end

  def as_json(options = {})
    {
        draw: params[:draw].to_i,
        recordsTotal: total,
        recordsFiltered: permissoes.total_count,
        data: data
    }
  end

  private
  def data
    permissoes.each_with_index.map do |permissao, index|
      {
          "index" => (index + 1) + ((page - 1) * per_page),
          "descricao" => column_descricao(permissao),
          "opcoes" => column_opcoes(permissao)
      }
    end
  end

  def column_descricao(permissao)
    html = "#{link_to permissao.try(:descricao), permissao_path(permissao), :remote => @remote}"
    html.html_safe
  end

 
  
  def column_opcoes(permissao)
    opcoes = "#{link_to(permissao_path(permissao), {:remote =>  @remote, :class => 'btn btn-primary btn-icon btn-sm', title: "Visualizar", data: {toggle: "tooltip", placement: "top"}}) do
      content_tag(:i, '', :class => 'la la-search')
    end}" +
        "#{link_to(edit_permissao_path(permissao), {:remote =>  @remote, :class => 'btn btn-warning btn-icon btn-sm', title: "Editar", data: {toggle: "tooltip", placement: "top"}}) do
          content_tag(:i, '', :class => 'la la-pencil-square')
        end}" +
        "#{link_to permissao_path(permissao),
                   method: :delete,
                   data: { confirm: t('helpers.links.confirm_destroy', :model => permissao.model_name.human), toggle: "tooltip", placement: "top" },
                   :remote =>  @remote,
                   class: "btn btn-danger btn-icon btn-sm", title: "Remover" do
          content_tag(:i, '', :class => 'la la-trash')
        end}"
    return opcoes.html_safe
  end

  def permissoes
    @permissoes ||= fetch
  end

  def query
    str_query = 'Permissao'
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
    columns = %w[created_at descricao]
    columns[params[:order]["0"][:column].to_i]
  end

  def sort_direction
    params[:order]["0"][:dir] == "desc" ? "desc" : "asc"
  end

end