# oper.tcl by ev0x

# Author: ev0x ev0x@phrack.co.nz

# Script: oper.tcl

# Version: v0.5

# Date: 12/01/11

##

# Some useful oper commands for your eggdrop bot

# still in dev so somethings seem to be a bit strange

# Please do no re-distribute a modified version of this script. If you do re-distribute

# in it's original form, please give credit to me, and do not claim as your own



# set owner here

set ownerOper "ev0x"



	# all binds go here

	# +n/bot owner commands

	bind pub n !jump oper:jump

	bind pub n !die oper:die

	bind pub n !rh oper:rehash

	bind pub n !chattr oper:chattruser

	bind pub n !save oper:save

	bind pub n !rl oper:reload

	bind pub n !bu oper:backup

	bind pub n !bc oper:broadcast

	

	# +m/+n commands

	bind pub m|n !globalaop oper:addglobalop

	bind pub m|n !globalvop oper:addglobalvoice

	bind pub m|n !globalf oper:addglobalfriend

	bind pub m|n !globalrmaop oper:rmglobalop

	bind pub m|n !globalrmvop oper:rmglobalvoice

	bind pub m|n !globalrmf oper:rmglobalfriend

	bind pub m|n !globalban oper:globalban

	bind pub m|n !rmuser oper:removeuser

	bind pub m|n !lsuser oper:listusers

	bind pub m|n !+chan oper:addchan

	bind pub m|n !-chan oper:removechan

	bind pub m|n !savechan oper:savechan

	

	# +m/+m&+o commands

	bind pub m|m !auser oper:adduser

	bind pub m|m !aop oper:addop

	bind pub m|m !rmaop oper:removeop

	bind pub m|o !vop oper:addvoice

	bind pub m|o !rmvop oper:removevoice

	bind pub m|o !f oper:friend

	bind pub m|o !rmf oper:removefriend

	bind pub m|o !op oper:op

	bind pub m|o !vo oper:voice

	bind pub m|o !k oper:kick

	bind pub m|o !b oper:ban

	bind pub m|o !kb oper:kickban

	bind pub m|o !topic oper:topic

	bind pub o|o !opme oper:opme

	bind pub -|- !h oper:help

	



# +n/bot owner command proc's

proc oper:jump {nick host hand chan text} {

	global ownerOper

	putquick "PRIVMSG $ownerOper :$nick has triggered !jump"

	putlog "$nick has triggered !jump"

	jump $text

}



proc oper:die {nick host hand chan text} {

	global ownerOper

	putquick "PRIVMSG $ownerOper :$nick has triggered !die"

	putlog "$nick has triggered !die"

	die $text

}



proc oper:rehash {nick host hand chan text} {

	global ownerOper

	putquick "PRIVMSG $ownerOper :$nick has triggered !rehash"

	putlog "$nick has triggered !rehash"

	rehash

}



proc oper:chattruser {nick host hand chan text} {

  global ownerOper

  if {[string length $text] > 0} {

  	set tnick [lindex $text 0]

  	if {[string length [lindex $text 1]] != 0} { set changes [lindex $text 1] }

  	if {[string length [lindex $text 2]] != 0} { set tchan [lindex $text 2] }

  	chattr $tnick $changes $tchan

  	putquick "PRIVMSG $ownerOper :$nick has set $changes to $tnick on channel :$tchan"

  } else { puthelp "PRIVMSG $nick :usage !chattr <nick> <changes> <chan> - as per setting from partyline" }

}



proc oper:save {nick host hand chan text} {

	global ownerOper

	putquick "PRIVMSG $ownerOper :$nick has triggered !save"

	putlog "$nick has triggered !save"

	save

}



proc oper:reload {nick host hand chan text} {

	global ownerOper

	putquick "PRIVMSG $ownerOper :$nick has triggered !rl"

	putlog "$nick has triggered !rl"

	reload

}



proc oper:backup {nick host hand chan text} {

	global ownerOper

	putquick "PRIVMSG $ownerOper :$nick has triggered !bu"

	putlog "$nick has triggered backup"

	backup

}



proc oper:broadcast {nick host hand chan text} {

  global ownerOper

  if {[string length $text] > 0} {

    set text [string trim $text "{}"]

    foreach n [channels] { puthelp "PRIVMSG $n :$text" }

  } else { puthelp "PRIVMSG $nick :!bc <message> - sends message to all channels that the bot is" }

}



# +m/+n command proc's

proc oper:addglobalop { nick host hand chan text } {

global ownerOper

putquick "PRIVMSG $ownerOper :$nick is trying to add global +ao to $text"

  set addnick [nick2hand $text]

  if {[validuser $addnick]} {

    chattr $addnick +ao

    putquick "PRIVMSG $ownerOper :$nick has added global +ao to $text"

    putserv "PRIVMSG $nick :$text Has Been Given Global Auto-Op Access"

    putlog "$nick added $addnick to Global Auto-Op"

    if {[isop $text $chan] == 0} { pushmode $chan +o $text }

    putserv "PRIVMSG $text :You Have Been Granted Global Auto-Op Access On this bot"

  } else { putserv "PRIVMSG $nick :$text Not Found In User Database" }

  unset addnick

}



proc oper:addglobalvoice { nick host hand chan text } {

global ownerOper

putquick "PRIVMSG $ownerOper :$nick is trying to add global +gv to $text"

  set addnick [nick2hand $text]

  if {[validuser $addnick]} {

    chattr $addnick +gv

    putquick "PRIVMSG $ownerOper :$nick has added global +gv to $text"

    putserv "PRIVMSG $nick :$text Has Been Given Global Voice Access"

    putlog "$nick added $addnick to Global Voice"

    if {[isvoice $text $chan] == 0} { pushmode $chan +v $text }

    putserv "PRIVMSG $text :You Have Been Granted Global Voice Access On this bot"

  } else { putserv "PRIVMSG $nick :$text Not Found In User Database" }

  unset addnick

}



proc oper:addglobalfriend { nick host hand chan text } {

global ownerOper

putquick "PRIVMSG $ownerOper :$nick is trying to add global +f to $text"

  set addnick [nick2hand $text]

  if {[validuser $addnick]} {

    chattr $addnick +f

    putquick "PRIVMSG $ownerOper :$nick has added global +f to $text"

    putserv "PRIVMSG $nick :$text Has Been Giving Auto-Op Access"

    putlog "$nick added $addnick to Global +f"

    putserv "PRIVMSG $text :You Have Been Granted Global Friend On this bot"

  } else { putserv "PRIVMSG $nick :$text Not Found In User Database" }

  unset addnick

}



proc oper:rmglobalop { nick host hand chan text } {

global ownerOper

putquick "PRIVMSG $ownerOper :$nick is trying to add global -ao to $text"

  set addnick [nick2hand $text]

  if {[validuser $addnick]} {

    chattr $addnick -ao

    putquick "PRIVMSG $ownerOper :$nick has removed global -ao to $text"

    putserv "PRIVMSG $nick :$text Has Been Removed From Global Auto-Op Access"

    putlog "$nick rm $addnick from Global -ao"

    if {[isop $text $chan] == 1} { pushmode $chan -o $text }

    #putserv "PRIVMSG $text :You Have Been Purged Global Auto-Op Access On this bot"

  } else { putserv "PRIVMSG $nick :$text Not Found In User Database" }

  unset addnick

}



proc oper:rmglobalvoice { nick host hand chan text } {

global ownerOper

putquick "PRIVMSG $ownerOper :$nick is trying to add global -dv to $text"

  set addnick [nick2hand $text]

  if {[validuser $addnick]} {

    chattr $addnick -dv

    putquick "PRIVMSG $ownerOper :$nick has removed global -dv to $text"

    putserv "PRIVMSG $nick :$text Has Been Removed From Global Voice Access"

    putlog "$nick rm $addnick from Global -dv"

    if {[isvoice $text $chan] == 1} { pushmode $chan -v $text }

    #putserv "PRIVMSG $text :You Have Been Purged Global Voice Access On this bot"

  } else { putserv "PRIVMSG $nick :$text Not Found In User Database" }

  unset addnick

}



proc oper:rmglobalfriend { nick host hand chan text } {

global ownerOper

putquick "PRIVMSG $ownerOper :$nick is trying to add global -f to $text"

  set addnick [nick2hand $text]

  if {[validuser $addnick]} {

    chattr $addnick -f

    putquick "PRIVMSG $ownerOper :$nick has removed global -f to $text"

    putserv "PRIVMSG $nick :$text Has Been Removed From Global Friend Access"

    putlog "$nick rm $addnick from Global -f"

    #putserv "PRIVMSG $text :You Have Been Purged Global Friend On this bot"

  } else { putserv "PRIVMSG $nick :$text Not Found In User Database" }

  unset addnick

}



proc oper:globalban { nick host hand chan text } {

global ownerOper

putquick "PRIVMSG $ownerOper :$nick is trying to add global ban to $text"

# does not require ops in chan

  if {[string length $text] > 0} {

  	set tnick [lindex $text 0]

  	if {[onchan $tnick $chan]} {

  		if {[string length [lindex $text 1]] == 0} { set reason banned } else { set reason [lrange $text 1 end]

  		newban *![getchanhost $tnick $chan] $nick $reason 0

  	} else { puthelp "PRIVMSG $nick :no such nick on channel! This will only global ban a nick in channel otherwise see: $ownerOper" }

  } else { puthelp "PRIVMSG $nick :usage !globalban <nick> reason - globally ban a user from all channels" }

 }

unset tnick

}



proc oper:removeuser { nick host hand chan text } {

global ownerOper

putquick "PRIVMSG $ownerOper :$nick is trying to remove user $text"

	set tnick [lindex $text 0]

	deluser $tnick

	putlog "$text has been removed from bot"

	unset tchan

}



proc oper:listusers { nick host hand chan text } {

global ownerOper

global botname

 puthelp "PRIVMSG $nick :User List for $botname as at [time]@[date] showing [countusers]:: [userlist]"

}



proc oper:addchan { nick host hand chan text } {

global ownerOper

putquick "PRIVMSG $ownerOper :$nick is trying to add chan $text"

	set tchan [lindex $text 0]

	channel add $tchan

	putlog "$text channel has been added to bot"

	unset tchan

}



proc oper:removechan { nick host hand chan text } {

global ownerOper

putquick "PRIVMSG $ownerOper :$nick is trying to remove chan $text"

	set tchan [lindex $text 0]

	channel remove $tchan

	putlog "$text channel has been removed from bot"

	unset tchan

}



proc oper:savechan { nick host hand chan text } {

global ownerOper

putquick "PRIVMSG $ownerOper :$nick is trying to savechans"

	savechannels

	putlog "channels saved"

}



proc oper:channellist { nick host hand chan text } {

global ownerOper

putquick "PRIVMSG $ownerOper :$nick is viewing channels"

	puthelp "PRIVMSG $nick :Channels on bot :[channels]

	putlog "channels saved"

}



# +m/+m&+o command procs



	

proc oper:adduser { nick host hand chan text } {

global ownerOper

  set addusernick [nick2hand $text]

  if {[validuser $addusernick]} {

    putserv "PRIVMSG $nick :\002$text\002 Is Already In User Database As \002$addusernick\002"

  } else {

    unset addusernick

    adduser $text *![getchanhost $text $chan]

    set addusernick [nick2hand $text]

    putlog "\002$nick\002 Added \002$addusernick\($text\)\002 To User Database"

    putserv "PRIVMSG $nick :\002$text\002 Added To User Database As \002$addusernick\002"

    putserv "PRIVMSG $ownerOper :\002$text\002 Added To User Database As \002$addusernick\002"

    unset addusernick

    unset maskhosts

  }

}



proc oper:addop { nick host hand chan text } {

global ownerOper

  set addopnick [nick2hand $text]

  if {[validuser $addopnick]} {

    chattr $addopnick -|+ao $chan

    putserv "PRIVMSG $nick :$text Has Been Giving Auto-Op Access"

    putlog "$nick added $addopnick to Auto-Op"

    if {[isop $text $chan] == 0} { pushmode $chan +o $text }

    putserv "PRIVMSG $text :You Have Been Given Auto-Op Access For Channel: \002$chan\002"

    putserv "PRIVMSG $ownerOper :$text Given Auto-Op Access For Channel: \002$chan\002"

  } else { putserv "PRIVMSG $nick :$text Not Found In User Database" }

  unset addopnick

}



proc oper:removeop { nick host hand chan text } {

global ownerOper

  set addopnick [nick2hand $text]

  if {[validuser $addopnick]} {

    chattr $addopnick -|-ao $chan

    putserv "PRIVMSG $nick :$text Has Been removed from Auto-Op Access"

    putlog "$nick removed $addopnick from Auto-Op"

    if {[isop $text $chan] == 1} { pushmode $chan -o $text }

    putserv "PRIVMSG $text :You Have Been Removed From Auto-Op Access For Channel: \002$chan\002"

    putserv "PRIVMSG $ownerOper :$text Removed Auto-Op Access For Channel: \002$chan\002"

  } else { putserv "PRIVMSG $nick :$text Not Found In User Database" }

  unset addopnick

}



proc oper:addvoice { nick host hand chan text } {

global ownerOper

  set addopnick [nick2hand $text]

  if {[validuser $addopnick]} {

    chattr $addopnick -|+ao $chan

    putserv "PRIVMSG $nick :$text Has Been Giving Auto-Op Access"

    putlog "$nick added $addopnick to Auto-Op"

    if {[isvoice $text $chan] == 0} { pushmode $chan +v $text }

    putserv "PRIVMSG $text :You Have Been Given Auto-Voice Access For Channel: \002$chan\002"

    putserv "PRIVMSG $ownerOper :$text Given Auto-Voice Access For Channel: \002$chan\002"

  } else { putserv "PRIVMSG $nick :$text Not Found In User Database" }

  unset addopnick

}



proc oper:removevoice { nick host hand chan text } {

global ownerOper

  set addopnick [nick2hand $text]

  if {[validuser $addopnick]} {

    chattr $addopnick -|-ao $chan

    putserv "PRIVMSG $nick :$text Has Been removed from Voice Access"

    putlog "$nick removed $addopnick from Auto-Op"

    if {[isvoice $text $chan] == 1} { pushmode $chan -v $text }

    putserv "PRIVMSG $text :You Have Been Removed From Auto-Voice Access For Channel: \002$chan\002"

    putserv "PRIVMSG $ownerOper :$text Removed Auto-Voice Access For Channel: \002$chan\002"

  } else { putserv "PRIVMSG $nick :$text Not Found In User Database" }

  unset addopnick

}



proc oper:friend { nick host hand chan text } {

global ownerOper

  set addopnick [nick2hand $text]

  if {[validuser $addopnick]} {

    chattr $addopnick -|+f $chan

    putserv "PRIVMSG $nick :$text Has Been added as a bot friend"

    putlog "$nick added $addopnick to channel friend"

    putserv "PRIVMSG $text :You Have Been Added Friend For Channel: \002$chan\002"

    putserv "PRIVMSG $ownerOper :$text Added Friend Access For Channel: \002$chan\002"

  } else { putserv "PRIVMSG $nick :$text Not Found In User Database" }

  unset addopnick

}



proc oper:removefriend { nick host hand chan text } {

global ownerOper

  set addopnick [nick2hand $text]

  if {[validuser $addopnick]} {

    chattr $addopnick -|-f $chan

    putserv "PRIVMSG $nick :$text Has Been removed as a bot friend"

    putlog "$nick removed $addopnick to channel friend"

    putserv "PRIVMSG $text :You Have Been Removed Friend For Channel: \002$chan\002"

    putserv "PRIVMSG $ownerOper :$text Added Removed Access For Channel: \002$chan\002"

  } else { putserv "PRIVMSG $nick :$text Not Found In User Database" }

  unset addopnick

}



proc oper:op {nick host hand chan text} {

global ownerOper

  if {[botisop $chan] == 1} {

    if {[string length $text] > 0} {

      set tnick [lindex $text 0]

      if {[onchan $tnick $chan]} {

        if {[isop $tnick $chan]} { pushmode $chan -o $tnick } else { pushmode $chan +o $tnick }

      } else { puthelp "PRIVMSG $nick :no such nick on channel!" }

    } else { puthelp "PRIVMSG $nick :usage !op <nick> - inverts the ops of a nick" }

  } else { puthelp "PRIVMSG $nick :i dont have ops!" }

}



proc oper:voice {nick host hand chan text} {

global ownerOper

  if {[botisop $chan] == 1} {

    if {[string length $text] > 0} {

      set tnick [lindex $text 0]

      if {[onchan $tnick $chan]} {

        if {[isop $tnick $chan]} { pushmode $chan -v $tnick } else { pushmode $chan +v $tnick }

      } else { puthelp "PRIVMSG $nick :no such nick on channel!" }

    } else { puthelp "PRIVMSG $nick :usage !vo <nick> - inverts the voice of a nick" }

  } else { puthelp "PRIVMSG $nick :i dont have ops!" }

}	



proc oper:kick {nick host hand chan text} {

global ownerOper

  if {[botisop $chan]} {

    if {[string length $text] > 0} {

      set tnick [lindex $text 0]

      if {[string length [lindex $text 1]] == 0} { set reason kicked } else { set reason [lrange $text 1 end] }

      if {[onchan $tnick $chan]} { putkick $chan $tnick $reason } else { puthelp "PRIVMSG $nick :no such nick on channel!" }

    } else { puthelp "PRIVMSG $nick :usage !k <nick> reason - kicks a nick" }

  } else { puthelp "PRIVMSG $nick :i dont have ops!" }

}



proc oper:ban {nick host hand chan text} {

global ownerOper

  if {[botisop $chan]} {

    if {[string length $text] > 0} {

      set tnick [lindex $text 0]

      if {[onchan $tnick $chan]} {

        if {[string length [lindex $text 1]] == 0} { set reason banned } else { set reason [lrange $text 1 end] }

        newchanban $chan *!*@[lindex [split [getchanhost $tnick $chan] @] 1] $nick $reason 0

      } else { puthelp "PRIVMSG $nick :no such nick on channel!" }

    } else { puthelp "PRIVMSG $nick :usage !b <nick> reason - bans a nick" }

  } else { puthelp "PRIVMSG $nick :i dont have ops!" }

}



proc oper:kickban {nick host hand chan text} {

global ownerOper

  if {[botisop $chan]} {

    if {[string length $text] > 0} {

      set tnick [lindex $text 0]

      if {[onchan $tnick $chan]} {

        if {[string length [lindex $text 1]] == 0} { set reason banned } else { set reason [lrange $text 1 end] }

        newchanban $chan *!*@[lindex [split [getchanhost $tnick $chan] @] 1] $nick $reason 0

        utimer 5 [putkick $chan $tnick $reason]

      } else { puthelp "PRIVMSG $nick :no such nick on channel!" }

    } else { puthelp "PRIVMSG $nick :usage !kb <nick> reason - kicks and bans a nick" }

  } else { puthelp "PRIVMSG $nick :i dont have ops!" }

}



proc oper:topic {nick host hand chan text} {

global ownerOper

  if {[botisop $chan]} { putserv "TOPIC $chan :$text" } else { puthelp "PRIVMSG $nick :i dont have ops!" }

}



proc oper:opme {nick host hand chan text} {

global ownerOper

  if {[botisop $chan] == 1} {

    if {[isop $nick $chan] == 0} { pushmode $chan +o $nick } else { puthelp "PRIVMSG $nick :u already have teh op fool" }

  } else { puthelp "PRIVMSG $nick: i dont have ops!" }

}





#HELP SECTION

proc oper:help {nick host hand chan text} {

	global botnick

	puthelp "PRIVMSG $nick :\002Basic User\002 Commands"

	puthelp "PRIVMSG $nick :!auser <nick> - adds a user to bot"

	puthelp "PRIVMSG $nick :!aop <nick> - adds user auto-op to channel"

	puthelp "PRIVMSG $nick :!rmaop <nick> - removes auto-op to channel"

	puthelp "PRIVMSG $nick :!vop <nick> - adds user auto-voice to channel"

	puthelp "PRIVMSG $nick :!rmvop <nick> - removes user auto-voice to channel"

	puthelp "PRIVMSG $nick :!f <nick> - adds user +f to channel"

	puthelp "PRIVMSG $nick :!rmf <nick> - removes user +f to channel"

	puthelp "PRIVMSG $nick :!op <nick> - inverse ops of nick"

	puthelp "PRIVMSG $nick :!vo <nick> - inverse voice of nick"

	puthelp "PRIVMSG $nick :!k <nick> - kicks a user"

	puthelp "PRIVMSG $nick :!kb <nick> <reason - optional> - kicks and bans a user"

	puthelp "PRIVMSG $nick :!topic <text> - sets a channel topic"

	puthelp "PRIVMSG $nick :!opme - if you are set to +o on bot you will be oped"

	if {[matchattr $hand m|n $chan]} {

		puthelp "PRIVMSG $nick :\002Master\002 Commands"

		puthelp "PRIVMSG $nick :!globalaop <nick> - adds global auto-op"

		puthelp "PRIVMSG $nick :!globalvop <nick> - adds global auto-voice"

		puthelp "PRIVMSG $nick :!globalf <nick> - adds global friend"

		puthelp "PRIVMSG $nick :!globalrmaop <nick> - removes global auto-op"

		puthelp "PRIVMSG $nick :!globalrmvop <nick> - removes global auto-voice"

		puthelp "PRIVMSG $nick :!globalrmf <nick> - removes global friend"

		puthelp "PRIVMSG $nick :!rmuser <nick> - removes a user from bot"

		puthelp "PRIVMSG $nick :!lsuser - lists bot users"

		puthelp "PRIVMSG $nick :!+chan <#chan+options> - adds a channel to monitor"

		puthelp "PRIVMSG $nick :!-chan <#chan> - removes a channel from monitor"

		putserv "PRIVMSG $nick :!savechan - Saves channels data"

	}

	if {[matchattr $hand n $chan]} {

		puthelp "PRIVMSG $nick :\002BotOwner\002 Commands"

		puthelp "PRIVMSG $nick :!die - kills bot"

		puthelp "PRIVMSG $nick :!rh - rehash bot"

		puthelp "PRIVMSG $nick :!chattr <nick> <changes> - make raw changes to user as per .chattr in partyline"

		puthelp "PRIVMSG $nick :!save - save config"

		puthelp "PRIVMSG $nick :!rl - reload config"

		puthelp "PRIVMSG $nick :!bu - backup bot"

		puthelp "PRIVMSG $nick :!bc <msg> - broadcast msg to all channels bot is on"

	}

}
