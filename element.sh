#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
  then
    echo Please provide an element as an argument.
  else
    # Query
    QUERY="SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements JOIN properties USING (atomic_number) JOIN types USING(type_id)"
    # Check for argument if numeric
    if [[ $1 =~ ^[0-9]+$ ]] 
      then
        GET_ELEMENT=$($PSQL "$QUERY WHERE atomic_number=$1")
      else
        GET_ELEMENT=$($PSQL "$QUERY WHERE LOWER(symbol) = LOWER('$1') OR LOWER(name) = LOWER('$1')")
    fi

    if [[ -z $GET_ELEMENT ]]
      then
        echo "I could not find that element in the database."
      else
        echo "$GET_ELEMENT" | while read AM BAR SYMBOL BAR NAME BAR MASS BAR MELTING BAR BOILING BAR TYPE 
        do
          echo "The element with atomic number $AM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
        done
    fi
fi