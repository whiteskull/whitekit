module White::GeneralHelper
  def block_view(block_alias, cache_block = false)
    render partial: 'white/general/view_block', locals: {block_alias: block_alias, cache_block: cache_block}
  end

  def block_position_view(block_position_alias, cache_block_position = false)
    render partial: 'white/general/view_block_position', locals: {block_position_alias: block_position_alias,
                                                                  cache_block_position: cache_block_position}
  end

  # render block position
  def render_block_position(block_position_alias, path_info)
    block_position = BlockPosition.includes(:blocks).get(block_position_alias).first

    if block_position.present?
      blocks = block_position.blocks.visible
      content_html = ''
      blocks.each do |block|
        block_ = Block.get block, path_info
        content_html << whitecms_block(block_) if block_.present?
      end
      ActionController::Base.helpers.div_for block_position, :white do
        content_html.html_safe
      end
    end
  end

  # render block
  def render_block(block_alias, path_info)
    block = Block.get block_alias, path_info
    whitecms_block(block)
  end

  private

  def whitecms_block(block)
    if block.present?
      # if block is component
      if block.is_a?(Hash) && block[:components]
        content = render partial: "components/#{block[:components]}/index", locals: {vars: block[:vars], block: block}
        block = block[:block]
      elsif block.content.present?
          content = block.content.html_safe
      else
        content = user_signed_in? && current_user.admin? && cookies['whitecms-edit'] == 'on' ? "[#{block.alias}]" : ''
      end
      ActionController::Base.helpers.div_for block, :white do
        content
      end
    end
  end
end
