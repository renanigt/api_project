require 'open-uri'

class PullTitleWorker
  include Sidekiq::Worker

  def perform(token, original_url)
    shortened_url = ShortenedUrl.find_by(token: token, original_url: original_url)

    title = open(original_url) do |f|
      str = f.read
      str.scan(/<title>(.*?)<\/title>/)
    end

    shortened_url.update!(title: title)
  end
end