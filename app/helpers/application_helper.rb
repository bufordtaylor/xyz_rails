module ApplicationHelper

  def show_flashes
    out = ''
    boostrap_special_class = ->(name){ {error: "danger", alert: "warning", notice: "info"}[name] || name.to_s }
    flash.each do |name, message|
      classes = "flash-box alert alert-#{boostrap_special_class.call(name)} alert-dismissable"
      dismiss_button = '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>'
      if flash[name].is_a?(Array)
        out += %(<div class="#{classes}">#{dismiss_button}<ul>)
        flash[name].each do |flash_element|
          out += %(<li>#{flash_element}</li>)
        end
        out += %(</ul></div>)
        flash.discard(name)
      else
        out += %(<div class="#{classes}">#{dismiss_button}#{flash[name]}</div>) if flash[name]
      end
    end
    out.html_safe
  end

  def page_title(default = "", block_page_title = nil)
    if @layout_data and @layout_data[:title].present?
      @layout_data[:title] + " :: " + default
    elsif block_page_title.present?
      block_page_title + " :: " + default
    else
      default
    end
  end

end
