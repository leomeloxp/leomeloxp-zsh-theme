# leomeloxp zsh theme

### Prompt colour helpers
p_colour() {
  local colour=$1 || 'blue'

  echo -n "%{%F{$colour}%}"
}

p_reset() {
  echo -n %{%f%}
}

### Prompt components
# Context: user@hostname (who am I and where am I)
prompt_context() {
    local user=`whoami`
    if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
        echo -n "%n@%m"
    else
        echo -n "λ"
    fi
}

prompt_location() {
  where=$PWD
  home=$HOME
  work="$home/Development"

  where="${where/$work/Δ }"
  where="${where/$home/α }"

  echo -n "$where"
}
# Status:
# - was there an error
# - are there background jobs?
# - am I root
prompt_status() {
    local symbols
    symbols=()
    [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘%{%f%}"
    [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{magenta}%}⚙%{%f%}"
    [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡%{%f%}" || symbols+="%{%F{cyan}%}♫%{%f%}"

    [[ -n "$symbols" ]] && echo -n "$symbols"
}

## Main prompt
build_prompt() {
    p_colour blue
    echo -n "┌─"
    p_reset
    p_colour cyan
    echo -n " `prompt_context` "
    p_colour blue
    echo -n "──"
    p_reset
    p_colour green
    echo -n " `prompt_location` "
    # echo -n " %~ "
    p_reset
    p_colour blue
    echo -n "──"
    p_reset
    echo -n " `git_super_status` "
    p_reset
    RETVAL=$?
    printf "\n"
    p_colour blue
    echo -n "└─"
    p_reset
    echo -n " `prompt_status` "
    p_colour blue
    echo -n "──"
    p_reset
}

PROMPT='%{%f%b%k%}$(build_prompt) '

PROMPT='%{%f%b%k%}$(build_prompt) '

precmd(){
    printf '\e]0;%s@%s: %s\a' "${prompt_user}" "${prompt_host}" "${prompt_char}"
}

preexec(){
    printf '\e]0;%s [%s@%s: %s]\a' "$2" "${prompt_user}" "${prompt_host}" "${prompt_char}"		
}
