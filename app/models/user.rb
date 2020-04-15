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
end
