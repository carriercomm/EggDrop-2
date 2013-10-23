set scriptpath_git "/home/eDrop/scripts/git/"

bind time - "?1 * * * *" git_announce
bind time - "?2 * * * *" git_announce
bind time - "?3 * * * *" git_announce
bind time - "?4 * * * *" git_announce
bind time - "?5 * * * *" git_announce
bind time - "?6 * * * *" git_announce
bind time - "?7 * * * *" git_announce
bind time - "?8 * * * *" git_announce
bind time - "?9 * * * *" git_announce
bind time - "?0 * * * *" git_announce

proc git_announce { min hour day month year } {
  putlog "execute git announce"
  global scriptpath_git
  set result [exec $scriptpath_git/GitPull.pl]
  set result [split $result \n]
  foreach line $result {
    putquick "PRIVMSG #git :$line"
  }
}
