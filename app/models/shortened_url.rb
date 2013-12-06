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
    :source => :user,
    :uniq => true
  )

  def self.random_code
    code = SecureRandom.urlsafe_base64[0...16]
    # p ShortenedUrl.where('short_url LIKE ?', "%#{code}")
    until ShortenedUrl.where('short_url LIKE ?', "%#{code}").empty?
      code = SecureRandom.urlsafe_base64[0...16]
    end
    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    code = ShortenedUrl.random_code
    short_url = "http://www.millertime.com/#{code}"
    shortened_url = ShortenedUrl.new({ :submitter_id => user.id,
                       :long_url => long_url,
                       :short_url => short_url})
    shortened_url .save!
    shortened_url
  end

  def num_clicks
    Visit.where(:shortened_url_id => self.id).count
  end

  def num_uniques
    Visit.where(:shortened_url_id => self.id).count(:user_id, :distinct => true)
  end

  def num_recent_uniques
    time_range = ((DateTime.now - 10.minutes)..DateTime.now)
    Visit.where(:shortened_url_id => self.id,
                :created_at => time_range)
         .count(:user_id, :distinct => true)
  end
end