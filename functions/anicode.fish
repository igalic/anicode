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
function __anicode_grep -a what -a where
  if type -q agrep
    agrep -i1 (echo -en $what | sed -r 's:-:\\\-:g') $where
    return
  end
  grep -i -- $what $where
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
  if test "$DEBIAN_FRONTEND" = "noninteractive"
    set desired y
  else
    set -l prompt "Required unicode data was not found, want me to download it from http://www.unicode.org? [Y/n]"
    get --prompt="$prompt" --rule="[yn]" --default="y" --no-case | read -l r
    set desired $r
  end

  if test "$desired" = "y" -o "$desired" = "Y"
     if not spin --error /dev/null "curl --create-dirs -fsSo $ANICODE_FILE \
         https://unicode.org/Public/UCD/latest/ucd/UnicodeData.txt"
         printf "An error occured, unicode data could not be downloaded."
         rm $ANICODE_CACHE
         return 1
     end
     return
  end

  return 1
end

# public api
function anicode
    set -l usage "anicode 'search param'"

    if test -z "$argv"
      echo $usage
      return 1
    end

    if not test -e $ANICODE_FILE
        if not __anicode_install
          return 1
        end
        # functions -e __anicode_install
    end

    set -l options
    set -l labels
    set -l index
    set -l char

    __anicode_grep "$argv" $ANICODE_FILE | awk -F';' '{ printf "%s\t%s\n", $1, $2 }' | while read -l char -l name
          set options $options "\U$char"
          set labels $labels (printf "\U$char\t$name")
      end

    if test -z "$labels"
      echo $argv was not found 😢
      echo $usage
      return 1
    end
    if test (count $options) -eq 1
      set index 1
      set char $options[$index]
    else
      set index (choices $labels)
      set char $options[$index]
    end
    printf $char | eval (__anicode_xclip)
    printf "Selected %s, pasted to your clipboard.\n" (printf $char)
end
