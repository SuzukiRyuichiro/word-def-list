require 'csv'
require 'json'
require 'uri'
require 'net/http'
require 'openssl'

word_def = []

CSV.foreach("word_list.csv") do |row|
  word = row[0]
  url = URI("https://wordsapiv1.p.rapidapi.com/words/#{word}/definitions")
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(url)
  request["x-rapidapi-key"] = '3a3fb97506msh8b49abdff28130fp180f5bjsn82a2b01e5bad'
  request["x-rapidapi-host"] = 'wordsapiv1.p.rapidapi.com'

  response = http.request(request)
  body = response.read_body
  json = JSON.parse(body)
  definitions = json["definitions"].map { |elm| elm['definition'] }.join('; ')
  word_def << {word: word, def: definitions}
end

CSV.open('word_def_list.csv', 'wb') do |csv|
  csv << ['word', 'def']
  word_def.each do |elm|
    csv << [elm[:word], elm[:def]]
  end
end

