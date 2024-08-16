#!/bin/bash

rn=$(shuf -i 1-1000 -n 1)
psql="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"


echo "Enter your username:"
read un