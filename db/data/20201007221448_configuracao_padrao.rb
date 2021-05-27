class ConfiguracaoPadrao < SeedMigration::Migration
  def up
    @config = Configuracao.new 
    @config.empresa = Empresa.first

    @config.metatag_title = 'Hospital Maternidade Almeida Castro'
    @config.metatag_description = ''
    @config.metatag_language = 'pt-br'
    @config.metatag_keywords = 'odont'
    @config.metatag_author = 'Hospital Maternidade Almeida Castro'
    @config.metatag_robots = 'index, follow'
    @config.metatag_revisitafter =  '30 days'
    @config.metatag_charset = 'UTF-8'
    @config.metatag_ogimage = 'https://i.ibb.co/y5s4F3L/logo.png'
    @config.metatag_ogurl = 'odont.com.br'
    @config.metatag_ogtype = 'blog'
    @config.metatag_googleboot = 'index, follow'
    @config.metatag_tcard = 'summary_large_image'
    @config.metatag_tsite = '@maternidadealmeidacastro_'
    @config.metatag_tcreator = '@maternidadealmeidacastro_'
    
    @config.logo_rodape = File.new("#{Rails.root}/app/assets/images/logo.png")

    @config.save 
  end

  def down
    Configuracao.destroy_all
  end
end



