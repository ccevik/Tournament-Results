-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.


/*
  Creates the Players table
*/
CREATE TABLE players (id SERIAL primary key,
                      name TEXT);


/*
  Creats the Matches table
*/
CREATE TABLE matches (id SERIAL primary key,
                      winner INTEGER REFERENCES players (id),
                      loser INTEGER REFERENCES players (id));


/*
   Crates a table to list the number of wins for each player
*/
CREATE VIEW each_player_wins AS SELECT winner,COUNT(winner)
                             AS winnercount FROM matches GROUP BY winner;


/*
  Creates a table that shows player id, player name, winner count from last test
*/
CREATE VIEW last_test AS SELECT players.id, players.name, count(matches.winner) AS winnercount,
                                              (SELECT * FROM each_player_wins) as num_matches
                                              FROM players LEFT JOIN matches
                                              ON players.id = matches.winner
                                              GROUP BY players.id
                                              ORDER BY winnercount DESC;


/*
  Number of matches
*/
CREATE VIEW numMatchesView AS SELECT player, count(*) total
                                FROM(
                                	SELECT player1 as player
                                	FROM matches
                                	UNION ALL
                                	SELECT player2
                                	FROM matches
                                ) match_count
                                GROUP BY player;


/*
  Shows a table with id, name, matches won, and matches played
*/
CREATE VIEW WIN_VIEW AS SELECT players.id, players.player_name, coalesce(each_player_wins.winnercount, 0)
                     AS wins, coalesce(numMatchesView.total,0) AS no_matches FROM players
                     LEFT JOIN each_player_wins ON each_player_wins.winner = players.id
                     LEFT JOIN numMatchesView ON numMatchesView.player = players.id
                     GROUP BY players.id, each_player_wins.winnercount, numMatchesView.total
                     ORDER BY last_test.winnercount DESC;                                
