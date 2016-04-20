fisher-anicode(1) -- Find unicode characters matching your search string
===================================================

## SYNOPSIS

fisher anicode *search string*<br>

## USAGE

fisher anicode search string

## DESCRIPTION

anicode prints out a table unicode characters and their names, based on the
*search string* that matches those names. If there's [agrep(1)] installed,
`anicode` will use that to provide fuzzy search.

## EXAMPLES

```fish
anicode playing card ace
🂡      PLAYING CARD ACE OF SPADES
🂱      PLAYING CARD ACE OF HEARTS
🃁      PLAYING CARD ACE OF DIAMONDS
🃑      PLAYING CARD ACE OF CLUBS
```

Without fuzzy search:

```fish
anicode lambda
ƛ       LATIN SMALL LETTER LAMBDA WITH STROKE
Λ       GREEK CAPITAL LETTER LAMDA
λ       GREEK SMALL LETTER LAMDA
```

With fuzzy search:

```fish
ƛ       LATIN SMALL LETTER LAMBDA WITH STROKE
Λ       GREEK CAPITAL LETTER LAMDA
λ       GREEK SMALL LETTER LAMDA
൹       MALAYALAM DATE MARK
ᴧ       GREEK LETTER SMALL CAPITAL LAMDA
𐎍      UGARITIC LETTER LAMDA
𝚲      MATHEMATICAL BOLD CAPITAL LAMDA
𝛌      MATHEMATICAL BOLD SMALL LAMDA
𝛬      MATHEMATICAL ITALIC CAPITAL LAMDA
𝜆      MATHEMATICAL ITALIC SMALL LAMDA
𝜦      MATHEMATICAL BOLD ITALIC CAPITAL LAMDA
𝝀      MATHEMATICAL BOLD ITALIC SMALL LAMDA
𝝠      MATHEMATICAL SANS-SERIF BOLD CAPITAL LAMDA
𝝺      MATHEMATICAL SANS-SERIF BOLD SMALL LAMDA
𝞚      MATHEMATICAL SANS-SERIF BOLD ITALIC CAPITAL LAMDA
𝞴      MATHEMATICAL SANS-SERIF BOLD ITALIC SMALL LAMDA
```


## SEE ALSO

* agrep(1)

[agrep(1)]: http://linux.die.net/man/1/agrep
