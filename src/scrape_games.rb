require 'mechanize'
require 'logger'
require 'digest'

mech = Mechanize.new
# mech.log = Logger.new $stderr
# mech.agent.http.debug_output = $stderr
mech.user_agent_alias = 'Mac Safari'
links = []

DateTimeReg = /datetime="([^"]+)/
TimeFormat = "%Y-%m-%dT%H:%M:%SZ"

def parse_datetime(text)
  match = DateTimeReg.match(text)
  if match && match.size > 1
    tm = match[1].strip
    ptime = Time.strptime(tm, TimeFormat)
    return ptime + (3600 * 24 * 365) #Fix bad dates in game
  end
  return nil
end

data_dir = "data/raw/hearthlog"
Dir.foreach(data_dir) {|dir|
  next if dir == "." || dir == ".."
  File.open(File.join(data_dir, dir), 'r') {|f|
    page = Nokogiri::HTML(f.read)
    rows = page.css("tbody > tr")
    rows.each{|row|
      fields = row.css("td")
      if fields.size == 7
        time = parse_datetime(fields[0].to_s)
        if time && time != ""
          result = fields[1].text.strip
          player = fields[2].text.strip
          enemy = fields[4].text.strip
          turns = fields[5].text.strip.to_i
          link = fields[6].css("a").first["href"]
          user = dir.split("-").first
          lsplit = link.split("/")
          replay_id = lsplit[lsplit.size - 2]
          links << [time, result, player, enemy, turns, link, user, replay_id]
        end
      end
    }
  }
}

File.open("data/parsed/replay_links.tsv", "w") {|out|
  links.each{|arr|
    lines = arr.join("\t")
    out.write(lines + "\n")
  }
}