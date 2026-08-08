bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[5C" forward-word
bindkey "^[[5D" backward-word
bindkey "^[OC" forward-word
bindkey "^[OD" backward-word
bindkey "^[[3~" delete-char

_accept_or_forward_word() {
  if [[ -n $BUFFER && $CURSOR -eq $#BUFFER ]]; then
    zle autosuggest-accept
  else
    zle forward-word
  fi
}
zle -N _accept_or_forward_word

bindkey "^[OC"     _accept_or_forward_word
bindkey "^[[C"     _accept_or_forward_word


_accept_or_forward_char() {
  if [[ -n $BUFFER && $CURSOR -eq $#BUFFER ]]; then
    zle autosuggest-accept
  else
    zle forward-char
  fi
}
zle -N _accept_or_forward_char

bindkey "^[OC" _accept_or_forward_char
bindkey "^[[C" _accept_or_forward_char
bindkey "^[OD" backward-char
bindkey "^[[D" backward-char
