#!/usr/bin/env ruby
require 'net/http'
require 'json'


SCHEDULER.every '1m', :first_in => 0 do |job|
  http = Net::HTTP.new("affiliates.cupid.com")
  response = http.request(Net::HTTP::Get.new("/stats/stats.json?api_key=AFFddwfng8krV0mn7HCl1Uufp1E1ps&start_date=2013-03-01&end_date=2013-03-31"))
  if response.code != "200"
    puts "cupid api error (status-code: #{response.code})\n#{response.body}"
  else 
    data = JSON.parse(response.body)
    clicks = data['data'].first['clicks'].sub(',','').to_i
    conversions = data['data'].first['conversions'].sub(',','').to_i
    payout = data['data'].first['payout'][1...-1].sub(',','').to_i
    erpc = data['data'].first['erpc'].to_i
    cpl = data['data'].first['cpl'].to_i

    send_event('cupid_clicks', current: clicks)
    send_event('cupid_conversions', value: conversions)
    send_event('cupid_payout', current: payout)
    send_event('cupid_erpc', current: erpc)
    send_event('cupid_cpl', current: cpl)
  end
end

