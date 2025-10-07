-- =====================================================
-- BASIC TEST DATA FOR 11 ENTITIES
-- Premier League Database - Assignment 1
-- =====================================================

-- Insert Stadiums (Entity #1)
INSERT INTO stadiums (id, name, capacity, address, city, country, opened_year) VALUES
(1, 'Old Trafford', 74879, 'Sir Matt Busby Way', 'Manchester', 'England', 1910),
(2, 'Emirates Stadium', 60704, 'Hornsey Road', 'London', 'England', 2006),
(3, 'Anfield', 54074, 'Anfield Road', 'Liverpool', 'England', 1884),
(4, 'Stamford Bridge', 40834, 'Fulham Road', 'London', 'England', 1877),
(5, 'Etihad Stadium', 53400, 'Rowsley Street', 'Manchester', 'England', 2002),
(6, 'Tottenham Hotspur Stadium', 62850, 'High Road', 'London', 'England', 2019),
(7, 'Villa Park', 42095, 'Trinity Road', 'Birmingham', 'England', 1897),
(8, 'St James Park', 52305, 'Barrack Road', 'Newcastle', 'England', 1892),
(9, 'Goodison Park', 39414, 'Goodison Road', 'Liverpool', 'England', 1892),
(10, 'Molineux Stadium', 32050, 'Waterloo Road', 'Wolverhampton', 'England', 1889);

-- Insert Clubs (Entity #2)
INSERT INTO clubs (id, name, short_name, founded_year, country, city, current_stadium_id) VALUES
(1, 'Manchester United', 'MUFC', 1878, 'England', 'Manchester', 1),
(2, 'Arsenal', 'AFC', 1886, 'England', 'London', 2),
(3, 'Liverpool', 'LFC', 1892, 'England', 'Liverpool', 3),
(4, 'Chelsea', 'CFC', 1905, 'England', 'London', 4),
(5, 'Manchester City', 'MCFC', 1880, 'England', 'Manchester', 5),
(6, 'Tottenham Hotspur', 'THFC', 1882, 'England', 'London', 6),
(7, 'Aston Villa', 'AVFC', 1874, 'England', 'Birmingham', 7),
(8, 'Newcastle United', 'NUFC', 1892, 'England', 'Newcastle', 8),
(9, 'Everton', 'EFC', 1878, 'England', 'Liverpool', 9),
(10, 'Wolverhampton Wanderers', 'WWFC', 1877, 'England', 'Wolverhampton', 10);

-- Insert Coaches (Entity #3)
INSERT INTO coaches (id, name, date_of_birth, nationality, licence, current_club_id) VALUES
(1, 'Erik ten Hag', '1970-02-02', 'Netherlands', 'UEFA Pro', 1),
(2, 'Mikel Arteta', '1982-03-26', 'Spain', 'UEFA Pro', 2),
(3, 'Jürgen Klopp', '1967-06-16', 'Germany', 'UEFA Pro', 3),
(4, 'Mauricio Pochettino', '1972-03-02', 'Argentina', 'UEFA Pro', 4),
(5, 'Pep Guardiola', '1971-01-18', 'Spain', 'UEFA Pro', 5),
(6, 'Ange Postecoglou', '1965-08-27', 'Australia', 'UEFA Pro', 6),
(7, 'Unai Emery', '1971-11-03', 'Spain', 'UEFA Pro', 7),
(8, 'Eddie Howe', '1977-11-29', 'England', 'UEFA Pro', 8),
(9, 'Sean Dyche', '1971-06-28', 'England', 'UEFA Pro', 9),
(10, 'Gary O''Neil', '1983-05-18', 'England', 'UEFA Pro', 10);

-- Insert Positions (Entity #4)
INSERT INTO positions (id, code, name) VALUES
(1, 'GK', 'Goalkeeper'),
(2, 'CB', 'Centre-back'),
(3, 'LB', 'Left-back'),
(4, 'RB', 'Right-back'),
(5, 'DM', 'Defensive Midfielder'),
(6, 'CM', 'Central Midfielder'),
(7, 'AM', 'Attacking Midfielder'),
(8, 'LW', 'Left Winger'),
(9, 'RW', 'Right Winger'),
(10, 'ST', 'Striker');

-- Insert Players (Entity #5)
INSERT INTO players (id, name, date_of_birth, nationality, height_cm, preferred_foot, current_club_id) VALUES
(1, 'Bruno Fernandes', '1994-09-08', 'Portugal', 179, 'RIGHT', 1),
(2, 'Mohamed Salah', '1992-06-15', 'Egypt', 175, 'LEFT', 3),
(3, 'Bukayo Saka', '2001-09-05', 'England', 178, 'LEFT', 2),
(4, 'Erling Haaland', '2000-07-21', 'Norway', 194, 'LEFT', 5),
(5, 'Thiago Silva', '1984-09-22', 'Brazil', 181, 'RIGHT', 4),
(6, 'Kevin De Bruyne', '1991-06-28', 'Belgium', 181, 'RIGHT', 5),
(7, 'Martin Ødegaard', '1998-12-17', 'Norway', 178, 'LEFT', 2),
(8, 'Son Heung-min', '1992-07-08', 'South Korea', 183, 'BOTH', 6),
(9, 'Virgil van Dijk', '1991-07-08', 'Netherlands', 195, 'RIGHT', 3),
(10, 'Marcus Rashford', '1997-10-31', 'England', 180, 'RIGHT', 1),
(11, 'Ollie Watkins', '1995-12-30', 'England', 180, 'RIGHT', 7),
(12, 'Alexander Isak', '1999-09-21', 'Sweden', 192, 'RIGHT', 8),
(13, 'Dominic Calvert-Lewin', '1997-03-16', 'England', 187, 'RIGHT', 9),
(14, 'Matheus Cunha', '1999-05-27', 'Brazil', 184, 'RIGHT', 10),
(15, 'Alisson Becker', '1992-10-02', 'Brazil', 193, 'RIGHT', 3);

-- Insert Player Positions (Entity #6 - Junction table)
INSERT INTO player_positions (id, player_id, position_id, is_primary) VALUES
(1, 1, 7, true),    -- Bruno Fernandes -> Attacking Midfielder (primary)
(2, 1, 6, false),   -- Bruno Fernandes -> Central Midfielder (secondary)
(3, 2, 9, true),    -- Mohamed Salah -> Right Winger (primary)
(4, 2, 10, false),  -- Mohamed Salah -> Striker (secondary)
(5, 3, 8, true),    -- Bukayo Saka -> Left Winger (primary)
(6, 3, 9, false),   -- Bukayo Saka -> Right Winger (secondary)
(7, 4, 10, true),   -- Erling Haaland -> Striker (primary)
(8, 5, 2, true),    -- Thiago Silva -> Centre-back (primary)
(9, 6, 6, true),    -- Kevin De Bruyne -> Central Midfielder (primary)
(10, 6, 7, false),  -- Kevin De Bruyne -> Attacking Midfielder (secondary)
(11, 7, 7, true),   -- Martin Ødegaard -> Attacking Midfielder (primary)
(12, 8, 8, true),   -- Son Heung-min -> Left Winger (primary)
(13, 8, 10, false), -- Son Heung-min -> Striker (secondary)
(14, 9, 2, true),   -- Virgil van Dijk -> Centre-back (primary)
(15, 10, 8, true),  -- Marcus Rashford -> Left Winger (primary)
(16, 10, 10, false),-- Marcus Rashford -> Striker (secondary)
(17, 11, 10, true), -- Ollie Watkins -> Striker (primary)
(18, 12, 10, true), -- Alexander Isak -> Striker (primary)
(19, 13, 10, true), -- Dominic Calvert-Lewin -> Striker (primary)
(20, 14, 10, true), -- Matheus Cunha -> Striker (primary)
(21, 15, 1, true);  -- Alisson -> Goalkeeper (primary)

-- Insert Competitions (Entity #7)
INSERT INTO competitions (id, name, type, country, organizer) VALUES
(1, 'Premier League', 'LEAGUE', 'England', 'Premier League Ltd'),
(2, 'FA Cup', 'CUP', 'England', 'The FA'),
(3, 'UEFA Champions League', 'CONTINENTAL', null, 'UEFA'),
(4, 'UEFA Europa League', 'CONTINENTAL', null, 'UEFA'),
(5, 'EFL Cup', 'CUP', 'England', 'EFL');

-- Insert Seasons (Entity #8)
INSERT INTO seasons (id, label, start_date, end_date) VALUES
(1, '2022/23', '2022-08-06', '2023-05-28'),
(2, '2023/24', '2023-08-12', '2024-05-19'),
(3, '2024/25', '2024-08-17', '2025-05-25');

-- Insert Honours (Entity #9)
INSERT INTO honours (id, competition_id, season_id, club_id, position, date_awarded, description) VALUES
(1, 1, 1, 5, 1, '2023-05-28', 'Premier League Champions 2022/23'),
(2, 1, 1, 2, 2, '2023-05-28', 'Premier League Runners-up 2022/23'),
(3, 1, 1, 1, 3, '2023-05-28', 'Premier League Third Place 2022/23'),
(4, 2, 1, 5, 1, '2023-06-03', 'FA Cup Winners 2022/23'),
(5, 1, 2, 5, 1, '2024-05-19', 'Premier League Champions 2023/24'),
(6, 1, 2, 2, 2, '2024-05-19', 'Premier League Runners-up 2023/24');

-- Insert Referees (Entity #10)
INSERT INTO referees (id, name, nationality, date_of_birth, licence) VALUES
(1, 'Michael Oliver', 'England', '1985-02-20', 'FIFA Referee'),
(2, 'Anthony Taylor', 'England', '1978-10-20', 'FIFA Referee'),
(3, 'Martin Atkinson', 'England', '1971-03-31', 'FIFA Referee'),
(4, 'Craig Pawson', 'England', '1979-03-05', 'FIFA Referee'),
(5, 'Paul Tierney', 'England', '1980-12-25', 'FIFA Referee'),
(6, 'Simon Hooper', 'England', '1982-07-15', 'FIFA Referee'),
(7, 'Chris Kavanagh', 'England', '1985-06-14', 'FIFA Referee'),
(8, 'David Coote', 'England', '1982-12-09', 'FIFA Referee'),
(9, 'Stuart Attwell', 'England', '1982-10-06', 'FIFA Referee'),
(10, 'Andy Madley', 'England', '1984-10-02', 'FIFA Referee');

-- Insert Matches (Entity #11)
INSERT INTO matches (id, competition_id, season_id, matchday_round, match_datetime,
                    home_club_id, away_club_id, stadium_id, referee_id,
                    home_goals, away_goals, status) VALUES
-- 2024/25 Season - Matchday 1
(1, 1, 3, 1, '2024-08-17 15:00:00', 1, 2, 1, 1, 2, 1, 'FINISHED'),
(2, 1, 3, 1, '2024-08-17 15:00:00', 3, 4, 3, 2, 1, 1, 'FINISHED'),
(3, 1, 3, 1, '2024-08-17 17:30:00', 5, 6, 5, 3, 3, 0, 'FINISHED'),
(4, 1, 3, 1, '2024-08-18 14:00:00', 7, 8, 7, 4, 2, 2, 'FINISHED'),
(5, 1, 3, 1, '2024-08-18 16:30:00', 9, 10, 9, 5, 0, 1, 'FINISHED'),

-- 2024/25 Season - Matchday 2
(6, 1, 3, 2, '2024-08-24 15:00:00', 2, 5, 2, 6, 1, 2, 'FINISHED'),
(7, 1, 3, 2, '2024-08-24 15:00:00', 4, 3, 4, 7, 0, 3, 'FINISHED'),
(8, 1, 3, 2, '2024-08-24 17:30:00', 6, 1, 6, 8, 2, 2, 'FINISHED'),
(9, 1, 3, 2, '2024-08-25 14:00:00', 8, 7, 8, 9, 1, 0, 'FINISHED'),
(10, 1, 3, 2, '2024-08-25 16:30:00', 10, 9, 10, 10, 2, 1, 'FINISHED'),

-- 2024/25 Season - Matchday 3 (upcoming)
(11, 1, 3, 3, '2024-08-31 15:00:00', 1, 3, 1, 1, null, null, 'SCHEDULED'),
(12, 1, 3, 3, '2024-08-31 15:00:00', 5, 4, 5, 2, null, null, 'SCHEDULED'),
(13, 1, 3, 3, '2024-08-31 17:30:00', 2, 6, 2, 3, null, null, 'SCHEDULED'),
(14, 1, 3, 3, '2024-09-01 14:00:00', 7, 9, 7, 4, null, null, 'SCHEDULED'),
(15, 1, 3, 3, '2024-09-01 16:30:00', 8, 10, 8, 5, null, null, 'SCHEDULED');

-- Update sequences to continue from our manual IDs
SELECT setval('stadiums_id_seq', 10);
SELECT setval('clubs_id_seq', 10);
SELECT setval('coaches_id_seq', 10);
SELECT setval('positions_id_seq', 10);
SELECT setval('players_id_seq', 15);
SELECT setval('player_positions_id_seq', 21);
SELECT setval('competitions_id_seq', 5);
SELECT setval('seasons_id_seq', 3);
SELECT setval('honours_id_seq', 6);
SELECT setval('referees_id_seq', 10);
SELECT setval('matches_id_seq', 15);