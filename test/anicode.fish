function setup
  set -gx root (dirname (status -f))
  set -gx source $root/functions/anicode.fish
end

test "$TESTNAME It should have ANICODE_CFG with XDG values if set"
  "/xdg/home/anicode" = (set -l XDG_CONFIG_HOME /xdg/home; source $source; echo $ANICODE_CFG)
end

test "$TESTNAME It should have ANICODE_CACHE with XDG values if set"
  "/xdg/cache/anicode" = (set -l XDG_CACHE_HOME /xdg/cache; source $source; echo $ANICODE_CACHE)
end

test "$TESTNAME It should have ANICODE_CFG with default values if XDG is not set"
  ~/.config/anicode = (source $source; echo $ANICODE_CFG)
end

test "$TESTNAME It should have ANICODE_CACHE with default values if XDG is not set"
  ~/.cache/anicode = (source $source; echo $ANICODE_CACHE)
end

test "$TESTNAME It should return grep if agrep is not found"
    "grep" = (mock type 1; __anicode_grep)
end

test "$TESTNAME It should return agrep if found"
    "agrep -1" = (mock type 0; __anicode_grep)
end

test "$TESTNAME It should return pbcopy if found"
    "pbcopy" = (mock type 0; __anicode_xclip)
end

test "$TESTNAME It should return xsel -b if pbcopy not found"
    "xsel -b" = (mock type 1; __anicode_xclip)
end

test "$TESTNAME It should create the dir on installation and ask for installation"
   (
      source $source;
      mock mkdir;
      mock get 0 "echo y";
      mock spin 0 "echo downloading";
      __anicode_install
    ) = "downloading" -a $status -eq 0
end

test "$TESTNAME It should use anygrep for search with params"
   (
    source $source;
    mock anygrep 0 "echo grep";
    mock stat 1;
    mock grep 0;
    mock get;
    mock awk 0;
    mock menu 0;
    set -l choices '0063'
    set -l menu_selected_index 1
    mock __anicode_xclip 0 "echo xclip";
    mock xclip 0 "echo c" # c char in hex
    anicode
  ) = "c"
end

test "$TESTNAME It should be able to install with nontinteractive mode"
  (
    source $source;
    set -g DEBIAN_FRONTEND noninteractive
    mock mkdir;
    mock spin 0 "echo downloading";
    __anicode_install
    ) = "downloading" -a $status -eq 0
end
