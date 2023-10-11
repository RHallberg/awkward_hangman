BEGIN {FS = ","}
NR == 1 {
  word = tolower($1);
  nbr_incorrect = ($4 == "") ? 0 : $4;
  if ($2 ~ guess || $3 ~ guess) {print "you've already guessed this";correct=$2; incorrect=$3 }
  else if (word ~ guess) { print "good guess! You are correct"; correct=sprintf("%s%s", $2, guess)}
  else { print "Wrong! You suck" ; incorrect=sprintf("%s%s", $3, guess); nbr_incorrect++; correct=$2}
}
END {
  state = sprintf("%s,%s,%s,%s\n", word, correct, incorrect, nbr_incorrect)

  system(sprintf("awk -v row=\"%s\"  \'BEGIN{ RS=\",\"} NR == row {print $0}\' icons.dat", nbr_incorrect+1))
  print ""
  if (nbr_incorrect >= 7) {

    system(sprintf("awk -v row=\"%s\"  \'BEGIN{ RS=\",\"} NR == row {print $0}\' icons.dat", nbr_incorrect))
    print "You lost. You are a dork and you suck!"
    printf("The word was: %s \n I can't believe you couldn't guess that. Now a person is dead because of you\n", word)
    print "" > "word.txt"
    exit
  }
  correct_letters = 0
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
    if(length(word) == correct_letters){
      print "You won. Congrats!"
      print "" > "word.txt"
      exit
    }

    print state > "word.txt"
}
