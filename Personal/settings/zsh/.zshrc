# Lines configured by zsh-newuser-install
HISTFILE=~/.config/zsh/.histfile
HISTSIZE=50000
SAVEHIST=10000
setopt autocd extendedglob nomatch notify
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/anisbsalah/.config/zsh/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

### PLUGINS
source "$HOME/.config/zsh/clipboard.zsh"
source "$HOME/.config/zsh/completion.zsh"
source "$HOME/.config/zsh/functions.zsh"
source "$HOME/.config/zsh/key-bindings.zsh"

if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

### ALIASES
if [ -f ~/.config/zsh/zsh_aliases ]; then
    . ~/.config/zsh/zsh_aliases
fi

### ranger-cd
function ranger-cd {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
        if [ "$(cat -- "$tempfile")" != "$(echo -n $(pwd))" ]; then
            cd -- "$(cat "$tempfile")"
        fi
    rm -f -- "$tempfile"
}

### ranger-cd will run by alt+r
bindkey -s "^\er" "ranger-cd\n"

### reporting tools - install when not installed
# fetch
# hfetch
# neofetch
# pfetch
# screenfetch
# sfetch

### Oh My Posh
#eval "$(oh-my-posh init zsh)"

### Starship
eval "$(starship init zsh)"
