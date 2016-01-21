require 'mechanize'
require 'logger'
require 'digest'

mech = Mechanize.new
# mech.log = Logger.new $stderr
# mech.agent.http.debug_output = $stderr
mech.user_agent_alias = 'Mac Safari'
users = {}
md5 = Digest::MD5.new

#http://www.hearthlog.com/u/MightyMoon
UserRegex = /http:\/\/www.hearthlog.com\/u\/([^\/]+)/
def parse_user(link)
  match = UserRegex.match(link)
  if match && match.size > 1
    return match[1].strip
  end
  return nil
end

File.open('data/raw/bing_hearthlog.tsv', 'r') {|f|
  f.each_line {|link|
    user = parse_user(link)
    if !user.nil? && user != "" && users[user] == nil
      hash_val = md5.hexdigest(user)[0,8]
      File.open("data/raw/hearthlog/#{user}-#{hash_val}.html", 'w') {|out|
        puts user
        page = mech.get("http://www.hearthlog.com/u/#{user}")
        out.write(page.body)
        sleep(1)  
      }
      users[user] = 1
    end
  }
}