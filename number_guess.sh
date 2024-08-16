#!/bin/bash

$RANDOM
rn=`shuf -i 1-1000 -n 1`

query(){
  echo `psql --username=freecodecamp --dbname=number_guess -t --no-align --field-separator=" | " -q -c "$1"`
}


echo "Enter your username:"
read un

# check if username exists
un_res=`query "select name from games where name='$un'"` #replace distinct
if [[ -z $un_res ]]
then
  echo Welcome, $un! It looks like this is your first time here.
else
  read gp bar hs <<< "`query "select count(game_id), min(score) from games where name='$un'"`"
  echo "Welcome back, $un! You have played $gp games, and your best game took $hs guesses."
fi

echo "Guess the secret number between 1 and 1000:"


count=0;
prompt(){
  count=$(( count+1 ))
  read input 
  if [[ $input =~ ^-?[0-9]+$ ]]; then
    if [[ $input -gt $rn ]]; then
      echo "It's lower than that, guess again:"
      prompt
    elif [[ $input -lt $rn ]]; then
      echo "It's higher than that, guess again:"
      prompt
    else
      echo "You guessed it in $count tries. The secret number was $rn. Nice job!"
      query "insert into games(name,score) values('$un','$count')"
    fi
  else
    echo "That is not an integer, guess again:"
    prompt
  fi
}

prompt