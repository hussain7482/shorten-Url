class UrlsController < ApplicationController

    def new
        @url = Url.new
      end
    
    def create
        @url = Url.new(url_params)
        if @url.save
          @short_url = request.base_url + '/' + @url.short_code
        else
          @short_url = nil
        end
        render :new, format: :html
      end
      
      
    
      def show
        @url = Url.find_by(short_code: params[:short_code])
        if @url
          redirect_to @url.original_url, allow_other_host: true
        else
          render plain: "URL not found", status: :not_found
        end
      end
    
      private
    
      def url_params
        params.require(:url).permit(:original_url)
      end

end
