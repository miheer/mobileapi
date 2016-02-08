class Offer 
  include ActiveModel::Model 
  #include ActiveModel::AttributeMethods 
  include ActiveModel::Validations
  attr_accessor :uid, :pub0, :page
  #define_attribute_methods 'response1'
  validates_format_of :uid, :pub0, :with => /\A[[:alnum:]]+\z/, message: "Please enter some value in alphanumeric"
  validates_numericality_of :page
  validates_length_of :uid, :pub0, maximum: 30, message: "less than 30 if you don't mind"

  def response
    @response
  end

  def response=(value)
    @response = value
  end

  def self.get_offers params
    offer = Offer.new
    uri = offer.create_sorted_url params
    response = offer.get_response uri, { "Accept-Encoding" => "gzip", "User-Agent" => "gzip" }
  end


  def create_sorted_url params
    offer_params = {"appid" => APPID, "device_id" => DEVICE_ID, "format" => FORMAT, "ip" => IP, "locale" => LOCALE, "offer_types" => OFFER_TYPES, "ps_time" => Time.now.to_i.to_s, "timestamp" => Time.now.to_i.to_s }
    offer_params.merge!(params)
    offer_params = offer_params.sort
    url_sort = ""
    offer_params.each do |key, value|
      url_sort = url_sort + "#{key}=#{value}&"
    end
    hash_key = Digest::SHA1.hexdigest( url_sort + API_KEY)
    puts "URI=============#{URI.parse("#{SERVER_URI}?#{url_sort}hashkey=#{hash_key}")}"
    uri = URI.parse("#{SERVER_URI}?#{url_sort}hashkey=#{hash_key}")
  end  

  def get_response uri, gzip_params=nil
    Net::HTTP.start(uri.host, uri.port) do |http|
      http.set_debug_output($stdout)
      request = Net::HTTP::Get.new uri, gzip_params #{ "Accept-Encoding" => "gzip", "User-Agent" => "gzip" }
      self.response = http.request request # Net::HTTPResponse object
    end
   
    case self.response
      when Net::HTTPSuccess then 
        begin
          if self.response.header[ 'Content-Encoding' ].eql?( 'gzip' ) then
            puts "In GZIP"
            sio = StringIO.new( self.response.body )  #if Digest::SHA1.hexdigest(offer.response.body + API_KEY) == offer.response['x-sponsorpay-response-signature']
            gz = Zlib::GzipReader.new( sio )
            pg = gz.read() # if Digest::SHA1.hexdigest(pg + API_KEY) == offer.response['x-sponsorpay-response-signature']

            if genuine_response pg
              offers= JSON.parse(pg)#["offers"]
            else
               "invalid_response"
            end

          else
             if genuine_response self.response.body
               JSON.parse(self.response.body)#["offers"]
             else
               "invalid response"
             end
          end
         rescue Exception
           raise $!.message
         end
    end
  end
 
  def genuine_response pg
    Digest::SHA1.hexdigest(pg + API_KEY) == self.response['x-sponsorpay-response-signature']
  end

end
