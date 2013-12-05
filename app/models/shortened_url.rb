class ShortenedUrl < ActiveRecord::Base
  attr_accessible :submitter_id, :long_url, :short_url

  validates :short_url, :uniqueness => true

  belongs_to(
    :submitter,
    :primary_key => :id,
    :foreign_key => :submitter_id,
    :class_name => "User"
  )

  has_many(
    :visits,
    :primary_key => :id,
    :foreign_key => :shortened_url_id,
    :class_name => "Visit"
  )

  has_many(
    :visitors,
    :through => :visits,
    :source => :user
  )

  def self.random_code
    code = SecureRandom.urlsafe_base64[0...16]
    p ShortenedUrl.where('short_url LIKE ?', "%#{code}")
    until ShortenedUrl.where('short_url LIKE ?', "%#{code}").empty?
      code = SecureRandom.urlsafe_base64[0...16]
    end
    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    code = ShortenedUrl.random_code
    short_url = "http://www.millertime.com/#{code}"
    ShortenedUrl.new({ :submitter_id => user.id,
                       :long_url => long_url,
                       :short_url => short_url}).save!
  end

end