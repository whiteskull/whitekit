module Whitekit::GeneralHelper

  # Block view
  def block_view(block_alias, cache_block = false)
    render partial: 'whitekit/general/view_block', locals: {block_alias: block_alias, cache_block: cache_block}
  end

  # Block position view
  def block_position_view(block_position_alias, cache_block_position = false)
    render partial: 'whitekit/general/view_block_position', locals: {block_position_alias: block_position_alias,
                                                                  cache_block_position: cache_block_position}
  end

  # Render block position
  def render_block_position(block_position_alias, path_info)
    block_position = BlockPosition.includes(:blocks).get(block_position_alias).first

    if block_position.present?
      blocks = block_position.blocks.visible
      content_html = ''
      blocks.each do |block|
        block = Block.get block, path_info
        content_html << whitekit_block(block) if block.present?
      end
      ActionController::Base.helpers.div_for block_position, :white do
        content_html.html_safe
      end
    end
  end

  # Render block
  def render_block(block_alias, path_info)
    block = Block.get block_alias, path_info
    whitekit_block(block)
  end

  # Directory view for admin
  def whitekit_directory_view(path, opened = false)
    data = Whitekit.directory(Rails.root.join(path))
    content_tag :ul, class: "whitekit-directory #{if opened then 'whitekit-directory-opened' end}" do
      content = ''
      data[:dir].each do |item|
        content << content_tag(:li) do
          sub = content_tag :span, class: 'whitekit-folder', data: {path: "#{path.gsub(Rails.root.to_s, '')}/#{item}"} do
            item
          end
          if session[:whitekit_path] =~ /\[#{Regexp.escape("#{path}/#{item}")}\]/
            sub + whitekit_directory_view("#{path}/#{item}", true).html_safe
          else
            sub
          end
        end
      end
      data[:file].each do |item|
        content << content_tag(:li) do
          content_tag :span, class: 'whitekit-file', data: {path: "#{path.gsub(Rails.root.to_s, '')}/#{item}"} do
            item
          end
        end
      end
      content.html_safe
    end.html_safe
  end

  def whitekit_load_default_code
    if cookies[:whitekit_file_path].present?
      Whitekit.read_file(cookies[:whitekit_file_path])
    end
  end

  private

  def whitekit_block(block)
    if block.present?
      # If block is component
      if block.is_a?(Hash) && block[:block].component.present?

        theme = block[:block].component_theme.presence || 'default'

        # TODO: include js and css for component if it call first time
        content = javascript_include_tag("components/#{block[:block].component}/#{theme}/#{block[:block].component}")
        content << stylesheet_link_tag("components/#{block[:block].component}/#{theme}/#{block[:block].component}")
        content << render(partial: "components/#{block[:block].component}/#{theme}/index", locals: block)

        block = block[:block]
      # If block content is present
      elsif block.content.present?
        content = block.content.html_safe
      # If block is empty
      else
        content = user_signed_in? && current_user.admin? && cookies['whitekit-edit'] == 'on' ? "[#{block.alias}]" : ''
      end
      ActionController::Base.helpers.div_for block, :white, class: block.alias do
        content
      end
    end
  end
end
