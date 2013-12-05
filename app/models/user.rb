class User < ActiveRecord::Base
  validates :email, :uniqueness => true

  has_many(
    :shortened_urls,
    :primary_key => :id,
    :foreign_key => :submitter_id,
    :class_name => "ShortenedUrl"
  )

  has_many(
    :visits,
    :primary_key => :id,
    :foreign_key => :user_id,
    :class_name => "Visit"
  )

  has_many(
    :visited_urls,
    :through => :visits,
    :source => :shortened_url
  )
end