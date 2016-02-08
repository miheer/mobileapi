require 'rails_helper'

module Enumerable
  def sorted?
    each_cons(2).all? { |a, b| (a <=> b) <= 0 }
  end
end


RSpec.describe Offer, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"

  describe "attribute validation" do

    context "attribute is valid" do

      before(:each) do
        @offer = Offer.new(uid:"user1", pub0:"campaign2", page:"1")
        @offer.valid?
      end

      it "does not add an error on the 'userid' attribute" do
        expect(@offer.errors.messages.count).to eq(0)
      end
 
      it "does not add an error on the 'pub0' attribute" do
        expect(@offer.errors.messages.count).to eq(0)
      end

      it "does not add an error on the 'page' attribute" do
        expect(@offer.errors.messages.count).to eq(0)
      end


    end

    context "attribute is not valid" do

      it "adds an error on the 'uid' attribute" do
        @offer = Offer.new(uid:"user@1", pub0:"campaign2", page:"1")
        @offer.valid?
        expect(@offer.errors.messages.count).to eq(1)
      end
      
      it "adds an error on the 'pub0' attribute" do
        @offer = Offer.new(uid:"user1", pub0:"campaign@2", page:"1")
        @offer.valid?
        expect(@offer.errors.messages.count).to eq(1)
      end

      it "adds an error on the 'page' attribute" do
        @offer = Offer.new(uid:"user1", pub0:"campaign2", page:"a")
        @offer.valid?
        expect(@offer.errors.messages.count).to eq(1)
      end

      it "adds an error message on the 'page' attribute" do
        @offer = Offer.new(uid:"user1", pub0:"campaign2", page:"a")
        @offer.valid?
        expect(@offer.errors.messages[:page]).to eq(["is not a number"])
      end

      it "adds an error message on uid' attribute" do
        @offer = Offer.new(uid:"user#1", pub0:"campaign2", page:"1")
        @offer.valid?
        expect(@offer.errors.messages[:uid]).to eq(["Please enter some value in alphanumeric"])
      end

      it "adds an error message on the 'pub0' attribute" do
        @offer = Offer.new(uid:"user1", pub0:"campaign@2", page:"1")
        @offer.valid?
        expect(@offer.errors.messages[:pub0]).to eq(["Please enter some value in alphanumeric"])
      end
 
      it "check presence of page attribute" do
        @offer = Offer.new(uid:"user1", pub0:"campaign2", page:"")
        @offer.valid?
        expect(@offer.errors.messages[:page]).to eq(["is not a number"])
      end

      it "check presence of uid attribute" do
        @offer = Offer.new(uid:"", pub0:"campaign2", page:"1")
        @offer.valid?
        expect(@offer.errors.messages[:uid]).to eq(["Please enter some value in alphanumeric"])
      end

      it "check presence of pub0 attribute" do
        @offer = Offer.new(uid:"user1", pub0:"", page:"1")
        @offer.valid?
        expect(@offer.errors.messages[:pub0]).to eq(["Please enter some value in alphanumeric"])
      end

      it "check length of pub0 attribute" do
        @offer = Offer.new(uid:"user1", pub0:"campaign111111111111111111111111111111", page:"1")
        @offer.valid?
        expect(@offer.errors.messages[:pub0]).to eq(["less than 30 if you don't mind"])
      end
 
 
      it "check length of pub0 attribute" do
        @offer = Offer.new(uid:"user1111111111111111111111111111111", pub0:"campaign2", page:"1")
        @offer.valid?
        expect(@offer.errors.messages[:uid]).to eq(["less than 30 if you don't mind"])
      end



    end

  end

       it "should sort url" do
        offer = Offer.new
        #TIMESTAMP = Time.now.to_i
        sort_url = offer.create_sorted_url ({"uid"=>"user1", "pub0"=>"campaign2", "page"=>"1"})
        sort_url = sort_url.to_s
      
        i = sort_url.index("?")
        n = sort_url.size
        sort_url = sort_url.slice(sort_url.index("?")+1..sort_url.size)
        sort_array = sort_url.split("&")
        sort_array.delete_at(sort_array.size - 1) 
        expect(sort_array.sorted?).to eql(true)
       end

       it "should get a response if Accept-Encoding != gzip" do
         offer = Offer.new
         uri = URI.parse("http://api.fyber.com/feed/v1/offers.json?appid=157&device_id=2b6f0cc904d137be2e1730235f5664094b83&format=json&ip=109.235.143.113&locale=de&offer_types=112&page=1&ps_time=1454873024&pub0=campaign2&timestamp=1454873024&uid=user1&hashkey=d97de0acef4cdb5933d6238bbb5288e2d92d1aed")
         response = offer.get_response uri, nil
         expect(response["code"]).to eql("OK")
       end

       it "should get a response if Accept-Encoding == gzip" do
         offer = Offer.new
         uri = URI.parse("http://api.fyber.com/feed/v1/offers.json?appid=157&device_id=2b6f0cc904d137be2e1730235f5664094b83&format=json&ip=109.235.143.113&locale=de&offer_types=112&page=1&ps_time=1454873024&pub0=campaign2&timestamp=1454873024&uid=user1&hashkey=d97de0acef4cdb5933d6238bbb5288e2d92d1aed")
         response = offer.get_response uri, { "Accept-Encoding" => "gzip", "User-Agent" => "gzip" }
         expect(response["code"]).to eql("OK")
       end


       it "should get offers" do
         response = Offer.get_offers ({"uid"=>"user1", "pub0"=>"campaign2", "page"=>"1"})
         expect(response["code"]).to eql("OK")  
       end
end
