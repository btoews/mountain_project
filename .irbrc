IRB.conf[:PROMPT][:MPSHELL] = {
  :PROMPT_I=>"mp-shell> ",
  :PROMPT_N=>"mp-shell> ",
  :PROMPT_S=>"mp-shell> ",
  :PROMPT_C=>"mp-shell> ",
  :RETURN=>"%s\n"
}

IRB.conf[:PROMPT_MODE] = :MPSHELL

IRB.conf[:SAVE_HISTORY] = 100
IRB.conf[:HISTORY_FILE] = ".mp-shell.history"
