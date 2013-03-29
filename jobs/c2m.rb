require 'rexml/document'
require 'net/http'

url = 'http://c2mtrax.com/affiliates/api/2/reports.asmx/PerformanceSummary?api_key=RVLZfRuzXk&affiliate_id=3085&date=2013-03-31'


# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
xml_data = Net::HTTP.get_response(URI.parse(url)).body
data = REXML::Document.new (xml_data)

period = ['12 Months']

data.elements.each('//date_range/..') do |parent|
  if (period.include? parent.elements['date_range/text()'].to_s)
    current_revenue = parent.elements['current_revenue'].text.to_i
    send_event('c2m_rev', current: current_revenue)
  end
   
end
end