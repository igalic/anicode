# environment
set -gx ANICODE_CFG
set -gx ANICODE_CACHE

if test -n "$XDG_CONFIG_HOME"
  set ANICODE_CFG $XDG_CONFIG_HOME/anicode
else
  set ANICODE_CFG ~/.config/anicode
end

if test -n "$XDG_CACHE_HOME"
  set ANICODE_CACHE $XDG_CACHE_HOME/anicode
else
  set ANICODE_CACHE ~/.cache/anicode
end

set -gx ANICODE_FILE $ANICODE_CACHE/unicode.csv

# helpers
function __anicode_grep
  if type -q agrep
    echo agrep -1
    return
  end
  echo grep
end

function __anicode_xclip
    if type -q pbcopy
        echo pbcopy
        return
    end
    echo xsel -b
end

# initial setup
function __anicode_install
  set -l desired
  mkdir -p $ANICODE_CACHE
  if test "$DEBIAN_FRONTEND" = "noninteractive"
    set desired y
  else
    set -l prompt "Required unicode data was not found, want me to download it from http://www.unicode.org? [Y/n]"
    get --prompt="$prompt" --rule="[yn]" --default="y" --no-case | read -l r
    set desired $r
  end

  if test "$desired" = "y" -o "$desired" = "Y"
     spin "curl -o $ANICODE_FILE http://www.unicode.org/Public/8.0.0/ucd/UnicodeData.txt > /dev/null"
     return 0
  else
    return 1
  end
end

# public api
function anicode
    set anygrep (__anicode_grep)

    if not test -e $ANICODE_FILE
        if not __anicode_install
          return 1
        end
        # functions -e __anicode_install
    end

    set -l choices
    set -l labels
    eval $anygrep -i "( echo $argv)" $ANICODE_FILE | awk -F';' '{ printf "%s\t%s\n", $1, $2 }' | \
      while read -l char -l name
          set choices $choices "\U$char"
          set labels $labels "\U$char\t$name"
      end
    menu $labels
    set -l char $choices[$menu_selected_index]
    printf $char | eval (__anicode_xclip)
end
