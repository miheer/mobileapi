require 'rails_helper'

RSpec.describe OffersController, type: :controller do
    describe "SHOW" do
     context  "render show" do
      before do
        get :show
      end
      #expect(response).to render_template("show")
      it { is_expected.to render_template :show }
    end
  end


    describe "CREATE" do
     context  "when validation passes" do
      before do
      post :create, {"offer"=>{"uid"=>"user3", "pub0"=>"adad", "page"=>"1"}}
      end
      #expect(response).to render_template("show")
      it { is_expected.to render_template :show }
    end

    context  "when validation does not pass" do
      before do
      post :create, {"offer"=>{"uid"=>"user#3", "pub0"=>"adad", "page"=>"1"}}
      end
      it "shall render new" do
      expect(response).to render_template("new")
      end
      #it { is_expected.to set_flash(:notice).to('Please enter some value in alphanumeric') }
    end


   context  "invalid response" do
      before do

      controller.instance_variable_set(:@offers, "invalid_response") 
      post :create #{"offer"=>{"uid"=>"user3", "pub0"=>"adad", "page"=>"1"}}
      #before { controller.instance_variable_set(:@offers, "invalid_response") }
      end
      it "invalid response" do
        expect(response).to render_template("new")
      end
      #it { is_expected.to set_flash(:alert).to('Invalid response got from server') }
      it "shall flash alert" do
        expect(flash[:alert]).to be_present
      end
      it "shall flash alert" do
        expect(flash[:alert]).to eql("Invalid response got from server")
      end


    end




  end



end
