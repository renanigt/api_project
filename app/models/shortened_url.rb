class ShortenedUrl < ApplicationRecord
  before_validation :generate_token
  after_create :get_title

  validates :original_url, :token, presence: true, uniqueness: true

  scope :top, -> (amount) { order(number_accesses: :desc).first(amount) }

  private

  def generate_token
    self.token ||= SecureRandom.hex(3)
  end

  def get_title
    PullTitleWorker.perform_async(self.token, self.original_url)
  end
end
