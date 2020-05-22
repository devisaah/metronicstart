module ApplicationHelper

    def active_header_menu?(controllers)
      controllers.each do |controller|
        if controller[0] == params[:controller]
          if controller[1] == "*" || controller[1].include?(params[:action])
            return 'menu-item-active'
          end
        end
      end
    end
    
  
    def active_collapse_menu?(controllers)
      controllers.each do |controller|
        if controller[0] == params[:controller]
          if controller[1] == "*" || controller[1].include?(params[:action])
            return 'show'
          end
        end
      end
    end

    def active_modulo?(modulo)
        'menu-item-active' if modulo == (controller.send :_layout, [modulo])
    end

    def controllers
      return Dir["#{Rails.root}/app/controllers/**/*.rb"].map { |m| m.chomp('.rb').camelize.split("::").last.gsub('Controller', '').singularize.downcase} - ['application', 'error', 'home']
    end
end  