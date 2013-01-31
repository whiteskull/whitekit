class BlockPosition < ActiveRecord::Base
  has_many :blocks

  attr_accessible :alias, :hidden, :name, as: :admin

  validates :alias, presence: true, uniqueness: true
  validates :name, presence: true

  before_save :alias_processing

  scope :visible, -> { where(hidden: false) }
  scope :get, lambda { |position| where(alias: position).visible }

  private

  # Make alias lower case and replace space to underscore
  def alias_processing
    self.alias = Russian.translit(self.alias.downcase.gsub(' ', '_'))
  end
end
