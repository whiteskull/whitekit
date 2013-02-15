# coding: utf-8
class Page < ActiveRecord::Base
  has_ancestry

  attr_accessible :content, :description, :hidden, :keywords, :redirect_to, :title, :to_first,
                  :link, :title_seo, :title_page, as: :admin

  validates_presence_of :title, :link
  validates_uniqueness_of :alias, allow_blank: true

  before_validation :set_link, unless: :root_page?
  before_validation :check_alias, unless: :root_page?
  before_update :position_main_page
  before_create :set_max_position
  before_destroy :main_page_not_destroy
  after_save :clear_menu_cache, unless: :root_page?
  before_save :check_separator

  scope :visible, -> { where(hidden: false) }
  scope :get_by_alias, lambda { |name| name.present? ? where(alias: name).visible : visible }
  scope :sort_by_position, -> { order('position ASC') }

  private

  # Separator can be only root page
  def check_separator
    false if link =~ /^separator-/ && !ancestry.nil?
  end

  # Check if page is root
  def root_page?
    true if link == '/'
  end

  def check_alias
    if link =~ /^separator-/
      self.alias = nil
    else
      cnt = self.new_record? ? 0 : 1
      if link_changed?
        self.alias = self.alias.present? && self.alias =~ /\// ? self.alias.split('/')[0..-2].join('/') + "/#{link}" : link
      end
      self.alias = "#{self.alias}-#{rand(998) + 1}" if Page.where(alias: self.alias).count > cnt
    end
  end

  # Clear menu cache after save page
  def clear_menu_cache
    Rails.cache.clear 'main-menu'
  end

  # Main page must not be destroyed
  def main_page_not_destroy
    false if link == '/'
  end

  # Set page link if empty, also translit russian to english
  def set_link
    field = link.blank? ? title : link
    if field.present?
      link_new = Russian.translit(field.strip.gsub(/ /, '-').gsub(/[^A-Za-z0-9\-_]/, '')).downcase
      self.link = link_new unless link_new == '/'
    end
  end

  # Don't change position of main page
  def position_main_page
    false if link == '/' && (position != 1 || !ancestry.nil?)
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
      alias_link = "#{path}/#{menu.link}"
      menu.alias = alias_link[1..-1]
      menu.save
      self.make_alias(menu.children, alias_link)
    end
  end

end
