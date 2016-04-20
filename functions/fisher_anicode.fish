function fisher_anicode
    set -l ucdata /home/igalic/src/me/anicode/UnicodeData-8.0.txt

    set -e anygrep
    if command -s agrep > /dev/null
        set -u anygrep 'agrep -1'
    else
        set -u anygrep grep
    end

    set -lu $last
    eval $anygrep -i "\"$argv\"" $ucdata | awk -F';' '{ printf "%s\t%s\n", $1, $2 }' | \
    while read -l char -l name
      $last = $char
      printf "\U$char\t$name\n"
    end
    echo $last | xsel -b
end
