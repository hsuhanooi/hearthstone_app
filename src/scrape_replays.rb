require 'mechanize'
require 'logger'
require 'time'

TimeFormat = "%Y-%m-%dT%H:%M:%SZ"
ThisYear = Time.strptime("2015-01-01T16:23:31Z", TimeFormat)

mech = Mechanize.new
# mech.log = Logger.new $stderr
# mech.agent.http.debug_output = $stderr
mech.user_agent_alias = 'Mac Safari'


File.open("data/parsed/replay_links.tsv") {|f|
  f.each_line {|line|
    time, result, player, enemy, turns, link, user, replay_id = line.split("\t")
    ptime = Time.strptime(time, TimeFormat)
    out_file = "data/raw/hearthlog/replays/#{user}-#{replay_id.strip}.html"
    puts "#{ptime} #{turns} #{out_file}"
    if ptime > ThisYear && turns.to_i > 5 && !File.exists?(out_file)
      puts link
      page = mech.get(link)
      File.new(out_file, 'w') {|f|
        f.write(page.body)
      }
    end
  }
}
