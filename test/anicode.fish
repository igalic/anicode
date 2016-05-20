function setup
  set -gx root (dirname (status -f))
  set -gx source $root/functions/anicode.fish
  source $source
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

test "$TESTNAME It should return pbcopy if found"
    "pbcopy" = (mock type 0; __anicode_xclip)
end

test "$TESTNAME It should return xsel -b if pbcopy not found"
    "xsel -b" = (mock type 1; __anicode_xclip)
end

test "$TESTNAME It should create the dir on installation and ask for installation"
   (
   mock mkdir 0;
   mock get 0 "echo y";
   mock spin 0 "echo downloading";
   __anicode_install
  ) = "downloading" -a $status -eq 0
end

test "$TESTNAME It should use anygrep for search with params"
   (
    mock __anicode_install 0
    mock __anicode_grep 0
    mock awk 0 "echo 0063\nfoo";
    mock choices 0 "echo 1";
    mock __anicode_xclip 0 "echo xclip";
    mock xclip 0 "echo c" # c char in hex
    anicode foo
  ) = "c" "Selected c, pasted to your clipboard."
end

test "$TESTNAME It should be able to install with nontinteractive mode"
  (
    set -g DEBIAN_FRONTEND noninteractive
    mock mkdir;
    mock spin 0 "echo downloading";
    __anicode_install
    ) = "downloading" -a $status -eq 0
end

test "$TESTNAME It should display usage on empty param"
   "anicode 'search param'" = (mock __anicode_install 0;anicode) -a $status -eq 1
end

test "$TESTNAME It should be able to accept dashed params"
  (
    set -g ANICODE_FILE $root/test/fixture.data
    mock __anicode_install 0
    anicode -h
  ) = "Selected ♞, pasted to your clipboard." -a $status -eq 0
end
