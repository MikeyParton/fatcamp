class Post < ApplicationRecord
	belongs_to :user
	has_many :comments, as: :commentable, dependent: :destroy
	mount_uploader :image, PostImageUploader, dependent: :destroy
  after_commit :update_user_index, only: [:create, :destroy, :update]

	validates :text, presence: { message: "can't be blank if image and weight are blank" }, unless: ->(post){ post.weight.present? || post.image.present? }
	validates :weight, presence: { message: "can't be blank if text and image are blank" }, unless: ->(post){ post.text.present? || post.image.present? }
  validates :image, presence: { message: "can't be blank if text and weight are blank" }, unless: ->(post){ post.text.present? || post.weight.present? }

  scope :on_day, -> (time) { where('created_at > ? AND created_at < ?', time.beginning_of_day, time.end_of_day) }
  scope :between, -> (start_time, end_time) { where('created_at > ? AND created_at < ?', start_time, end_time) }
  scope :before, -> (time) { where('created_at < ?', time) }
  scope :weigh_ins, -> { where('WEIGHT IS NOT NULL') }

  def weight_difference
  	if self.weight.present?
  		previous_weigh_ins = self.user.posts.where("created_at < ? AND weight IS NOT NULL", created_at).order(created_at: :asc)
  		self.weight - previous_weigh_ins.last.weight if previous_weigh_ins.any?
  	end
  end

  private

    def update_user_index
      if weight.present?
        user.__elasticsearch__.update_document
      end 
    end

end