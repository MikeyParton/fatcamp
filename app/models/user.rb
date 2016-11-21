require 'elasticsearch/model'

class User < ApplicationRecord

	include Elasticsearch::Model
	include Elasticsearch::Model::Callbacks

	settings index: { number_of_shards: 1 } do
	  mappings dynamic: 'false' do
	    indexes :name, type: 'string', analyzer: 'english'
	    indexes :email, type: 'string',analyzer: 'english'
	    indexes :weight, type: 'float'
	  end
	end

	def self.search(params)
		query_object = {
			query: {
      	bool: {
      		must: []
      	}
      }
		}
		
		query_object[:query][:bool][:must] << { multi_match: {query: params[:name], fields: ['name', 'email'] }} if params[:name].present?
		query_object[:query][:bool][:must] << { range: {weight: { gte: params[:min] }}} if params[:min].present?
		query_object[:query][:bool][:must] << { range: {weight: { lte: params[:max] }}} if params[:max].present?

	  __elasticsearch__.search(query_object)
	end

	def profile_pic_url
    self.porfile_pic.url
  end

	def profile_pic
		self.profile_pic.url
	end

	def as_indexed_json(options = nil) 
		self.as_json(only: [:name, :email], methods: [:weight, :profile_pic_url])
	end

	after_initialize :init

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
	:recoverable, :rememberable, :trackable, :confirmable, :lockable
	
	validates :profile_text, presence: true
	validates :name, presence: true
	validates :email, presence: true
	validates :password, length: { minimum: 6}, :unless => Proc.new {|user| !user.new_record? && user.password.nil?}
	validates_confirmation_of :password

	has_many :posts, dependent: :destroy
	has_many :comments, dependent: :destroy
	has_many :sent_friendships, class_name: "Friendship", foreign_key: "sender_id", dependent: :destroy
	has_many :sent_friends, through: :sent_friendships, source: :receiver
	has_many :received_friendships, class_name: "Friendship", foreign_key: "receiver_id", dependent: :destroy
	has_many :received_friends, through: :received_friendships, source: :sender

	mount_uploader :profile_pic, ProfilePicUploader
	mount_uploader :cover_pic, CoverPicUploader

	def profile_pic_url
    profile_pic.url
  end

	def init
		self.profile_text ||= "Hey there, I'm #{self.name} and I'm overweight."
	end

	def friend_ids
		self.sent_friend_ids.push(*self.received_friend_ids)
	end

	def friends
		User.where("id IN (?)", self.friend_ids)
	end

	def not_friends
		User.where("id NOT IN (?) AND id != (?)", self.friend_ids, self.id)
	end

	def feed
		Post.where("user_id IN (?) OR user_id = (?)", self.friend_ids, self.id)
	end

	def progress( start_time = Time.now - 7.days, end_time = Time.now ) 
		# Creates an array of labels and weights to show daily progress within period 

		data = { labels: [], weights: [] }
		difference_in_days = (end_time - start_time).to_i / 1.day
		progress_posts = self.posts.between(start_time.beginning_of_day, end_time.end_of_day).weigh_ins

		if !progress_posts.any?
			out_of_scope = self.posts.before(start_time.beginning_of_day).last&.weight
		end

		(1..difference_in_days).each do |x|
			time_at_x = end_time - (difference_in_days - x).days
			unless (post_on_day = progress_posts.between(time_at_x.beginning_of_day, time_at_x.end_of_day)).empty?
				weight_on_day = post_on_day.last.weight
			else
				weight_on_day = out_of_scope || progress_posts.before(time_at_x.beginning_of_day).last&.weight
			end
			data[:labels].push(time_at_x.strftime("%a"))
			data[:weights].push(weight_on_day)
		end
		data
	end

	def weight
		self.posts.weigh_ins.last&.weight
	end

end

User.import force: true