class Comment < ApplicationRecord
  validates :content,      presence: true
  validates :prototype,    presence: true
  validates :user,         presence: true

  belongs_to :prototype  
  belongs_to :user  
end
