# Web Mobile API 

## Description

- This is an web application application which helps an user to get responses i.e offers using Fyber Api by 
  simply feeding the parameter information to it.

##System Dependencies & Configuration
- This code was tested using the following
 - ruby-2.2.1
 - RHEL6.4+ 
 - rails 4.2.5.1

##Application Installation Instructions
### Using gem
 
 - git clone 

 - go to your cloned directory

~~~
   $cd mobileapi
~~~

 - Change the config/initializers offer_vars.rb file to use env vars of your choice

~~~
APPID='157'
DEVICE_ID='2b6f0cc904d137be2e1730235f5664094b83'
FORMAT='json'
IP='109.235.143.113'
LOCALE='de'
OFFER_TYPES='112'
#PAGE=2
PS_TIME="#{Time.now.to_i}"
#PUB0=campaign2
TIMESTAMP="#{Time.now.to_i}"
#UID=player1
API_KEY=''
SERVER_URI='http://api.fyber.com/feed/v1/offers.json'
~~~

 - then bundle 

~~~
   #bundle install
~~~ 

 - Then start the server

~~~
   #rails s 
~~~

##Usage Instructions
  
  On the Web UI
  
  1) Add uid(userid) which shall be alphanumeric  
  
  2) Add pub0(custom parameter) which shall be alphanumeric

  3) Add page which shall be numeric

  4) Press the green button "Submit Offer Parameters" to get offers

##Overview
- This is a web application which consumes the Fyber Offer API and renders its responses. 

- Read the Fyber Offer API specification at
~~~
  http://developer.fyber.com/content/current/ios/offer-wall/offer-api/
~~~

###Rules as per http://developer.fyber.com/content/current/ios/offer-wall/offer-api/
- A url is first made, then haskey is appended to the url and then the request is made
- Response is again checked using X-Sponsorpay-Response-Signature in it


##TESTING INSTRUCTIONS

Run the following to run the test cases

~~~

#rspec spec/

~~~

Copyright (c) 2015 Miheer Pravin Salunke

See [MIT LICENSE](./LICENSE.txt)  for details.


