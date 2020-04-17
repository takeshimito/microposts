class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  validates :coment, length: { maximum: 225 }
  has_secure_password
  
  has_many :microposts
  
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
 
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  #userAが他の人をフォローする際にunlessで他人であることを確認
  #見つかればfind：そのユーザーを探す
  #見つからなければ：そのユーザーをフォローする（other_user.idに対応したfoolow_idを作成）　
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end
  #relationshipはフォローしている人の中から探す
  #relationshipがあればフォローを外す（relationshipsの中のfollow_idを壊す）
  def following?(other_user)
    self. followings.include?(other_user)
  end
  #フォローしていれば、true していなければfalseを返す
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  

  has_many :favorites
  #ユーザはお気に入りを複数持つ
  has_many :favorite_posts, through: :favorites, source: :micropost
  #favorite_posts（ユーザがお気に入りした投稿）をfavoritesの中のmicropost_idを取得
  #user.favorite_postsでユーザがお気に入りした投稿を取得
  
  def like(micropost)
    self.favorites.find_or_create_by(micropost_id: micropost.id)
  end
  #ユーザがお気に入りしたfavoritesテーブルの中からmicropost_idがmicropost.idと同じ投稿を見つける。なければ作る
  
  def unlike(micropost)
    favorite = self.favorites.find_by(micropost_id: micropost.id)
    favorite.destroy if favorite
  end
  #favoriteがあれば削除
    
  def like?(micropost)
    self.favorite_posts.include?(micropost)
  end
  #投稿がfavorite_posts（お気に入りした投稿）の中にあるか検証
    
  def feed_favorites
    Micropost.where(micropost_id: self.favorite_posts_ids)
  end

end
