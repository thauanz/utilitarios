require "net/http"
require "uri"
require "mongo"
require "bson"
require "json"

uri = URI.parse("http://api.twitter.com/1/statuses/public_timeline.json?cout=100&screen_name=thauanz")


http = Net::HTTP.new(uri.host, uri.port)

request = Net::HTTP::Get.new(uri.request_uri)

response = http.request(request)

connection = Mongo::Connection.new
connection.drop_database('twitter_timeline')

db = Mongo::Connection.new.db("twitter_timeline")

collection = db["twitter"]
doc = JSON.parse(response.body)

doc.each do |value|
  collection.insert value
end

collection.find().each { |row| puts row.inspect }

