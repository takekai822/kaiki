class Book < ApplicationRecord

  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :view_counts, dependent: :destroy
  scope :latest, -> {order(updated_at: :desc)}
  scope :high_rate, -> {order(rate: :desc)}

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }
  
  def favorited_by?(user)
    favorites.exists?
  end
  
  def self.looks(search, word)
    if search == "perfect"
      @book = Book.where("title LIKE?", "#{word}")
    elsif search == "forward"
      @book = Book.where("title LIKE?", "#{word}%")
    elsif search == "backword"
      @book = Book.where("title LIKE?", "%#{word}")
    elsif search == "pertial"
      @book = Book.where("title LIKE?", "%#{word}%")
    else
      @book = Book.all
    end
  end
end
