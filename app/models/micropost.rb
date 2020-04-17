class Micropost < ApplicationRecord
  belongs_to :user
  validates :content, presence: true, length: { maximum: 255 }
  
  has_many :favorites
  has_many :favorite_users, through: :favorites, source: :user
  #fovorite_user（お気に入りにしたユーザ）をfavoritesテーブルの中のuser_idを取得
  #micropost.favorite_usersでこの投稿をお気に入りしているユーザを取得
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
end
