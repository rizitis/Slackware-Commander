#!/bin/bash

# List of adjectives
adjectives=(
  "ugly"
  "stupid"
  "smelly"
  "arrogant"
  "clueless"
)

# List of nouns
nouns=(
  "moron"
  "idiot"
  "buffoon"
  "jackass"
  "dumbass"
)

# Generate random insult
adjective=$(shuf -n 1 <<< "${adjectives[@]}")
noun=$(shuf -n 1 <<< "${nouns[@]}")
insult="You $adjective $noun!"

# Print insult
echo $insult
