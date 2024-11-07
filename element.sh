#!/bin/bash

# Connect to the periodic_table database
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if an argument is provided
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit
fi

# Query the database based on input, which can be an atomic number, symbol, or name
ELEMENT_RESULT=$($PSQL "SELECT elements.atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius 
                        FROM elements 
                        INNER JOIN properties ON elements.atomic_number = properties.atomic_number 
                        INNER JOIN types ON properties.type_id = types.type_id 
                        WHERE elements.atomic_number::text = '$1' 
                        OR symbol = '$1' 
                        OR name = '$1'")

# Check if the element was found
if [[ -z $ELEMENT_RESULT ]]; then
  echo "I could not find that element in the database."
else
  # Parse the result into variables
  IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$ELEMENT_RESULT"
  
  # Output the formatted element information
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
fi
