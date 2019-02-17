system("title loading SakuraBot_Echoes")

require 'discordrb' # Download link: https://github.com/meew0/discordrb
require 'open-uri' # pre-installed with Ruby in Windows
require 'net/http'
require_relative 'rot8er_functs' # functions I use commonly in bots

# The bot's token is basically their password, so is censored for obvious reasons
bot = Discordrb::Commands::CommandBot.new token: '>Token<', client_id: 309909087867633664, prefix: ['s!','S!']
bot.bucket :level1, limit: 1, time_span: 300, delay: 100
bot.bucket :level2, limit: 1, time_span: 3600, delay: 100
bot.gateway.check_heartbeat_acks = false

@stats=[]
@embedless=[]

# A.) server data:
#    0.) Server ID number
#    1.) Array of user datas (see B)
#    2.) Array of server-side game data (see C)
#    3.) Default bot-posting channel's ID number
#    4.) Server name
#    5.) whether the bot reads all messages and accepts certain phrases as commands

# B.) user data:
#    0.) User ID number
#    1.) Array of nicknames
#    2.) Whether or not this server considers the user an admin (true/false)
#    3.) a Mention Event for this user
#    4.) Support information for this user - an array with a number and a letter
#    5.) bag information for this user - an array with two numbers

# C.) game data:
#    0.) user ID of user currently holding Sakura (0 for on the ground)
#    1.) whether or not Sakura is in their pocket (true/false)
#    2.) bag data
#    3.) whether or not Sakura's location is public knowledge (true/false)

bot.command(:reboot, from: 167657750971547648) do |event| # reboots Liz
  return nil unless event.user.id==167657750971547648 # only work when used by the developer
  puts 'S!reboot'
  exec "cd C:/Users/Mini-Matt/Desktop/devkit && SakuraBotEchoes.rb"
end

bot.command(:help) do |event, command, command2|
  command='' if command.nil?
  command='' if command.downcase=="module" && (command2.nil? || !['nicknames','nicks','nick','names','name','nickname','game','sakura','sakura_game','sakuragame','admin','admins','administrative','administrator','leader','rot8er','owner','coder','bot','bot_owner','mathoo'].include?(command2.downcase))
  if command.downcase=='help'
    event.respond 'The `help` command displays this message:'
    command=''
  end
  if command.downcase=='addnickname'
    create_embed(event,'**addnickname** __nickname__ __user__',"adds `nickname` to the list of `user`'s nicknames on the server\nif `user` is undefined, adds `nickname` to the list of the invoker's own nicknames\nif neither `nickname` nor `user` is defined, reads the invoker's current display name and adds it to the list of their nicknames\n\nThis command will inform you if the attempted nickname belongs to someone else\nIt will also inform you if the intended recipient already has the intended nickname",0xaa00ff,"In PMs, this command will attempt to add the nickname to your nicknames in all the servers you and the bot share")
  elsif ['census'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","This command performs a census of my subjects, sorting them by gender and size preference.  It will also show how the two categories interact.",0xFFABAF,"This command is unavailable in PMs")
  elsif 'support'==command.downcase
    create_embed(event,"**#{command.downcase}**","Shows how many Support Points I and the invoker have.\n\nYou need 3 Support Points in order to reach C Support.\nYou need 4 Support Points to go from C Support to B Support, which is a total of 7 Support Points from base.\nYou need 4 Support Points to go from B Support to A Support, which is a total of 11 Support Points from base.\nYou need 5 Support Points to go from A Support to A+ Support, which is a total of 16 Support Points from base.\n**Rot8er_ConeX#1737** is, by default, assigned S Support.\n\nEvery post you make in the server, aside from commands to me, has a 1% chance of giving you a Support Point.",0xFFABAF,"This command is unavailable in PMs")
  elsif ['deletenickname','removenickname'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __nickname__","#{command[0,6]}s the nickname `nickname` from the list of the invoker's nicknames.\n\nInforms you if you try to delete nothing.",0xaa00ff,"In PMs, this command will remove the nickname from all the servers you and the bot share.")
  elsif command.downcase=='mynicknames'
    create_embed(event,'**mynicknames**',"Shows a list of the invoker's nicknames on the server",0xaa00ff,"In PMs, this command will show your nicknames in all the servers you and the bot share.")
  elsif command.downcase=='pickup'
    create_embed(event,'**pickup**',"If I am on the ground, this command is used to pick me up\nIf I am not on the ground, this command does nothing.",0xFFABAF,"This command is unavailable in PMs")
  elsif ['cuddle','snuggle','hug','huggle'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","If you are the one holding me, this command causes you to cuddle me, with any consequences thereof being your fault.\n\nIf you are not holding me, this command does nothing.",0xFFABAF,"This command is unavailable in PMs")
  elsif ['headpat','pet','pat'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","If my location is public knowledge, this command causes you to pat my head, with any consequences thereof being your fault.\n\nIf my location is not public knowledge, this command does nothing.",0xFFABAF,"This command is unavailable in PMs")
  elsif command.downcase=='find'
    create_embed(event,'**find**',"If my location is public knowledge, reveals it to all.\nIf not, states so.",0xFFABAF,"This command is unavailable in PMs")
  elsif ['putdown','setdown','floor'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","If you are holding me, this command will set me on the ground.\nIf you are not holding me, this command does nothing.",0xFFABAF,"This command is unavailable in PMs")
  elsif ['toss','throw'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","If you are holding me, this command will toss me in the air.\nThe next person to post will catch me.  If the next post is from a robot, I will land on the floor.\nIf you are not the one holding me, this command does nothing.",0xFFABAF,"This command is unavailable in PMs")
  elsif ['passto','giveto'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","If you are holding me, this command will pass me to the user with the nickname `name`.\nIf you cross out their name (like so: `~~name~~`), I will delete your message and PM the recipient, so that only you and they know where I am.\n\nIf you are not holding me, this command does nothing.\n\n*Tip:* You can technically pass to yourself, which is considered \"moving me to your other hand\".  By doing so and crossing out your name, you will be the only one who knows where I am.",0xFFABAF,"This command is unavailable in PMs")
  elsif command.downcase=='takefrom'
    create_embed(event,'**takefrom** __name__',"If you are holding me, this command will do nothing.\n\nIf you are not the one holding me, this command frisks the user with the nickname `name`.\nIf they are the one holding me, then I will be transferred to your possession, unless they're hiding me in their pocket (which means you'll have to use the `s!pickpocket` command) or in their bag/purse (in which case you wait for me to escape).\nIf you cross out their name (like so: `~~name~~`), I will PM you your victory, and PM them to let them know they are no longer holding me.  This means only you will know where I am.\n\n**Please note that each user can only use this command once every five minutes.**",0xFFABAF,"This command is unavailable in PMs.")
  elsif command.downcase=='pickpocket'
    create_embed(event,'**pickpocket** __name__',"If you are holding me, this command will do nothing.\n\nIf you are not the one holding me, this command pickpockets the user with the nickname `name`.\nIf they are the one holding me, and are hiding me in their pocket, then I will be transferred to your possession.\nIf you cross out their name (like so: `~~name~~`), I will PM you your victory, and PM them to let them know they are no longer holding me.  This means only you will know where I am.\n\n**Please note that each user can only use this command once every hour.**",0xFFABAF,"This command is unavailable in PMs.")
  elsif command.downcase=='pocket'
    create_embed(event,'**pocket**',"If you are holding me, this command will place me in your pocket.\nWhile in your pocket, I cannot be taken from you via the `s!takefrom` command, and you are instead vulnerable to the `s!pickpocket` command, which has a longer cooldown time.\nPlacing me in your pocket has risks, though - there's a small chance I might escape, setting me back on the ground.\n\nIf you are not holding me, this command does nothing.\n\nIf my location is not publically known, it will remain that way because I will delete your message and PM you.",0xFFABAF,"This command is unavailable in PMs")
  elsif ['bag','purse'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","If you are holding me, this command will place me in your #{command.downcase}.\nWhile in your #{command.downcase}, I cannot be taken from you via the `s!takefrom` or `s!pickpocket` commands.\nHowever, once in your #{command.downcase}, I will begin to try to escape - and it takes me anywhere between ten and twenty minutes to do so, depending on the make of #{command.downcase}.\n\nIf you are not holding me, this command does nothing.\n\nIf my location is not publically known, it will become so through the use of this command.\n\n***Note:*** Repeated use of this command in too short a timespan will cause me to escape faster than the mentioned ten-to-twenty-minutes.  Use this command at your own risk.",0xFFABAF,"This command is unavailable in PMs")
  elsif command.downcase=='setchannel'
    create_embed(event,'**setchannel**',"Sets the current channel as the bot's default for this server, for use with the member join/leave messages\n\n**This command is ADMIN-ONLY**",0xff0000,"This command is unavailable in PMs")
  elsif command.downcase=='shortcuts'
    create_embed(event,'**shortcuts** __true/false__',"Sets whether or not I will check all messages for shortcut phrases, such as \"set down Sakura\" which counts as the command `s!putdown`.\nIf not input is included, toggles the current setting,\n\nI will still respond to commands.\n\n**This command is ADMIN-ONLY**",0xff0000,"This command is unavailable in PMs")
  elsif command.downcase=='autofind'
    create_embed(event,'**autofind**',"This command PMs the invoker with my location, even if it is not publicly known.\n\n**This command is ADMIN-ONLY**",0xff0000,"This command is unavailable in PMs")
  elsif command.downcase=='autotake'
    create_embed(event,'**autotake**',"This command allows the invoker to instantly obtain possession of me, regardless of where I am.\n\n**This command is ADMIN-ONLY**",0xff0000,"This command is unavailable in PMs")
  elsif command.downcase=='endgame'
    create_embed(event,'**endgame**',"This command ends the round of the Sakura game, announcing who is holding me and therefore the winner, then setting me on the floor to start another round.\n\n**This command is ADMIN-ONLY**\nNote that an admin cannot end the game if they are the one holding me, as their attempt to end the game could be seen as rigging it.",0xff0000,"This command is unavailable in PMs")
  elsif ['makeadmin','makeguardian','promote'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __nickname__","Grants admin-level command-access to the user with the nickname `nickname`.\n\n**This command is ADMIN-ONLY**, you cannot use it to promote yourself.",0xff0000,"This command is unavailable in PMs")
  elsif ['notanadmin','notaguardian'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","When used by an admin, demotes the invoker from admin status.  For use when an admin wishes to not be special.\n\nFor obvious reasons, **this command is (technically) ADMIN-ONLY**\n~~non-admins can use it but it has no effect~~.\n\nInforms you if there would be no remaining admins if you ceased to be one.",0xff0000,"This command is unavailable in PMs")
  elsif command.downcase=='reboot'
    create_embed(event,'**reboot**',"Reboots the bot, installing any updates.\n\n**This command is only able to be used by Rot8er_ConeX**",0x40C0F0)
  elsif ['liliputia','staff'].include?(command.downcase)
    command='staff~ staff~' if command.downcase=='staff'
    create_embed(event,"**#{command.downcase}**","This is a shortcut command for `s!pickup` followed by `s!pocket` if successful.\nThe responses will be sent via PM, and the invoking message deleted, but my location will still be considered public knowledge.\n\n**This command is only able to be used by Rot8er_ConeX**",0x40C0F0)
  elsif command.downcase=='game'
    create_embed(event,'**game** __str__',"This command shows the extended rules of the game.\nSetting `str` to \"rules\" or \"goal\" will only show the end goal of the game.\nSetting `str` to \"now\" will show only the actions available to you now, considering my current position.",0x0080ff)
  elsif command.downcase=='module'
    event.respond "Command Prefix: `s!`\nYou can also use `s!help` __command__ to learn more about a particular command.#{"\nUse `s!game` to learn more about the game's rules" if ['game','sakura','sakura_game','sakuragame'].include?(command2.downcase)}"
    display_module(1,event,bot) if ['nicknames','nicks','nick','names','name','nickname'].include?(command2.downcase)
    display_module(2,event,bot) if ['game','sakura','sakura_game','sakuragame'].include?(command2.downcase)
    display_module(3,event,bot) if ['admin','admins','administrative','administrator','leader'].include?(command2.downcase)
    display_module(4,event,bot) if ['rot8er','owner','coder','bot','bot_owner','mathoo'].include?(command2.downcase)
  else
    event.respond "#{command.downcase} is not a command." if command.length>0
    event.respond "Command Prefixes: `s!` `S!`\nYou can also use `s!help` __command__ to learn more about a particular command.\nOr `s!help module` __module name__ to just receive one chunk of this reply.\nUse `s!game` to learn more about the game's rules"
    display_module(1,event,bot)
    display_module(2,event,bot)
    unless event.server.nil?
      display_module(3,event,bot) if server_admins(event,bot).include?(event.user.id)
    end
    display_module(4,event,bot) if event.user.id==167657750971547648
  end
  return nil
end

bot.command(:census) do |event|
  if event.server.nil?
    event.respond "This command is unavailable in PM."
    return nil
  end
  h=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
  b=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
  for i in 0...event.server.users.length
    user=event.server.users[i]
    k=0
    for j in 0...user.roles.length
      # sizes
      k+=4  if user.roles[j].name=="giant"
      k+=8  if user.roles[j].name=="tiny"
      k+=12 if user.roles[j].name=="size switcher"
      # gender
      k+=1  if user.roles[j].name=="male"
      k+=2  if user.roles[j].name=="female"
      k+=3  if user.roles[j].name=="non-binary"
    end
    if user.bot_account?
      b[k]+=1
    else
      h[k]+=1
    end
  end
  h.push(h[0]+h[1]+h[2]+h[3])
  h.push(h[4]+h[5]+h[6]+h[7])
  h.push(h[8]+h[9]+h[10]+h[11])
  h.push(h[12]+h[13]+h[14]+h[15])
  b.push(b[0]+b[1]+b[2]+b[3])
  b.push(b[4]+b[5]+b[6]+b[7])
  b.push(b[8]+b[9]+b[10]+b[11])
  b.push(b[12]+b[13]+b[14]+b[15])
  h.push(h[0]+h[4]+h[8]+h[12])
  h.push(h[1]+h[5]+h[9]+h[13])
  h.push(h[2]+h[6]+h[10]+h[14])
  h.push(h[3]+h[7]+h[11]+h[15])
  b.push(b[0]+b[4]+b[8]+b[12])
  b.push(b[1]+b[5]+b[9]+b[13])
  b.push(b[2]+b[6]+b[10]+b[14])
  b.push(b[3]+b[7]+b[11]+b[15])
  h.push(h[16]+h[17]+h[18]+h[19])
  b.push(b[16]+b[17]+b[18]+b[19])
  u=[]
  for i in 0...b.length
    if b[i]>0
      u.push("#{h[i]} *+#{b[i]}*")
    else
      u.push("#{h[i]}")
    end
  end
  for i in 0...4
    u[4*i]="#{u[4*i]} of unspecified gender" unless u[4*i]=="0"
    u[4*i+1]="#{u[4*i+1]} males" unless u[4*i+1]=="0"
    u[4*i+2]="#{u[4*i+2]} females" unless u[4*i+2]=="0"
    u[4*i+3]="#{u[4*i+3]} non-binaries" unless u[4*i+3]=="0"
  end
  u[16]="#{u[16]} of unspecified size" unless u[16]=="0"
  u[17]="#{u[17]} giants" unless u[17]=="0"
  u[18]="#{u[18]} tinies" unless u[18]=="0"
  u[19]="#{u[19]} size-shifters" unless u[19]=="0"
  u[20]="#{u[20]} of unspecified gender" unless u[20]=="0"
  u[21]="#{u[21]} males" unless u[21]=="0"
  u[22]="#{u[22]} females" unless u[22]=="0"
  u[23]="#{u[23]} non-binaries" unless u[23]=="0"
  u[24]="#{u[24]} total"
  n="\n"
  create_embed(event,"__**#{event.server.name} census totals**__","**#{u[24]}**",0xFFABAF,nil,event.server.icon_url,[["Sizes","#{"#{u[16]}" unless u[16]=="0"}#{"#{n}#{u[17]}" unless u[17]=="0"}#{"#{n}#{u[18]}" unless u[18]=="0"}#{"#{n}#{u[19]}" unless u[19]=="0"}"],["Genders","#{"#{u[20]}" unless u[20]=="0"}#{"#{n}#{u[21]}" unless u[21]=="0"}#{"#{n}#{u[22]}" unless u[22]=="0"}#{"#{n}#{u[23]}" unless u[23]=="0"}"]])
  b=[u[0],u[1],u[2],u[3]]
  for i in 0...b.length
    b[i]=nil if b[i]=="0"
  end
  b.compact!
  s1="#{"#{u[4]}" unless u[4]=="0"}#{"#{n}#{u[5]}" unless u[5]=="0"}#{"#{n}#{u[6]}" unless u[6]=="0"}#{"#{n}#{u[7]}" unless u[7]=="0"}"
  s2="#{"#{u[8]}" unless u[8]=="0"}#{"#{n}#{u[9]}" unless u[9]=="0"}#{"#{n}#{u[10]}" unless u[10]=="0"}#{"#{n}#{u[11]}" unless u[11]=="0"}"
  s3="#{"#{u[12]}" unless u[12]=="0"}#{"#{n}#{u[13]}" unless u[13]=="0"}#{"#{n}#{u[14]}" unless u[14]=="0"}#{"#{n}#{u[15]}" unless u[15]=="0"}"
  flds=[]
  flds.push(['Giants',s1]) unless s1.length==0
  flds.push(['Tinies',s2]) unless s2.length==0
  flds.push(['Size-shifters',s3]) unless s3.length==0
  flds=nil if flds.length.zero?
  create_embed(event,"__**#{event.server.name} census data**__","#{"**Unspecified size:** #{b.join(', ')}" unless b.length==0 || b.nil?}",0xFFABAF,nil,nil,flds)
end

def display_module(v,event,bot)
  case v
  when 1
    create_embed(event,"__**Nicknames**__","`addnickname` __nickname__ __user__\n`deletenickname` __nickname__ *also `removenickname`*\n`mynicknames`",0xaa00ff)
  when 2
    create_embed(event,"__**The Sakura Game**__","__When I'm on the ground__\n`pickup`\n\n__When you're holding me__\n`putdown` *also `setdown` or `floor`*\n`pocket`\n`bag` or `purse`\n`passto` __name__\n`toss` *also `throw`*\n`cuddle` *also `snuggle` or `hug`*\n\n__When someone else is holding me__\n`takefrom` __name__\n`pickpocket` __name__\n\n__Any time__\n`find`\n`headpat` *also `pet`*",0xFFABAF,"These commands are unavailable in PMs.")
  when 3
    create_embed(event,"__**Admin**__","__game__\n`autofind`\n`autotake`\n`endgame`\n\n__general admin__\n`setchannel`\n`promote` __user__ *also `makeadmin` or `makeguardian`*\n`notanadmin` *also `notaguardian`*\n\n`shortcuts`",0xff0000,"These commands are unavailable in PMs, and the ones that are crossed out aren't yet coded.")
  when 4
    create_embed(event,"__**Bot Owner**__","`reboot`\n`liliputia` *also `staff`*",0x40C0F0,"These commands are exclusive to Rot8er_ConeX")
  when 5
    desc="You can use the command `s!pickup` to pick me up.  I will then be in your possession until someone else takes me from you or you give me to someone."
    unless event.server.nil?
      j=find_server_data(event,bot)
      desc="#{desc}\n*Including the phrase \"pick up Sakura\" or \"picks up Sakura\" in your message will also count.*" if @stats[j][5]
    end
    create_embed(event,"__**When I'm on the ground**__",desc,0xFFABAF)
  when 6
    desc1="You can use the command `s!putdown` or `s!setdown` to place me back on the ground.  I will then no longer be in your possession."
    desc2="You can use the command `s!pocket` to place me in your pocket.  Other players will no longer be able to use the `s!takefrom` command to take you from me, and must instead resort to using the `s!pickpocket` command."
    desc3="You can use the command `s!bag` or `s!purse` to place me in your bag or purse, respectively (the two commands are identical in all but cosmetics).  I cannot be taken from you via the `s!takefrom` or `s!pickpocket` commands, but I will escape after anywhere between ten and twenty minutes."
    desc4="You can use the command `s!toss` or `s!throw` to toss me into the air.  The next person to post will catch me."
    desc5="You can use the command `s!cuddle`, `s!snuggle`, or `s!hug` to cuddle me.  The consequences of this action will be your fault!"
    unless event.server.nil?
      j=find_server_data(event,bot)
      if @stats[j][5]
        desc1="#{desc1}\n*Including the phrase \"put down Sakura\", \"puts down Sakura\", \"set down Sakura\", or \"sets down Sakura\" in your message will also count.*"
        desc2="#{desc2}\n*Including any of the verbs down below, followed by either \"Sakura in my pocket\" or \"Sakura in pocket\", in your message will also count.  As do including the phrases \"pockets Sakura\" and \"pocket Sakura\".*"
        desc3="#{desc3}\n*Including any of the verbs down below, followed by either \"Sakura in my (bag/purse)\" or \"Sakura in (bag/purse)\", in your message will also count.  As do including the phrases \"bags Sakura\" and \"bag Sakura\".*"
        desc4="#{desc4}\n*Including the phrase \"toss Sakura\", \"tosses Sakura\", \"throw Sakura\", or \"throws Sakura\" in your message will also count.*"
        desc5="#{desc5}\n*Including the phrase \"cuddle Sakura\", \"cuddles Sakura\", \"snuggle Sakura\", \"snuggles Sakura\", \"hug Sakura\", or \"hugs Sakura\" in your message will also count.*"
        f="Movement verbs: put, place, set, slip, slide, puts, places, sets, slips, slides"
      end
    end
    create_embed(event,"__**When I'm in your possession**__","#{desc1}\n\n#{desc2}\n\n#{desc3}\n\nYou can use the command `s!passto Name` to pass me to another user.  Crossing out their name like `s!passto ~~Name~~` will pass me to them in secret.  This transfers possession to them.\n\n#{desc4}\n\n#{desc5}",0xFFABAF,f)
  when 7
    create_embed(event,"__**When I'm in someone else's possession**__","Once every five minutes, you can use the `s!takefrom Name` command to try to take me from someone.  If your guess as to who is holding me is correct and I am not in their pocket, bag, or purse, then I will be trasferred to your possession\nYou can also cross out their name like this: `s!takefrom ~~Name~~`, then you will take me from them in secret.\n\nOnce every hour, you can use the `s!pickpocket Name` command to try to take me from someone's pocket.  If your guess as to who is hiding me in their pocket is correct, then I will be transferred to your possession.\nYou can also cross out their name like this: `s!pickpocket ~~Name~~`, then you will pickpocket them in secret.",0xFFABAF)
  when 8
    create_embed(event,"__**At any time**__","You can use the command `s!find` to find me.  If my location is public knowledge, then I will repeat it.  If my location is not public knowledge, I will say so.\n\nYou can use the command `s!headpat` or `s!pet` to pat my head.  The consequences of this action will be your fault!",0xFFABAF)
  when 9
    create_embed(event,"__**GAME RULES**__","The goal of the game is to be the one holding me, Sakura, when the game ends.  However, when the game ends is unknown.\n\nIn this manner, the game is similar to Hot Potato, except in reverse - as in, you *want* the potato.",0x0080ff)
  end
end

def metadata_load()
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/SakuraSave.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/SakuraSave.txt').each_line do |line|
      b.push(eval line)
    end
  else
    b=[[]]
  end
  @embedless=b[0]
end

def metadata_save() # saves the metadata
  x=@embedless.map{|q| q}
  open('C:/Users/Mini-Matt/Desktop/devkit/SakuraSave.txt', 'w') { |f|
    f.puts x.to_s
    f.puts "\n"
  }
end

bot.command(:game) do |event, rtime|
  rtime='' if rtime.nil?
  if rtime.downcase=='now' && !event.server.nil?
    j=find_server_data(event,bot)
    display_module(5,event,bot) if @stats[j][2][0]==0
    display_module(6,event,bot) if @stats[j][2][0]==event.user.id
    display_module(7,event,bot) if @stats[j][2][0]>0 && @stats[j][2][0]!=event.user.id
    display_module(8,event,bot)
    display_module(9,event,bot)
  elsif rtime.downcase=='rules' || rtime.downcase=='goal'
    display_module(9,event,bot)
  else
    display_module(5,event,bot)
    display_module(6,event,bot)
    display_module(7,event,bot)
    display_module(8,event,bot)
    display_module(9,event,bot)
  end
end

def generate_stats_list(bot)
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/SakuraBotEchoes.sav')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/SakuraBotEchoes.sav').each_line do |line|
      b.push(line.gsub("\n",''))
    end
    b=b.join("\n").split("\n\n\n").map{|q| q.split("\n\n").map{|q2| q2.split("\n").map{|q3| (eval q3)}}}
    for i in 0...b.length
      b[i][1]=b[i][1,b[i].length-1]
      b[i]=b[i][0,2]
      for i2 in 1...b[i][0].length
        b[i].push(b[i][0][i2])
      end
      b[i][0]=b[i][0][0]
    end
    @stats=b.map{|q| q}
    for i in 0...bot.servers.values.length
      server=bot.servers.values[i]
      if find_server_data_from_id(server.id,bot)<0
        chn=server.general_channel
        if chn.nil?
          chnn=[]
          for i in 0...server.channels.length
            chnn.push(server.channels[i]) if bot.user(bot.profile.id).on(server.id).permission?(:send_messages,server.channels[i])
          end
          chn=chnn[0] if chnn.length>0
        end
        @stats.push([server.id,[],[0,false,[false,''],true],chn.id,server.name,true])
        for j in 0...server.users.length
          user=server.users[j]
          @stats[@stats.length-1][1].push([user.id,[user.distinct,user.name,user.display_name],false,[0,''],[0,0]]) if !user.bot_account?
          @stats[@stats.length-1][1][@stats[@stats.length-1][1].length-1][2]=true if user.id==167657750971547648 # automatic admin privleges for bot coder
          @stats[@stats.length-1][1][@stats[@stats.length-1][1].length-1][3][1]='S' if user.id==167657750971547648 # automatic S Support for bot coder
        end
        begin
          bot.channel(@stats[@stats.length-1][3]).send_embed("**H-Hello!  I'm S-Sakura.  When d-did I get here?**") do |embed|
            embed.color=0xFFABAF
            f=@stats[@stats.length-1][1].reject{|q| !q[2]}.map{|q| "<@#{q[0]}>"}
            embed.description="#{f.join(' ')}\n\n1.) As of right now, the user#{'s' if f.length>1} listed above #{'is' if f.length==1}#{'are' if f.length>1} my only guardian#{'s' if f.length>1}.  They should use the `s!promote >Name<` command to promote others so they are also my guardians.  (Don't @ the user you wish to promote, just type their name).\n\n2.) I make commentary when members leave or join the server.  Please use the command `s!setchannel` in the channel where you want these messages displayed.\n\n3.) By default, I respond to messages that include shortcut phrases - for example, including \"pickup Sakura\" in your message will be identical to performing the `s!pickup` command.  Use the command `s!shortcuts` to toggle this functionality off for this server.\n\n4.) Use the command `s!help` for more information."
          end
        rescue
          puts "#{server.name} (#{server.id}) is not allowing me to post in the right channel."
        end
      else
        for j in 0...server.users.length
          user=server.users[j]
          m=-1
          for k in 0...@stats.length
            m=k if @stats[k][0]==server.id
          end
          if find_user_data_from_id(server.id,user.id,bot)<0 && !user.bot_account?
            find_channel_from_server_id(@stats[i][3],server.id,bot).send_message("#{user.name[0,1]}-#{user.name}?  Wh-When did you get here?") rescue nil
            @stats[m][1].push([user.id,[user.distinct,user.name,user.display_name],false,[0,''],[0,0]])
            @stats[m][1][@stats[m][@stats.length-1][1].length-1][2]=true if user.id==167657750971547648 # automatic admin privleges for bot coder
            @stats[m][1][@stats[m][@stats.length-1][1].length-1][3][1]='S' if user.id==167657750971547648 # automatic S Support for bot coder
          end
        end
      end
    end
    for j in 0...@stats.length
      for i in 0...@stats[j][1].length
        @stats[j][1][i][4]=[0,0] if @stats[j][1][i][4].nil?
      end
    end
  else
    @stats=[]
    for i in 0...bot.servers.values.length
      server=bot.servers.values[i]
      @stats.push([server.id,[],[0,false,[false,''],true],server.general_channel.id,server.name,true])
      for j in 0...server.users.length
        user=server.users[j]
        @stats[@stats.length-1][1].push([user.id,[user.distinct,user.name,user.display_name],false,[0,''],[0,0]]) if !user.bot_account?
        @stats[@stats.length-1][1][@stats[@stats.length-1][1].length-1][2]=true if user.id==167657750971547648 # automatic admin privleges for bot coder
        @stats[@stats.length-1][1][@stats[@stats.length-1][1].length-1][3][1]='S' if user.id==167657750971547648 # automatic S Support for bot coder
      end
    end
  end
  save_stats_data()
end

def save_stats_data()
  open('C:/Users/Mini-Matt/Desktop/devkit/SakuraBotEchoes.sav', 'w') { |f|
    f << @stats.to_s
  }
  s=@stats.map{|q| q}
  open('C:/Users/Mini-Matt/Desktop/devkit/SakuraBotEchoes.sav', 'w') { |f|
    for i in 0...s.length
      f << s[i][0]
      f << "\n"
      f << s[i][2]
      f << "\n"
      f << s[i][3]
      f << "\n\""
      f << s[i][4]
      f << "\"\n"
      f << s[i][5]
      f << "\n"
      f << "\n"
      for i2 in 0...s[i][1].length
        f << s[i][1][i2][0]
        f << "\n"
        f << s[i][1][i2][1]
        f << "\n"
        f << s[i][1][i2][2]
        f << "\n"
        f << s[i][1][i2][3]
        f << "\n"
        f << s[i][1][i2][4]
        f << "\n"
        f << "\n"
      end
      f << "\n"
    end
  }
end

def find_server_data(event,bot)
  generate_stats_list(bot) if @stats.length.zero?
  j=-1
  for i in 0...@stats.length
    j=i if @stats[i][0]==event.server.id
  end
  return j
end

def find_user_data(event,bot)
  j=find_server_data(event,bot)
  for i in 0...@stats[j][1].length
    return i if @stats[j][1][i][0]==event.user.id
  end
end

def find_server_data_from_id(id,bot)
  j=-1
  for i in 0...@stats.length
    j=i if @stats[i][0]==id
  end
  return j
end

def find_user_data_from_id(sid,id,bot)
  j=find_server_data_from_id(sid,bot)
  for i in 0...@stats[j][1].length
    return i if @stats[j][1][i][0]==id
  end
  return -1
end

def count_admins(event,bot,user_to_exclude=0)
  j=find_server_data(event,bot)
  a=0
  for i in 0...@stats[j][1].length
    a+=1 if @stats[j][1][i][2] && @stats[j][1][i][0]!=user_to_exclude
  end
  return a
end

def name_check(nick,event,bot)
  j=find_server_data(event,bot)
  for i in 0...@stats[j][1].length
    k = @stats[j][1][i][1].map{|s| s.downcase}
    return @stats[j][1][i][0] if k.include?(nick.downcase)
  end
  for i in 0...@stats[j][1].length
    k = @stats[j][1][i][1].map{|s| s.downcase[0,[nick.length,s.length].min]}
    return @stats[j][1][i][0] if k.include?(nick.downcase)
  end
  if nick.to_i.to_s==nick && nick.to_i>1000000000000000
    return nick.to_i if !bot.user(nick.to_i).on(event.server.id).nil?
  end
  if /<@!?(?:\d+)>/ =~ event.message.text
    usr=event.message.mentions[0]
    return usr.id
  end
  return 0
end

def find_name_from_id(uid,event,bot)
  j=find_server_data(event,bot)
  for i in 0...@stats[j][1].length
    return @stats[j][1][i][1][[2,@stats[j][1][i][1].length-1].min] if @stats[j][1][i][0]==uid
  end
  return ''
end

def find_user_from_id(uid,event,bot)
  j=find_server_data(event,bot)
  for i in 0...event.server.users.length
    return event.server.users[i] if event.server.users[i].id==uid
  end
  return bot.profile
end

def check_for_admin?(event,bot)
  j=find_server_data(event,bot)
  for i in 0...@stats[j][1].length
    return @stats[j][1][i][2] if @stats[j][1][i][0]==event.user.id
  end
end

def find_channel(chid,event)
  for i in 0...event.server.channels.length
    return event.server.channels[i] if event.server.channels[i].id==chid
  end
  return event.server.general_channel
end

def find_channel_from_server_id(chid,sid,bot)
  for i in 0...bot.servers.values.length
    if bot.servers.values[i].id==sid
      for j in 0...bot.servers.values[i].channels.length
        return bot.servers.values[i].channels[j] if bot.servers.values[i].channels[j].id==chid
      end
      return bot.servers.values[i].general_channel
    end
  end
end

def extend_message(msg1,msg2,event,enters=1)
  if "#{msg1}#{"\n"*enters}#{msg2}".length>=2000
    event.respond msg1
    return msg2
  else
    return "#{msg1}#{"\n"*enters}#{msg2}"
  end
end

def server_admins(event,bot)
  j=find_server_data(event,bot)
  f=[]
  for i in 0...@stats[j][1].length
    f.push(@stats[j][1][i][0]) if @stats[j][1][i][2]
  end
  return f
end

def pickup(event,bot,two_parter=false)
  if event.server.nil?
    event.respond "This command c-cannot be used in a PM"
    return nil
  elsif event.user.bot_account?
    event.respond "M-Metal is cold and h-hard.  S-Sorry, bot, but I don't feel c-comfortable in your grip."
    return nil
  end
  j=find_server_data(event,bot)
  i=find_user_data(event,bot)
  if @stats[j][2][0]==0 # This server's Sakura is on the ground
    @stats[j][2][0]=event.user.id
    if !two_parter
      if event.user.id==167657750971547648 # picked up by bot owner
        event.respond "^^ \\*cuddles, motions hands toward your pocket*"
      elsif check_for_admin?(event,bot) # picked up by bot admin on this server
        event.respond "Hello, #{event.user.display_name[0,1]}-#{event.user.display_name}"
      else # picked up by anyone else
        event.respond "\\*flails* P-Put me down!" if ['','-'].include?(@stats[j][1][i][3][1])
        event.respond "P-Put me d-down, p-please." if @stats[j][1][i][3][1]=='C'
        event.respond "Huh? \\*looks around, confused*" if @stats[j][1][i][3][1]=='B'
        event.respond "O-Oh, hello." if @stats[j][1][i][3][1]=='A'
        event.respond "Hello, #{event.user.display_name[0,1]}-#{event.user.display_name}" if @stats[j][1][i][3][1]=='A+'
      end
    else
      return true
    end
  elsif @stats[j][2][0]==event.user.id # user is already holding her
    if !two_parter
      if event.user.id==167657750971547648
        event.respond "You're already h-holding me, silly.  \\*cuddles*"
      elsif check_for_admin?(event,bot)
        event.respond "You're a-already holding me, silly."
      else # picked up by anyone else
        event.respond "You're a-already holding me."
      end
    else
      return true
    end
  elsif two_parter
    return false
  elsif @stats[j][2][1] # in someone else's pocket
    event.respond "\\*slightly muffled* I'm n-not on the ground."
  elsif @stats[j][2][2][0] # in someone else's bag/purse
    event.respond "\\*muffled noises*"
  else
    event.respond "I'm n-not on the ground."
  end
  save_stats_data()
  return nil
end

def putdown(event,bot)
  if event.server.nil?
    event.respond "This command c-cannot be used in a PM"
    return nil
  elsif event.user.bot_account?
    event.respond "M-Metal is cold and h-hard.  S-Sorry, bot, but I don't feel c-comfortable in your grip."
    return nil
  end
  j=find_server_data(event,bot)
  if @stats[j][2][0]==event.user.id # user is holding this server's Sakura
    @stats[j][2]=[0,false,[false,''],true]
    if event.user.id==167657750971547648
      event.respond "\\*pouts*"
    elsif check_for_admin?(event,bot)
      event.respond 'Oh, O-Okay.'
    else
      event.respond 'Th-Thank you'
    end
  elsif @stats[j][2][1] # in someone else's pocket
    event.respond "\\*slightly muffled* You're n-not holding me."
  elsif @stats[j][2][2][0] # in someone else's bag/purse
    event.respond "\\*muffled noises*"
  else
    event.respond "You are not h-holding me."
  end
  save_stats_data()
  return nil
end

def pocket_sakura(event,bot,a=5,b=8,liliputia=false)
  if event.server.nil?
    event.respond "This command c-cannot be used in a PM"
    return nil
  elsif event.user.bot_account?
    event.respond "M-Metal is cold and h-hard.  S-Sorry, bot, but I don't feel c-comfortable in your grip."
    return nil
  end
  j=find_server_data(event,bot)
  if @stats[j][2][0]==event.user.id # user is holding this server's Sakura
    event.message.delete if !@stats[j][2][3]
    @stats[j][2][1]=true
    @stats[j][2][2]=[false,'']
    if !@stats[j][2][3] # location not publically known
      event << "\\*muffled noises*"
      if !server_admins(event,bot).include?(event.user.id)
        if rand(100)<a
          event << "\\*rips hole in pocket, escapes*"
          @stats[j][2]=[0,false,[false,''],true]
        else
          event.user.pm("I am now in your pocket. *#{event.server.name}*")
        end
      elsif event.user.id==167657750971547648
        event.user.pm("\\*cuddles*")
      elsif rand(10000)<a
        event << "\\*rips hole in pocket, escapes*"
        @stats[j][2]=[0,false,[false,''],true]
      else
        event.user.pm("I am now in your pocket. *#{event.server.name}*")
        event.respond "You are not holding me."
      end
    elsif liliputia
      event.user.pm("^^ \\*snuggles* Mmm, toasty.")
    elsif event.user.id==167657750971547648
      event.respond "\\*snuggles* Mmm, toasty."
    else
      event << "\\*struggles*"
      if rand(100)<b
        event << "\\*rips hole in pocket, escapes*"
        @stats[j][2]=[0,false,[false,''],true]
      end
    end
  elsif @stats[j][2][1] # in someone else's pocket
    event.respond "\\*slightly muffled* You're not holding me."
  elsif @stats[j][2][2][0] # in someone else's bag/purse
    event.respond "\\*muffled noises*"
  else
    event.respond "You are not holding me."
  end
  save_stats_data()
  return nil
end

def bag_check(event,bot)
  j=find_server_data(event,bot)
  i=find_user_data(event,bot)
  t=Time.now.to_i
  if t-@stats[j][1][i][4][0]<18000 # less than five hours since the last time you tried to bag her
    @stats[j][1][i][4][1]+=1 # increment by 1
  else
    @stats[j][1][i][4][1]=1 # reset counter
  end
  @stats[j][1][i][4][0]=t
  save_stats_data()
  return true if @stats[j][1][i][4][1]>=4 # three bagging sessions
  return false
end

def bag_purse(event,bot,container)
  if event.server.nil?
    event.respond "This command c-cannot be used in a PM"
    return nil
  elsif event.user.bot_account?
    event.respond "M-Metal is cold and h-hard.  S-Sorry, bot, but I don't feel c-comfortable in your grip."
    return nil
  elsif @stats[find_server_data(event,bot)][2][0]!=event.user.id
  elsif bag_check(event,bot)
    event.respond "I'm n-not going b-back there!  N-Not yet, at least."
    return nil
  end
  j=find_server_data(event,bot)
  if @stats[j][2][0]==event.user.id # user is holding this server's Sakura
    @stats[j][2][3]=true # Due to the fact that she cannot be taken away while in a bag/purse, her location will always be public knowledge, for game balance
    @stats[j][2][1]=false # no longer in their pocket
    if @stats[j][2][2][0]
      event.respond "I'm a-already in your #{@stats[j][2][2][1][0,1]}-#{@stats[j][2][2][1]}"
    else
      @stats[j][2][2]=[true,container,event.user.id]
      event.respond "I am n-now in your #{container}"
      sleep rand((10*60)..(20*60))
      if @stats[j][2][2][0] && @stats[j][2][2][2]==event.user.id
        event.respond "I have escaped fr-from #{event.user.name}'s #{@stats[j][2][2][1][0,1]}-#{@stats[j][2][2][1]}"
        @stats[j][2]=[0,false,[false,''],true]
      end
    end
  elsif @stats[j][2][1] # in someone else's pocket
    event.respond "\\*slightly muffled* You're not h-holding me."
  elsif @stats[j][2][2][0] # in someone else's bag/purse
    event.respond "\\*muffled noises*"
  else
    event.respond "You are not h-holding me."
  end
  save_stats_data()
  return nil
end

def toss(event,bot)
  if event.server.nil?
    event.respond "This command c-cannot be used in a PM"
    return nil
  elsif event.user.bot_account?
    event.respond "M-Metal is cold and h-hard.  S-Sorry, bot, but I don't feel c-comfortable in your grip."
    return nil
  end
  j=find_server_data(event,bot)
  if event.user.id != @stats[j][2][0]
    if @stats[j][2][1]
      event.respond "\\*slightly muffled* You're not h-holding me."
    elsif @stats[j][2][2][0]
      event.respond "\\*muffled noises*"
    else
      event.respond "You're not h-holding me."
    end
  else
    event.respond "Ahh!"
    event.channel.await(:bob) { |event2|
       if event2.user.bot_account?
         @stats[j][2]=[0,false,[false,''],true]
         event2.respond "\\*lands on floor* Ow."
       else
         @stats[j][2][0]=event2.user.id
         @stats[j][2][1]=false
         @stats[j][2][2]=[false,'']
         @stats[j][2][3]=true
         event.respond "Th-Thank you for catching me, #{event2.user.name[0,1]}-#{event2.user.name}.#{"\n\\*cuddles*" if event2.user.id==167657750971547648}"
       end
       save_stats_data()
    }
    return nil
  end  
end

def find_sakura(event,bot,admin=false)
  event.message.delete if admin
  if event.server.nil?
    event.respond "This command c-cannot be used in a PM"
    return nil
  elsif !check_for_admin?(event,bot) && admin
    event.respond "You do not have permission to use this command."
    return nil
  elsif event.user.bot_account?
    event.respond "M-Metal is cold and h-hard.  S-Sorry, bot, but I don't feel c-comfortable in your grip."
    return nil
  end
  j=find_server_data(event,bot)
  h="#{find_user_from_id(@stats[j][2][0],event,bot).name}'s"
  h="your" if @stats[j][2][0]==event.user.id
  if @stats[j][2][0]==0 # on the floor
    message_react("I am on the floor.",event,bot,admin)
  elsif @stats[j][2][2][0] # in holder's bag/purse
    message_react("I am in #{h} #{@stats[j][2][2][1]}, and attempting to escape.",event,bot,admin)
  elsif !@stats[j][2][3] && !admin # location is not public knowledge
    event.respond "#{"\\*slightly muffled* " if @stats[j][2][1]}#{"\\*muffled* " if @stats[j][2][2][0]}My location is not public knowledge."
    if event.user.id==@stats[j][2][0]
      if @stats[j][2][1] # in holder's bag/purse
        event.user.pm("I am in your pocket. *#{event.server.name}*")
      else
        event.user.pm("I am in your hand. *#{event.server.name}*")
      end
    end
  elsif @stats[j][2][1] # in holder's pocket
    message_react("#{'~~' unless @stats[j][2][3]}I am in #{h} pocket.#{'~~' unless @stats[j][2][3]}",event,bot,admin)
  else
    message_react("#{'~~' unless @stats[j][2][3]}I am in #{h} hand.#{'~~' unless @stats[j][2][3]}",event,bot,admin)
  end
  return nil
end

def cuddle(event,bot)
  if event.server.nil?
    if event.user.id==167657750971547648
      event.respond "\\*cuddles back, hums happily*"
    else
      event.respond "This command c-cannot be used in a PM"
    end
  elsif event.user.bot_account?
    event.respond "M-Metal is cold and h-hard.  S-Sorry, bot, but I don't feel c-comfortable in your grip."
    return nil
  else
    j=find_server_data(event,bot)
    i=find_user_data(event,bot)
    if event.user.id != @stats[j][2][0]
      if @stats[j][2][1]
        event.respond "\\*slightly muffled* You're not h-holding me."
      elsif @stats[j][2][2][0]
        event.respond "\\*muffled noises*"
      else
        event.respond "You're not h-holding me."
      end
    elsif event.user.id==167657750971547648
      event.respond "\\*cuddles back, hums happily*"
    elsif check_for_admin?(event,bot)
      event.respond "\\*cuddles back*"
    else
      event.respond "\\*pushes away* I m-may be small and c-cute, but I'm not a st-stuffed animal." if ['','-'].include?(@stats[j][1][i][3][1])
      event.respond "\\*pushes away* P-Please don't." if @stats[j][1][i][3][1]=='C'
      event.respond "\\*halfheartedly pushes away*" if @stats[j][1][i][3][1]=='B'
      event.respond "\\*teasingly pushes away, then cuddles*" if @stats[j][1][i][3][1]=='A'
      event.respond "\\*cuddles back*" if @stats[j][1][i][3][1]=='A+'
    end
  end
  return nil
end

def headpat(event,bot)
  if event.server.nil?
    if event.user.id==167657750971547648
      event.respond "\\*leans into the pat, hums happily*"
    else
      event.respond "This command c-cannot be used in a PM"
    end
  elsif event.user.bot_account?
    event.respond "M-Metal is cold and h-hard.  S-Sorry, bot, but I don't feel c-comfortable in your grip."
    return nil
  else
    j=find_server_data(event,bot)
    i=find_user_data(event,bot)
    if !@stats[j][2][3]
      event.respond "How c-can you headpat me i-if you don't know wh-where I am?"
    elsif event.user.id==167657750971547648
      event.respond "\\*leans into the pat, hums happily*"
    elsif check_for_admin?(event,bot)
      event.respond "\\*leans into the pat*"
    else
      event.respond "\\*pushes away* I m-may be small and c-cute, but I'm not a p-pet." if ['','-'].include?(@stats[j][1][i][3][1])
      event.respond "\\*pushes away* P-Please don't." if @stats[j][1][i][3][1]=='C'
      event.respond "\\*halfheartedly pushes away*" if @stats[j][1][i][3][1]=='B'
      event.respond "\\*teasingly pushes away, then leans into the pat*" if @stats[j][1][i][3][1]=='A'
      event.respond "\\*leans into the pat*" if @stats[j][1][i][3][1]=='A+'
    end
  end
  return nil
end

def heal(event)
  event.respond "\\*uses Sakura's Rod, heals #{event.user.name} for 7 HP*"
end

def message_react(message,event,bot,admin=false)
  if admin
    event.user.pm("#{message} (*#{event.server.name}*)")
  else
    event.respond message
  end
end

def message_disp(response,event,bot,response2="You are not holding me.")
  j=find_server_data(event,bot)
  if @stats[j][2][3]
    event.respond response
  else
    event.user.pm("#{response} (#{event.server.name})")
    event.respond response2
  end
  return nil
end

def remove_format(s,format)
  if format.length==1
    s=s.gsub("#{'\\'[0,1]}#{format}",'')
  else
    s=s.gsub("#{'\\'[0,1]}#{format}",format[1,format.length-1])
  end
  for i in 0...[s.length,25].min
    f=s.index(format)
    unless f.nil?
      f2=s.index(format,f+format.length)
      unless f2.nil?
        s="#{s[0,f]}|#{s[f2+format.length,s.length-f2-format.length+1]}"
      end
    end
  end
  return s
end

def greeting(event,bot)
  j=find_server_data(event,bot)
  f=@stats[j][1].reject{|q| !q[2]}.map{|q| "<@#{q[0]}>"}
  begin
    find_channel(@stats[j][3],event).send_embed("**H-Hello!  I'm S-Sakura.**") do |embed|
      embed.color=0xFFABAF
      embed.description="#{f.join(' ')}\n\n1.) As of right now, the user#{'s' if f.length>1} listed above #{'is' if f.length==1}#{'are' if f.length>1} my only guardian#{'s' if f.length>1}.  They should use the `s!promote >Name<` command to promote others so they are also my guardians.  (Don't @ the user you wish to promote, just type their name).\n\n2.) I make commentary when members leave or join the server.  Please use the command `s!setchannel` in the channel where you want these messages displayed.\n\n3.) By default, I respond to messages that include shortcut phrases - for example, including \"pickup Sakura\" in your message will be identical to performing the `s!pickup` command.  Use the command `s!shortcuts` to toggle this functionality off for this server.\n\n4.) Use the command `s!help` for more information."
    end
  rescue
    puts "#{event.server.name} (#{event.server.id}) is not allowing me to post in the right channel."
  end
end

def cross_update(bot, sid)
  bot.channel(348252564170473472).send_message('l!update') if sid==348221024740966402
  bot.channel(435070983360217089).send_message('l!update') if sid==435068874862362636
  bot.channel(310890160122494996).send_message('c!update') if sid==348221024740966402
  bot.channel(435070983360217089).send_message('c!update') if sid==435068874862362636
end

bot.command([:healme,:heal]) do |event|
  heal(event)
end

bot.command(:alladmins) do |event|
  if event.server.nil?
    event.respond "This command c-cannot be used in a PM"
    return nil
  end
  j=find_server_data(event,bot)
  f=[]
  for i in 0...@stats[j][1].length
    f.push(@stats[j][1][i][1][1]) if @stats[j][1][i][2]
  end
  create_embed(event,"__**admins**__",f.join("\n"),0xff0000)
end

bot.command(:shortcuts) do |event, m|
  if event.server.nil?
    event.respond "This command c-cannot be used in a PM"
    return nil
  elsif !check_for_admin?(event,bot)
    event.respond "You do not have permission to use this command."
    return nil
  end
  j=find_server_data(event,bot)
  @stats[j][5]=!@stats[j][5]
  unless m.nil?
    @stats[j][5]=true if ['on','yes','true'].include?(m.downcase)
    @stats[j][5]=false if ['off','no','false'].include?(m.downcase)
  end
  save_stats_data()
  event.respond "I w-will #{"no longer " unless @stats[j][5]}r-respond to sh-shortcut phrases on this s-server."
end

bot.command(:pickup) do |event|
  pickup(event,bot)
end

bot.command([:putdown,:setdown,:floor]) do |event|
  putdown(event,bot)
end

bot.command(:pocket) do |event|
  pocket_sakura(event,bot,5,8,false)
end

bot.command(:bag) do |event|
  bag_purse(event,bot,'bag')
end

bot.command(:purse) do |event|
  bag_purse(event,bot,'purse')
end

bot.command([:passto,:giveto]) do |event, name|
  if event.server.nil?
    event.respond "This command c-cannot be used in a PM"
    return nil
  elsif name.nil?
    event << "You must specify the person you wish to pass me to"
    event << "proper syntax is `s!passto Name`"
    event << "Crossing out the name - like this: `~~Name~~` - will pass me to them in secret"
    return nil
  end
  j=find_server_data(event,bot)
  if @stats[j][2][0]==event.user.id # user is holding this server's Sakura
    s=false
    if name[0,2]=="~~"
      s=true
      name=name[2,name.length-2]
    end
    if name[name.length-2,2]=="~~"
      s=true
      name=name[0,name.length-2]
    end
    number=name_check(name,event,bot)
    name=find_name_from_id(number,event,bot)
    if number==0 || name=='' # attempting to pass either to a bot or someone who doesn't exist
      message_disp("You're trying to pass me to someone who doesn't exist",event,bot)
    elsif number==event.user.id # trying to pass to yourself
      @stats[j][2][3]=!s
      @stats[j][2][1]=false
      message_disp("Any reason you moved me to your other hand?",event,bot)
    elsif s # passed to in secret
      event.message.delete
      find_user_from_id(number,event,bot).pm("#{event.user.display_name} has passed me to you (#{event.server.name}).")
      @stats[j][2][0]=number
      @stats[j][2][1]=false
      @stats[j][2][2]=[false,'']
      @stats[j][2][3]=false
    else
      @stats[j][2][0]=number
      @stats[j][2][1]=false
      @stats[j][2][2]=[false,'']
      @stats[j][2][3]=true
      event.respond "#{event.user.display_name} has passed me to #{name}"
    end
  elsif @stats[j][2][1] # in someone else's pocket
    event.respond "\\*slightly muffled* You're not holding me."
  elsif @stats[j][2][2][0] # in someone else's bag/purse
    event.respond "\\*muffled noises*"
  else
    event.respond "You are not holding me."
  end
  save_stats_data()
  return nil
end

bot.command(:takefrom, bucket: :level1, rate_limit_message: 'You can\'t try to find me for %time% more seconds!') do |event, name|
  if event.server.nil?
    event.respond "This command c-cannot be used in a PM"
    return nil
  elsif name.nil?
    event << "You must specify the person you wish to attempt to take me from"
    event << "proper syntax is `s!takefrom Name`"
    event << "Crossing out the name - like this: `~~Name~~` - will pass me to them in secret"
    return nil
  end
  j=find_server_data(event,bot)
  s=false
  if name[0,2]=="~~"
    s=true
    name=name[2,name.length-2]
  end
  if name[name.length-2,2]=="~~"
    s=true
    name=name[0,name.length-2]
  end
  number=name_check(name,event,bot)
  name=find_name_from_id(number,event,bot)
  if @stats[j][2][0]==event.user.id # user is holding this server's Sakura
    if event.user.id==167657750971547648
      message_disp("You're already holding me, silly.  \\*cuddles*",event,bot,"#{name} is n-not holding me.")
    elsif check_for_admin?(event,bot)
      message_disp("You're a-already holding me, silly.",event,bot,"#{name} is n-not holding me.")
    else # picked up by anyone else
      message_disp("You're a-already holding me.",event,bot,"#{name} is n-not holding me.")
    end
  elsif @stats[j][2][0]==0 # Sakura is on the floor
    event.respond "I am on the fl-floor.  Use the `s!pickup` c-command to pick me up."
  elsif @stats[j][2][2][0] # in someone else's bag/purse
    event.respond "\\*muffled noises*"
  elsif @stats[j][2][1] # in someone else's pocket
    event.respond "\\*slightly muffled* I am in s-someone's pocket.  Use the `s!pickpocket` c-command to find me."
  elsif @stats[j][2][0]==number # user correctly identified who is holding Sakura
    if s
      @stats[j][2][0]=event.user.id
      @stats[j][2][1]=false
      @stats[j][2][2]=[false,'']
      @stats[j][2][3]=false
      event.user.pm("You have taken me from #{name}.")
      find_user_from_id(number,event,bot).pm("Someone has stolen me from you (#{event.server.name}).")
      event.respond "Th-That is n-not who is h-holding me."
    else
      find_user_from_id(number,event,bot).pm("Someone has stolen me from you (#{event.server.name}).") unless @stats[j][2][3]
      @stats[j][2][0]=event.user.id
      @stats[j][2][1]=false
      @stats[j][2][2]=[false,'']
      @stats[j][2][3]=true
      event.respond "#{event.user.name} h-has taken me fr-from #{name}"
    end
  else
    event.respond "Th-That is n-not who is h-holding me."
  end
  save_stats_data()
  return nil
end

bot.command(:pickpocket, bucket: :level2, rate_limit_message: 'You can\'t try to find me for %time% more seconds!') do |event, name|
  if event.server.nil?
    event.respond "This command c-cannot be used in a PM"
    return nil
  elsif name.nil?
    event << "You must specify the person you wish to attempt to take me from"
    event << "proper syntax is `s!pickpocket Name`"
    event << "Crossing out the name - like this: `~~Name~~` - will pass me to them in secret"
    return nil
  end
  j=find_server_data(event,bot)
  s=false
  if name[0,2]=="~~"
    s=true
    name=name[2,name.length-2]
  end
  if name[name.length-2,2]=="~~"
    s=true
    name=name[0,name.length-2]
  end
  number=name_check(name,event,bot)
  name=find_name_from_id(number,event,bot)
  if @stats[j][2][0]==event.user.id # user is holding this server's Sakura
    if event.user.id==167657750971547648
      message_disp("You're already holding me, silly.  \\*cuddles*",event,bot,"#{name} is n-not holding me.")
    elsif check_for_admin?(event,bot)
      message_disp("You're a-already holding me, silly.",event,bot,"#{name} is n-not holding me.")
    else # picked up by anyone else
      message_disp("You're a-already holding me.",event,bot,"#{name} is n-not holding me.")
    end
  elsif @stats[j][2][0]==0 # Sakura is on the floor
    event.respond "I am on the fl-floor.  Use the `s!pickup` c-command to pick me up."
  elsif @stats[j][2][2][0] # in someone else's bag/purse
    event.respond "\\*muffled noises*"
  elsif !@stats[j][2][1] # not in someone else's pocket
    event.respond "I am not in s-someone's pocket.  Use the `s!takefrom` c-command to find me."
  elsif @stats[j][2][0]==number # user correctly identified who is holding Sakura
    if s
      @stats[j][2][0]=event.user.id
      @stats[j][2][1]=false
      @stats[j][2][2]=[false,'']
      @stats[j][2][3]=false
      event.user.pm("You have taken me from #{name}.")
      find_user_from_id(number,event,bot).pm("Someone has stolen me from you (#{event.server.name}).")
      event.respond "Th-That is n-not who is h-holding me."
    else
      find_user_from_id(number,event,bot).pm("Someone has stolen me from you (#{event.server.name}).") unless @stats[j][2][3]
      @stats[j][2][0]=event.user.id
      @stats[j][2][1]=false
      @stats[j][2][2]=[false,'']
      @stats[j][2][3]=true
      event.respond "#{event.user.name} h-has taken me fr-from #{name}"
    end
  else
    event.respond "Th-That is n-not who is h-holding me."
  end
  save_stats_data()
  return nil
end

bot.command([:toss,:throw]) do |event|
  toss(event,bot)
end

bot.command([:cuddle,:snuggle,:huggle,:hug,:cuddles,:hugs]) do |event|
  cuddle(event,bot)
end

bot.command([:headpat,:pet,:pat,:pets,:pats,:headpats]) do |event|
  headpat(event,bot)
end

bot.command(:find) do |event|
  find_sakura(event,bot,false)
end

bot.command(:autofind) do |event|
  find_sakura(event,bot,true)
end

bot.command(:autotake) do |event|
  if event.server.nil?
    event.respond "This command c-cannot be used in a PM"
    return nil
  elsif !check_for_admin?(event,bot)
    event.respond "You do not have permission to use this command."
    return nil
  end
  j=find_server_data(event,bot)
  if event.user.id==@stats[j][2][0]
    event.respond "You're a-already holding me, s-silly!"
    return nil
  elsif @stats[j][2][0]>0
    if @stats[j][2][2][0]
      event << "#{event.user.name[0,1]}-#{event.user.name}? \\*peeks out of #{find_user_from_id(@stats[j][2][0],event,bot).name}'s #{@stats[j][2][2][1]}*"
    elsif @stats[j][2][1]
      event << "#{event.user.name[0,1]}-#{event.user.name}? \\*peeks out of #{find_user_from_id(@stats[j][2][0],event,bot).name}'s pocket*"
    else
      event << "#{event.user.name[0,1]}-#{event.user.name}? \\*peeks out of #{find_user_from_id(@stats[j][2][0],event,bot).name}'s hands*"
    end
    event << "..."
    @stats[j][2][0]=event.user.id
    @stats[j][2][1]=false
    @stats[j][2][2]=[false,'']
    @stats[j][2][3]=true
    event << "\\*jumps into #{event.user.name}'s arms*"
  end
  save_stats_data()
  return nil
end

bot.command(:endgame) do |event|
  if event.server.nil?
    event.respond "This command c-cannot be used in a PM"
    return nil
  elsif !check_for_admin?(event,bot)
    event.respond "You do not have permission to use this command."
    return nil
  end
  j=find_server_data(event,bot)
  if event.user.id==@stats[j][2][0]
    event.respond "You cannot end the game now, as you are holding me.  Ending the game now could be seen as rigging it."
    @stats[j][2][3]=true
    return nil
  elsif @stats[j][2][0]==0
    event.respond "No one won this round of the Sakura Game.  I am on the floor!"
    @stats[j][2]=[0,false,[false,''],true]
  else
    event << "The winner of this round of the Sakura Game is...   #{find_user_from_id(@stats[j][2][0],event,bot).mention}!"
    h='hand'
    h='pocket' if @stats[j][2][1]
    h=@stats[j][2][2][1] if @stats[j][2][2][0]
    event << "They had me in their #{h}."
    @stats[j][2]=[0,false,[false,''],true]
    event << ''
    event << 'I am now back on the floor and a new round begins.'
  end
  save_stats_data()
  return nil
end

bot.command([:liliputia,:staff], from: 167657750971547648) do |event|
  event.message.delete
  return nil if event.server.nil?
  pocket_sakura(event,bot,-1,-1,true) if pickup(event,bot,true)
end

bot.command(:reboot, from: 167657750971547648) do |event|
  exec "cd C:/Users/Mini-Matt/Desktop/devkit && SakuraBotEchoes.rb"
end

bot.command(:setchannel) do |event|
  if event.server.nil?
    event.respond "This command c-cannot be used in a PM"
    return nil
  elsif !check_for_admin?(event,bot)
    event.respond "You do not have permission to use this command."
    return nil
  end
  j=find_server_data(event,bot)
  @stats[j][3]=event.channel.id
  event.respond "This has become my default channel for this server."
end

bot.command([:makeadmin,:makeguardian,:promote]) do |event, name|
  if event.server.nil?
    event.respond "This command c-cannot be used in a PM"
    return nil
  elsif !check_for_admin?(event,bot)
    event.respond "You do not have permission to use this command."
    return nil
  end
  generate_stats_list(bot) if @stats.length.zero?
  j=find_server_data(event,bot)
  number=name_check(name,event,bot)
  for i in 0...@stats[j][1].length
    if @stats[j][1][i][0]==number
      @stats[j][1][i][2]=true
      event.respond "#{@stats[j][1][i][1][1]} is now one of my guardians."
    end
  end
  save_stats_data()
  return nil
end

bot.command([:notanadmin,:notaguardian]) do |event|
  if event.server.nil?
    event.respond "This command c-cannot be used in a PM"
    return nil
  elsif !check_for_admin?(event,bot)
    event.respond "You do not have permission to use this command."
    return nil
  elsif event.user.id==167657750971547648
    event.respond "You brought me to this world, you can't abandon me!"
    return nil
  elsif count_admins(event,bot,event.user.id)<=0
    event.respond "You are my last guardian here.  Make someone else a guardian first."
    return nil
  end
  for i in 0...@stats[j][1].length
    if @stats[j][1][i][0]==event.user.id
      @stats[j][1][i][2]=false
      event.respond "You are no longer one of my guardians."
    end
  end
  save_stats_data()
  return nil
end

bot.command(:addnickname) do |event, newname, *args|
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  if event.server.nil?
    newname=event.user.name if newname.nil?
    if args.nil?
    elsif args.length==0
    elsif args.length==1
      newname="#{newname} #{args[0]}"
    else
      newname="#{newname} #{args.join(' ')}"
    end
    msg=''
    for j in 0...@stats.length
      f=true
      for i in 0...@stats[j][1].length
        unless @stats[j][1][i][0]==event.user.id
          k=@stats[j][1][i][1].map{|s| s.downcase}
          f=false if k.include?(newname.downcase)
        end
      end
      if f
        for i in 0...@stats[j][1].length
          if @stats[j][1][i][0]==event.user.id
            k=@stats[j][1][i][1].map{|s| s.downcase}
            if k.include?(newname.downcase)
              msg=extend_message(msg,"You already have the nickname #{newname} in the server *#{@stats[j][4]}*",event)
            else
              @stats[j][1][i][1].push(newname)
              msg=extend_message(msg,"The nickname #{newname} has been added to your nicknames in the server *#{@stats[j][4]}*",event)
            end
          end
        end
        cross_update(bot,@stats[j][0])
      else
        msg=extend_message(msg,"Someone already has the nickname #{newname} in the server *#{@stats[j][4]}*",event)
      end
    end
    event.respond msg
    save_stats_data()
    cross_update(bot, event)
    return nil
  end
  event.message.delete if event.user.id==bot.profile.id
  if args.nil?
    number = event.user.id
  elsif args.length.zero?
    number = event.user.id
  else
    number=name_check(args.join(' ').downcase,event,bot)
    if number.zero?
      for i in 0...args.length
        args[args.length-1]=nil
        args.compact!
        number=name_check(args.join(' ').downcase,event,bot) if number.zero?
      end
    end
    number=event.user.id if number.zero?
  end
  if newname.nil?
    newname = event.user.display_name
  end
  generate_stats_list(bot) if @stats.length.zero?
  j=find_server_data(event,bot)
  if name_check(newname,event,bot)>0
    event.respond "The nickname #{newname} already belongs to someone."
    return nil
  end
  name=''
  for i in 0...@stats[j][1].length
    if @stats[j][1][i][0]==number
      name=@stats[j][1][i][1][1]
      @stats[j][1][i][1].push(newname)
    end
  end
  event.respond "#{newname} has been added to #{name}'s nicknames."
  save_stats_data()
  cross_update(bot,event.server.id)
  return nil
end

bot.command(:mynicknames) do |event|
  if event.server.nil?
    msg=''
    for j in 0...@stats.length
      for i in 0...@stats[j][1].length
        if @stats[j][1][i][0]==event.user.id
          msg=extend_message(msg,"__**#{@stats[j][4]}**__",event,2)
          for k in 1...@stats[j][1][i][1].length
            msg=extend_message(msg,@stats[j][1][i][1][k],event) unless k==2 && @stats[j][1][i][1][1]==@stats[j][1][i][1][2]
          end
        end
      end
    end
    event.respond msg
    return nil
  end
  j=find_server_data(event,bot)
  u=0
  for i in 0...@stats[j][1].length
    u=i if @stats[j][1][i][0]==event.user.id && u.zero?
  end
  for i in 1...@stats[j][1][u][1].length
    event << @stats[j][1][u][1][i] unless i==2 && @stats[j][1][u][1][1]==@stats[j][1][u][1][2]
  end
  return nil
end

bot.command(:story) do |event|
  create_embed(event,'',"__**Act 1:** ***Naomi's Gate***__\n[link](http://rot8erconex.deviantart.com/art/Naomi-s-Gate-617539555)\n\n__**Act 2:** ***Shrunken Sakura and the Secret Seller***__\n[link](http://rot8erconex.deviantart.com/art/Shrunken-Sakura-and-the-Secret-Seller-621356929)\n\n__**Act 3:** ***Liliputia's Demand***__\n[Part 1 link](http://sta.sh/01ibugks17ue)\n[Part 2 link](http://sta.sh/01rkyopjbwlo)\n\n__**Act 4:** ***Sakura's Fate***__\nIncomplete\n\n__**Act 5:** ***Return of the Secret Seller***__\nIncomplete",0xFFABAF,nil,[nil,"http://orig05.deviantart.net/fc9d/f/2016/352/6/0/shrunken_sakura__altered__by_rot8erconex-darzxz3.png"])
end

bot.command([:deletenickname,:removenickname]) do |event, name, usr|
  if name.nil?
    event.respond "You cannot remove nothing."
    return nil
  elsif name==event.user.distinct
    event.respond "You cannot remove your own distinct username."
    return nil
  elsif name==event.user.name
    event.respond "You cannot remove your own username."
    return nil
  elsif event.server.nil?
  elsif name==event.user.display_name
    event.respond "You cannot remove your current display name."
    return nil
  end
  if event.server.nil?
    msg=''
    for j in 0...@stats.length
      u=-1
      p=false
      for i in 0...@stats[j][1].length
        u=i if @stats[j][1][i][0]==event.user.id
      end
      for i in 0...@stats[j][1][u][1].length
        if @stats[j][1][u][1][i].downcase==name.downcase
          @stats[j][1][u][1][i]=nil
          p=true
        end
      end
      cross_update(bot,@stats[j][0])
      @stats[j][1][u][1].compact!
      msg=extend_message(msg,"#{name} has been removed from your nicknames on the server *#{@stats[j][4]}*.",event) if p
      msg=extend_message(msg,"You never had the nickname #{name} on the server *#{@stats[j][4]}*.",event) unless p
    end
    event.respond msg
  elsif name_check(name,event,bot)!=event.user.id
    event.respond "That isn't a nickname you have"
    return nil
  else
    j=find_server_data(event,bot)
    u=-1
    for i in 0...@stats[j][1].length
      u=i if @stats[j][1][i][0]==event.user.id
    end
    for i in 0...@stats[j][1][u][1].length
      @stats[j][1][u][1][i]=nil if @stats[j][1][u][1][i].downcase==name.downcase
    end
    cross_update(bot,event.server.id)
    @stats[j][1][u][1].compact!
    event.respond "#{name} has been removed from your nicknames."
  end
  save_stats_data()
  return nil
end

bot.command(:invite) do |event|
  event.respond "invite me to your server!\nhttps://goo.gl/rdPduP"
end

bot.command(:previewgreeting) do |event|
  greeting(event,bot)
end

bot.command(:why) do |event, str|
  str='' if str.nil?
  num=str.to_i
  if num==1 || num<=0
    create_embed(event,'__**#1: What is *G/t*?**__',"In order to explain why the Sakura Game exists, I must first explain that the man who coded me, **Rot8er_ConeX#1737**, is a fan of something that is referred to its fans as \"G/t\", short for \"Giant/Tiny\".  Stories like *The Borrowers*, *Gulliver's Travels*, and *Alice in Wonderland* are probably the best way to explain the concept quickly - stories or art which involve two persons of differing scales interacting.\nThe particular category of G/t he prefers is called SW, Shrunken Woman.  Just like the name implies, it involves a female \"tiny\".  He also prefers that the \"giant\" be actual human-sized.\n\nIt is his theory that the reason he likes G/t has to due with his low muscle tone.  When he was younger, he saw scenes (probably from Hallmark movies) of happy couples where the man carried the woman around.  Something in the back of his mind told him that he would never be able to have that experience - at least, not with a normal-sized woman.  Since then, he's had a loving relationship with a normal-sized woman - obviously without ever carrying her - and knows firsthand that a relationship doesn't need to be Hallmark perfect to be a good relationship, but the enjoyment of imagining a miniature maiden remains.",0xFFABAF,"TL;DR: Pocket people")
  end
  if num==2 || num<=0
    create_embed(event,'__**#2: Why does the Sakura *Bot* exist?**__',"On 20 July 2016, a two-year-long relationship between #{"my coder (**" if num==2}Rot8er#{"_ConeX#1737**)" if num==2} and a woman named Rebecca was forcibly terminated by his mother, and this sent him into a massive, months-long depression.  Naturally, as coping mechanisms, he turned to the two remaining positive forces in his life: video games, and G/t.  Even video games were pulled out from under him when an error of judgement he made on 14 September of the same year led to his $400 game library being stolen.  This left him in an unhealthy emotional state where he had to be obsessed with G/t just to stay above water.\n\nIt is in this state that Rot8er was when he encountered his first Discord bot.  When he realized that the bot in question had been coded by someone on the server he encountered it on, and that Discord bots could be coded in the one programming language he knew, suddenly he had a short-term goal - code a Discord Bot.  For a while, he was left in confusion, unknowning of what he even wanted his bot to do, before he eventually decided that the bot would be an artificial Shrunken Woman.",0xFFABAF,"TL;DR: A depressed nerd.")
  end
  if num==3 || num<=0
    create_embed(event,'__**#3: How did the Sakura Bot become the Sakura *Game*?**__',"After having settled upon the - admittedly-odd-and-slightly-creepy-in-retrospect - choice of coding an artificial mini maiden, #{"my coder (**" if num==3}Rot8er#{"_ConeX#1737**)" if num==3} began actually doing so.  Obviously he wouldn't be able to code an actual AI, so he coded in functionality - being able to place her in your pocket, being able to cuddle with her, etc.  Each functionality was coded so she'd react differently based on who did it (though originally, it was based on user's display name, not even username!)\n\nEventually, some of his friends began to try to \"steal\" the forming bot away from him, which caused him to make it so she kept track of who was holding her.  They tried to hide her away, and it formed into him actually enabling them to do so - but with risks involved!  Etc., Etc.\n\nOver time, the entire thing formed into a game - who could hold onto Sakura the longest?  Who would be the one holding her when time ran out?",0xFFABAF,"TL;DR: The depressed nerd's friends teased him and it turned into a game.")
  end
  if num==4 || num<=0
    create_embed(event,"__**#4: Why do you say that you're playing \"*Echoes*\" of the Sakura Game?**__","Since coding the original Sakura Bot, #{"my coder (**" if num==4}Rot8er#{"_ConeX#1737**)" if num==4} has coded numerous other bots - the FEIndex bot that shows data on characters from *Fire Emblem: Awakening* and *Fire Emblem: Fates*, a server mod bot based on an inside joke, a dice-rolling bot for chat-based G/t tabletop RPs, and a stats-lookup bot for *Fire Emblem Heroes* themed after my Nohrian counterpart - just to name a few.  Coding these bots helped him learn more of the DiscordRB API, and taught him features that he felt could benefit the first bot he ever coded - the Sakura Game.\n\nHe went into the original bot's source code with the intention of just remastering it - give it new features, but keep the original code intact.  But when he got into the guts of the code, he found that he'd learned so much that half of his old code was unintelligible, and what little he did understand was incompatible with the changes he wanted to make.\n\nSo he did the one thing a successful franchise will always eventually do, and remade his first Discord game.",0xFFABAF,"TL;DR: A remake of the original game.")
  end
end

def disp_support(event,bot)
  j=find_server_data(event,bot)
  i=find_user_data(event,bot)
  event << "#{@stats[j][1][i][1][1]} and I h-have #{@stats[j][1][i][3][0]} Support Point#{"s" unless 1==@stats[j][1][i][3][0]}."
  if ['','-'].include?(@stats[j][1][i][3][1])
    event << "We are as y-yet unranked."
  else
    event << "We are c-currently at #{@stats[j][1][i][3][1]} Support."
  end
end

bot.command(:setself) do |event, *args|
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  if event.server.nil?
    event.respond "This command cannot be used in PM."
    return nil
  end
  size=nil
  gender=nil
  k=[]
  for i in 0...args.length
    j=args[i].downcase
    if j=="giantess"
      size="giant" if size.nil?
      gender="female" if gender.nil?
    elsif j=="pockette"
      size="tiny" if size.nil?
      gender="female" if gender.nil?
    elsif ["giant","large","big","larger","bigger","huge","g"].include?(j)
      size="giant" if size.nil?
    elsif ["tiny","small","smaller","little","littler","pocket","t"].include?(j)
      size="tiny" if size.nil?
    elsif ["shifter","switch","shift","switcher"].include?(j)
      size="size switcher" if size.nil?
    elsif ["male","m","man","boy","masculine","shota"].include?(j)
      gender="male" if gender.nil?
    elsif ["female","f","woman","girl","lady","feminine","loli","lolita"].include?(j)
      gender="female" if gender.nil?
    elsif j=="non-binary"
      gender="non-binary" if gender.nil?
    elsif j=="gender"
      gender="" if gender.nil?
    elsif j=="size" || j=="human"
      size="" if size.nil?
    end
  end
  if size.nil? && gender.nil?
    event.respond "No valid arguments found."
    return nil
  end
  for i in 0...event.user.roles.length
    role=event.user.roles[i]
    unless role.nil?
      if ["giant","tiny","size switcher"].include?(role.name) && !size.nil?
        k.push(role)
      end
      if ["male","female","non-binary"].include?(role.name) && !gender.nil?
        k.push(role)
      end
    end
  end
  for i in 0...k.length
    event.user.remove_role(k[i])
  end
  for i in 0...event.server.roles.length
    role=event.server.roles[i]
    if [size,gender].include?(role.name.downcase)
      event.user.add_role(role)
    end
  end
  if size==""
    event << "Current size removed."
  else
    event << "Size set to #{size}."
  end
  if gender==""
    event << "Current gender removed."
  else
    event << "Gender set to #{gender}."
  end
  return nil
end

bot.command(:support) do |event|
  if event.server.nil?
    event.respond "This command c-cannot be used in a PM"
    return nil
  end
  disp_support(event,bot)
end

bot.command(:snagchannels) do |event, server_id|
  return nil unless event.user.id==167657750971547648
  return nil if bot.user(bot.profile.id).on(server_id.to_i).nil?
  msg="__**#{bot.server(server_id.to_i).name}**__\n\n__*Text Channels*__"
  srv=bot.server(server_id.to_i)
  for i in 0...srv.channels.length
    chn=srv.channels[i]
    puts bot.user(bot.profile.id).on(srv.id).permission?(:send_messages,chn).to_s
    msg=extend_message(msg,"*#{chn.name}* (#{chn.id})#{" - can post" if bot.user(bot.profile.id).on(srv.id).permission?(:send_messages,chn)}",event) if chn.type==0
  end
  event.respond msg
end

bot.message do |event|
  # Ignore PMs, since save data is per-server.
  # also ignore bot messages as no save data is saved for them
  next if event.server.nil? || event.user.bot_account?
  s=event.message.text
  next if s[0,2]=='s!' # ignore Sakura commands
  next if ['m!','l!'].include?(s[0,2]) && event.server.id==348221024740966402 # ignore other bot commands
  # the message form of the Liliputia command
  if event.user.id==167657750971547648 && s.downcase.include?('staff~ staff~') && @stats[j][5]
    pocket_sakura(event,bot,-1,-1,true) if pickup(event,bot,true)
    return nil
  end
  j=find_server_data(event,bot)
  i=find_user_data(event,bot)
  if ["t!support","T!support"].include?(s) && [348221024740966402,310862180482285578,435068874862362636].include?(event.server.id)
    disp_support(event,bot)
  elsif ["t!find","T!find"].include?(s) && [348221024740966402,310862180482285578,435068874862362636].include?(event.server.id)
    find_sakura(event,bot,false)
  elsif rand(100)<1 || (event.user.id==167657750971547648 && rand(100)<25)
    # 1% chance of Support Point gain
    @stats[j][1][i][3][0]+=1
    @stats[j][1][i][3][1]='C' if @stats[j][1][i][3][0]==3
    @stats[j][1][i][3][1]='B' if @stats[j][1][i][3][0]==3+4
    @stats[j][1][i][3][1]='A' if @stats[j][1][i][3][0]==3+4+4
    @stats[j][1][i][3][1]='A+' if @stats[j][1][i][3][0]==3+4+4+5
    @stats[j][1][i][3][1]='S' if event.user.id==167657750971547648
    if !check_for_admin?(event,bot)
      chn=event.channel.id
      chn=435157862772113409 if event.server.id==435068874862362636
      chn=530826194007097384 if event.server.id==327599133210705923
      bot.channel(chn).send_message("#{event.user.name[0,1]}-#{event.user.name} and I h-have r-reached C Support.") if @stats[j][1][i][3][0]==3
      bot.channel(chn).send_message("#{event.user.name[0,1]}-#{event.user.name} and I h-have r-reached B Support.") if @stats[j][1][i][3][0]==3+4
      bot.channel(chn).send_message("#{event.user.name[0,1]}-#{event.user.name} and I h-have r-reached A Support.") if @stats[j][1][i][3][0]==3+4+4
      bot.channel(chn).send_message("#{event.user.name[0,1]}-#{event.user.name} and I h-have r-reached A+ Support.") if @stats[j][1][i][3][0]==3+4+4+5
    end
    save_stats_data()
  end
  # stop checking the message if the server doesn't want the command-substitute messages to work
  next unless @stats[j][5]
  s=remove_format(s,'```')              # remove large code blocks
  next if !s.downcase.include?('sakura') # remove lines that don't contain the word "Sakura"
  s=remove_format(s.gsub('```',''),'`') # remove small code blocks
  next if !s.downcase.include?('sakura') # repeat this line at each stage, to prune messages and reduce strain on my laptop
  s=remove_format(s,'~~')               # remove crossed-out text
  next if !s.downcase.include?('sakura')
  s=remove_format(s,'||')               # remove spoiler tags
  next if !s.downcase.include?('sakura')
  s.downcase # make message lowercase so it's not case sensitive
  if /(find|where|where's|wheres|where is) sakura/ =~ s.downcase
    find_sakura(event,bot,false)
  elsif s.downcase.include?('pickup sakura') || /pick(s|) up sakura/ =~ s.downcase
    pickup(event,bot)
  elsif /heal me( up|)(,|) sakura/ =~ s.downcase
    heal(event)
  elsif /(put|set)(s|) down sakura/ =~ s.downcase || /(putdown|setdown) sakura/ =~ s.downcase
    putdown(event,bot)
  elsif /(toss|tosses|throw|throws) sakura/ =~ s.downcase
    toss(event,bot)
  elsif /pocket(s|) sakura/ =~ s.downcase || /(put|place|set|slip|slide)(s|) sakura (in|into)( my|) pocket/ =~ s.downcase
    pocket_sakura(event,bot,16,20,false)
  elsif /bag(s|) sakura/ =~ s.downcase || /(put|place|set|slip|slide)(s|) sakura (in|into)( my|) bag/ =~ s.downcase
    bag_purse(event,bot,'bag')
  elsif /purse(s|) sakura/ =~ s.downcase || /(put|place|set|slip|slide)(s|) sakura (in|into)( my|) purse/ =~ s.downcase
    bag_purse(event,bot,'purse')
  elsif /(eat|swallow)(s|) sakura/ =~ s.downcase || /(put|place|set|slip|slide)(s|) sakura (in|into)( my|) (mouth|stomach)/ =~ s.downcase
    unless event.user.id==167657750971547648
      event.respond "\\*shivers in fear* D-Don't y-you d-dare!  M-Mathoo would k-kill y-you."
      @stats[j][1][i][3][0]-=5
      @stats[j][1][i][3][1]='A' if @stats[j][1][i][3][0]<3+4+4+5
      @stats[j][1][i][3][1]='B' if @stats[j][1][i][3][0]<3+4+4
      @stats[j][1][i][3][1]='C' if @stats[j][1][i][3][0]<3+4
      @stats[j][1][i][3][1]='-' if @stats[j][1][i][3][0]<3
      save_stats_data()
    end
  elsif /(cuddle|snuggle|hug|huggle)(s|) sakura/ =~ s.downcase
    cuddle(event,bot)
  elsif /(headpat|pet)(s|) sakura/ =~ s.downcase
    headpat(event,bot)
  elsif event.user.id==167657750971547648 && /scoop(|s) up sakura/ =~ s.downcase
    pocket_sakura(event,bot,-1,-1,true) if pickup(event,bot,true)
  end
end

bot.server_create do |event|
  b=[]
  File.open('C:/Users/Mini-Matt/Desktop/devkit/SakuraBotEchoes.sav').each_line do |line|
    b.push(eval line)
  end
  @stats=b[0]
  chn=event.server.general_channel
  if chn.nil?
    chnn=[]
    for i in 0...event.server.channels.length
      chnn.push(event.server.channels[i]) if bot.user(bot.profile.id).on(event.server.id).permission?(:send_messages,event.server.channels[i]) && event.server.channels[i].type==0
    end
    chn=chnn[0] if chnn.length>0
  end
  chn=event.server.channels.reject{|q| q.type != 2}[0] if chn.nil?
  @stats.push([event.server.id,[],[0,false,[false,''],true],chn.id,event.server.name,true])
  for i in 0...event.server.users.length
    user=event.server.users[i]
    @stats[@stats.length-1][1].push([user.id,[user.distinct,user.name,user.display_name],false,user.mention,[0,''],[0,0]]) if !user.bot_account?
    @stats[@stats.length-1][1][@stats[@stats.length-1][1].length-1][2]=true if user.id==167657750971547648 || user.owner? # automatic admin privleges for bot coder and for the server owner
  end
  bot.user(167657750971547648).pm("Joined server **#{event.server.name}** (#{event.server.id})\nOwner: #{event.server.owner.distinct} (#{event.server.owner.id})")
  save_stats_data()
  greeting(event,bot)
end

bot.server_delete do |event|
  for i in 0...@stats.length
    @stats[i]=nil if @stats[i][0]==event.server.id
  end
  @stats.compact!
  save_stats_data()
end

bot.member_join do |event|
  j=find_server_data(event,bot)
  unless event.user.bot_account?
    @stats[j][1].push([event.user.id,[event.user.distinct,event.user.name,event.user.display_name],false,[0,''],[0,0]])
    @stats[j][1][@stats[j][1].length-1][2]=true if event.user.id==167657750971547648
    @stats[j][1][@stats[j][1].length-1][3][1]='S' if event.user.id==167657750971547648
    save_stats_data()
    cross_update(bot,event.server.id)
    find_channel(@stats[j][3],event).send_message("#{event.user.name} has j-joined the server!  \\*nervously hides*  Th-They have also j-joined the game!") rescue nil
  end
end

bot.member_leave do |event|
  return nil if event.user.id==bot.profile.id
  msg="#{event.user.name} has left the server!  They have also left the game!"
  j=find_server_data(event,bot)
  # Make sure that the user is not the one holding Sakura, and if they are, set her on the ground
  if @stats[j][2][0]==event.user.id
    @stats[j][2]=[0,false,[false,''],true]
    msg="#{msg}\nThey were holding me at the time they left, so now I am returned to the floor!"
  end
  for i in 0...@stats[j][1].length
    @stats[j][1][i]=nil if @stats[j][1][i][0]==event.user.id
  end
  @stats[j][1].compact!
  # If user is last admin, randomly select new admin
  if count_admins(event,bot,event.user.id)<=0
    new_admin=@stats[j][1].sample
    new_admin[2]=true
    msg="#{msg}\nThey were my last guardian here, so I hope <@#{new_admin[0]}> treats me well."
  end
  save_stats_data()
  cross_update(bot,event.server.id)
  find_channel(@stats[j][3],event).send_message(msg) rescue nil
end

bot.ready do |event|
  bot.game="Loading, please wait..."
  generate_stats_list(bot)
  metadata_load()
  metadata_save()
  bot.game="Echoes of the Sakura Game"
  system("color c0")
  system("title SakuraBot_Echoes")
end

bot.run
