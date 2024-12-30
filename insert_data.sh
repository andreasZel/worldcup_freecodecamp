#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

$PSQL "TRUNCATE TABLE games, teams"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

  if [[ $YEAR != 'year' ]]
  then
    winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    if [[ -z $winner_id ]]
    then 
      query_result_winner=$($PSQL "insert into teams(name) values('$WINNER')")
      
      if [[ $query_result_winner == "INSERT 0 1" ]]
      then
        echo Inserted team $WINNER
      fi

      winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    if [[ -z $opponent_id ]]
    then 
      query_result_opponent=$($PSQL "insert into teams(name) values('$OPPONENT')")
      
      if [[ $query_result_opponent == "INSERT 0 1" ]]
      then
        echo Inserted team $OPPONENT
      fi

      opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    query_result_games=$($PSQL "insert into games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) values($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $winner_id, $opponent_id)")

    if [[ $query_result_games == "INSERT 0 1" ]]
    then
      echo Inserted game
    fi
  fi
done