# == Schema Information
#
# Table name: products
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :text
#  image_url   :string(255)
#  price       :decimal(8, 2)
#  created_at  :datetime
#  updated_at  :datetime
#

class Product < ActiveRecord::Base
  default_scope :order => 'title'      # any queries against this model will pull back in order of title

  validates :title, :description, :image_url, :presence => true
  validates :price, :numericality => { :greater_than_or_equal_to => 0.01 }
  validates :title, :uniqueness => true,
                    :length => { :minimum => 10 }
  validates :image_url, :format => {
      :with     => %r{\.(gif|jpg|png)$}i,
      :message  => 'must be a URL for GIF, JPG or PNG image.' }

end
