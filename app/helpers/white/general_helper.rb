module White::GeneralHelper
  def block_view(block_alias, cache_block = false)
    render partial: 'white/general/view_block', locals: {block_alias: block_alias, cache_block: cache_block}
  end

  def block_position_view(block_position_alias, cache_block_position = false)
    render partial: 'white/general/view_block_position', locals: {block_position_alias: block_position_alias,
                                                                  cache_block_position: cache_block_position}
  end
end
