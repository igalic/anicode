function __anicode_home
  if test -n "$XDG_CONFIG_HOME"
    set config $XDG_CONFIG_HOME
  else
    set config ~/.config
  end
  echo $config/anicode
end

function __anicode_prompt
  set message $argv[1]
  function __prompt --inherit-variable message
    echo "The file with the required unicode data is not found, do you want me to download it from http://www.unicode.org ? [Y/n] "
    functions -e __prompt
  end
  while true
    read -l confirm --prompt=__prompt
    switch $confirm
      case Y y
        return 0
      case '' N n
        return 1
    end
  end
end

function __anicode_install
  set root (__anicode_home)
  if not test -e "$root"
    mkdir $test
  end
  function __msg
    echo -n "The file with the required unicode data is not found,"
    echo -n " do you want me to download it from http://www.unicode.org ?"
  end
  if not test -e "$root/unicode.csv"
    set prompt (__msg)
    if __anicode_prompt "$prompt"
       set cmd "curl -o $root/unicode.csv http://www.unicode.org/Public/8.0.0/ucd/UnicodeData.txt"
       if type spin > /dev/null
         spin $cmd
       else
        eval $cmd
       end
    end
  end
end

function __anicode_grep
  if type grep > /dev/null
    echo grep
    return
  end
  echo agrep -1
end

function __anicode_xclip
  if type pbcopy > /dev/null
    echo pbcopy
    return
  end
  echo xsel -b
end

function anicode
    set home (__anicode_home)
    set anygrep (__anicode_grep)
    set ucdata $home/unicode.csv

    set -lu $last
    eval $anygrep -i "\"$argv\"" $ucdata | awk -F';' '{ printf "%s\t%s\n", $1, $2 }' | \
      while read -l char -l name
        set last $char
        printf "\U$char\t$name\n"
      end
    echo $last | eval (__anicode_xclip)
end

__anicode_install
