class User < ActiveRecord::Base
  validates :email, :uniqueness => true

  has_many(
    :shortened_urls,
    :primary_key => :id,
    :foreign_key => :submitter_id,
    :class_name => "ShortenedUrl"
  )

end