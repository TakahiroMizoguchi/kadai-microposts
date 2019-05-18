class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    # 重複を許さないバリデーション。大文字と小文字を区別せず同一のものとして処理する。
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  # 一対多の関係を記述。
  has_many :microposts
  has_many :relationships
  
  # フォローしているUser達を表現。through: :relationshipsでhas_many: relationshipsの結果を中間テーブルを指定。
  # source: :followで中間テーブルのカラムの中でどのidを参照するか決定している。
  has_many :followings, through: :relationships, source: :follow
  
  # 順方向に対して逆の設定。
  has_many :reverses_of_relationship, class_name: "Relationship", foreign_key: "follow_id"
  
  # source: :userで中間テーブルの user_idを取得したいUserと指定している。
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  has_many :favorites
  has_many :favorite_microposts, through: :favorites, source: :micropost
  
  # フォロー用のメソッド
  def follow(other_user)
    unless self == other_user # フォローしようとしている other_user が自分自身でないことを検証。
     self.relationships.find_or_create_by(follow_id: other_user.id) # selfには user.follow(other)を実行したときuserが代入される。
    end
  end
   
  def unfollow(other_user) # フォローがあればアンフォローする。
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship # relationshipが存在すればdestroyする。
  end
  
  def following?(other_user)
    self.followings.include?(other_user) # self.followingsでフォローしているUserを取得、inclide?(other_user)でother_userが含まれていないかを確認。含まれていればtrue、なければfalseを返す。
  end
  
  # タイムライン用のメソッド
  def feed_microposts
    Micropost.where(user_id:self.following_ids + [self.id])
  end
  
  # お気に入り登録用のメソッド
  def favorite(micropost)
    self.favorites.find_or_create_by(micropost_id: micropost.id)
  end
  
  def unfavorite(micropost)
    favorite = self.favorites.find_by(micropost_id: micropost.id)
    favorite.destroy if favorite
  end
  
  def favorite_micropost?(micropost)
    self.favorite_microposts.include?(micropost)
  end
end