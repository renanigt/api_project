require 'rails_helper'

RSpec.describe ShortenedUrl, type: :model do
  describe '#valid' do
    it 'should be valid with all attributes' do
      shortened_url = ShortenedUrl.new(
        original_url: 'www.new.com',
        token: 'test',
        number_accesses: 1
      )

      expect(shortened_url).to be_valid
    end
  end

  describe '#invalid' do
    it 'should be invalid without original_url' do
      shortened_url = ShortenedUrl.new(
        token: 'test',
        number_accesses: 1
      )

      expect(shortened_url).not_to be_valid
    end

    it 'should be invalid if the original_url already exists' do
      shortened_url = ShortenedUrl.new(
        original_url: 'www.google.com',
        token: 'test',
        number_accesses: 1
      )

      expect(shortened_url).not_to be_valid
    end
  end

  describe '#create' do
    it 'should perform worker to get title' do
      expect(PullTitleWorker).to receive(:perform_async).with(any_args, 'https://github.com/')

      shortened_url = ShortenedUrl.create!(original_url: 'https://github.com/')

    end
  end
end
