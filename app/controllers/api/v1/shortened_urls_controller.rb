module Api
  module V1
    class ShortenedUrlsController < ApplicationController
      def create
        shortened_url = ShortenedUrl.new(shortened_url_params)

        if shortened_url.save
          render json: shortened_url, status: :created
        else
          render json: shortened_url.errors, status: :unprocessable_entity
        end
      end

      def show
        shortened_url = ShortenedUrl.find_by(token: params[:token])

        render json: shortened_url, status: :ok
      end

      def top
        shortened_urls = ShortenedUrl.top(params[:number].to_i)

        render json: shortened_urls, status: :ok
      end

      private

      def shortened_url_params
        params.require(:shortened_url).permit(:original_url)
      end
    end
  end
end
