BEGIN {FS = ","}
NR == 1 {
  word = tolower($1);
  nbr_incorrect = ($4 == "") ? 0 : $4;
  # The guessing
  if ($2 ~ guess || $3 ~ guess) {print "you've already guessed this";correct=$2; incorrect=$3 }
  else if (word ~ guess) { print "good guess! You are correct"; correct=sprintf("%s%s", $2, guess); incorrect=$3}
  else { print "Wrong! You suck" ; incorrect=sprintf("%s%s", $3, guess); nbr_incorrect++; correct=$2}
}
END {
  state = sprintf("%s,%s,%s,%s\n", word, correct, incorrect, nbr_incorrect)

  # Printing the hangman himself
  system(sprintf("awk -v row=\"%s\"  \'BEGIN{ RS=\",\"} NR == row {print $0}\' icons.dat", nbr_incorrect+1))
  print ""

  # Lose state
  if (nbr_incorrect >= 7) {

    system(sprintf("awk -v row=\"%s\"  \'BEGIN{ RS=\",\"} NR == row {print $0}\' icons.dat", nbr_incorrect+1))
    print "You lost. You are a dork and you suck!"
    printf("The word was: %s \n I can't believe you couldn't guess that. Now a person is dead because of you\n", word)
    print "" > "word.txt"
    exit
  }
  correct_letters = 0

  # Printing the word with the guessed letters
  for (i = 1; i <= length(word); i++) {
        char = substr(word, i, 1);
        if (correct!= "" && correct ~ char) {
          printf("%s ", char)
          correct_letters++
        }
        else {
          printf("_ ")

        }
  }
  printf("\n")

  # Print the incorrect guesses
  gsub("", " ", incorrect)
  printf("Incorrect guesses:\n %s \n\n", incorrect)

  # Win state
  if(length(word) == correct_letters){
    print "You won. Congrats!"
    print "" > "word.txt"
    exit
  }
  # Put state in the file for the next iteration
  print state > "word.txt"
}
