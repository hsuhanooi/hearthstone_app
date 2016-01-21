require 'mechanize'
require 'logger'

out_file = File.new("data/raw/bing_hearthlog.tsv", 'w')

mech = Mechanize.new
mech.log = Logger.new $stderr
mech.agent.http.debug_output = $stderr
mech.user_agent_alias = 'Mac Safari'

bing = 'http://www.bing.com/search?q=site%3Ahearthlog.com&go=Submit&qs=n&form=QBLH&pq=site%3Ahearthlog.com&sc=0-15&sp=-1&sk=&cvid=d75b6bf7d2524ce6ad2543ef240c476f'
stack = [bing]

while l = stack.pop
  page = mech.get(l)

  page.root.css("li.b_algo > h2 > a").each {|a|
    puts a["href"]
    out_file.write(a["href"] + "\n")
  }

  next_page = page.root.css('a[title="Next "]')
  if !next_page.empty?
    puts next_page
    sleep(1)
    new_page = next_page.first["href"]
    stack.push(new_page)
  end
end

out_file.close