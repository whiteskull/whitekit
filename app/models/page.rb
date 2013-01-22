# coding: utf-8
class Page < ActiveRecord::Base
  has_ancestry

  attr_accessible :content, :description, :hidden, :keywords, :redirect_to, :title, :to_first, :link

  validates_presence_of :title, :link

  before_validation :set_link
  before_update :position_main_page
  before_create :set_max_position
  before_destroy :main_page

  scope :visible, where(hidden: false)

  private

  # Main page must not be destroyed
  def main_page
    false if Page.first == self
  end

  # Set page link, also translit russian to english
  def set_link
    if Page.first == self
      self.link = '/'
    else
      field = link.blank? ? title : link
      self.link = Russian.translit(field.gsub(/ /, '-')).downcase
    end
  end

  # Don't change position of main page
  def position_main_page
    false if Page.first == self && (position != 1 || !ancestry.nil?)
  end

  # Set max position to new pages
  def set_max_position
    self.position = 999
  end

  # Make aliases for all pages
  def self.make_aliases
    menus = roots

    menus.each do |menu|
      Page.make_alias(menu.children)
    end
  end

  def self.make_alias(menus, path = '')
    menus.each do |menu|
      alias_link = path + '/' + menu.link
      menu.update_attribute(:alias, alias_link)

      Page.make_alias(menu.children, alias_link)
    end
  end

end
