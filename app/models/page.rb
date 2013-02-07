# coding: utf-8
class Page < ActiveRecord::Base
  has_ancestry

  attr_accessible :content, :description, :hidden, :keywords, :redirect_to, :title, :to_first,
                  :link, :title_seo, :title_page, as: :admin

  validates_presence_of :title, :link
  validates_uniqueness_of :alias, allow_blank: true

  before_validation :set_link
  before_update :position_main_page
  before_create :set_max_position
  before_destroy :main_page
  after_save :clear_menu_cache

  scope :visible, -> { where(hidden: false) }
  scope :get_by_alias, lambda { |name| name.present? ? where(alias: name).visible : visible }
  scope :sort_by_position, -> { order('position ASC') }

  private

  # Clear menu cache after save page
  def clear_menu_cache
    Rails.cache.clear 'main-menu'
  end

  # Main page must not be destroyed
  def main_page
    false if Page.first == self
  end

  # Set page link if empty, also translit russian to english
  def set_link
    if Page.first == self
      self.link = '/'
    else
      field = link.blank? ? title : link
      self.link = Russian.translit(field.strip.gsub(/ /, '-')).downcase if field.present?
    end
  end

  # Don't change position of main page
  def position_main_page
    false if Page.first == self && (position != 1 || !ancestry.nil?)
  end

  # Set max position to new pages
  def set_max_position
    self.position = 999 unless link == '/'
  end

  # Make aliases for all pages
  def self.make_aliases
    roots.each do |menu|
      self.make_alias(menu.children)
    end
  end
  def self.make_alias(menus, path = '')
    menus.each do |menu|
      alias_link = path + '/' + menu.link
      menu.update_attribute(:alias, alias_link[1..-1])
      self.make_alias(menu.children, alias_link)
    end
  end

end
