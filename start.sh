#!/bin/bash
if [ "" = "$(cat word.txt)" ]; then
  read -s -p "Write a word to guess" word
  echo "$word" > word.txt
  echo "\n"
fi


# Gameplay loop
while true; do
    if [ "" = "$(cat word.txt)" ]; then
      break
    fi

    # Prompt the user to input a letter
    read -p "Guess a letter: " guess

    if [ ${#guess} -ne 1 ]; then
        echo "Please enter a single letter."
        continue
    fi
    awk -v guess="$guess" -f hangman.awk word.txt
done
