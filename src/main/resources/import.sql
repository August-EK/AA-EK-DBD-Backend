-- Insert stadiums first
INSERT INTO stadiums (id, name, capacity, address, city, country, opened_year) VALUES
(1, 'Old Trafford', 74879, 'Sir Matt Busby Way', 'Manchester', 'England', 1910),
(2, 'Emirates Stadium', 60704, 'Hornsey Road', 'London', 'England', 2006),
(3, 'Anfield', 54074, 'Anfield Road', 'Liverpool', 'England', 1884),
(4, 'Stamford Bridge', 40834, 'Fulham Road', 'London', 'England', 1877),
(5, 'Etihad Stadium', 53400, 'Rowsley Street', 'Manchester', 'England', 2002);

-- Insert clubs (single set, no duplicates)
INSERT INTO clubs (id, name, short_name, founded_year, country, city, current_stadium_id) VALUES
(1, 'Manchester United', 'MUFC', 1878, 'England', 'Manchester', 1),
(2, 'Arsenal', 'AFC', 1886, 'England', 'London', 2),
(3, 'Liverpool', 'LFC', 1892, 'England', 'Liverpool', 3),
(4, 'Chelsea', 'CFC', 1905, 'England', 'London', 4),
(5, 'Manchester City', 'MCFC', 1880, 'England', 'Manchester', 5);

-- Insert positions
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

-- Insert sample players (OPDATERET med current_club_id)
INSERT INTO players (id, name, date_of_birth, nationality, height_cm, preferred_foot, current_club_id) VALUES
                                                                                                           (1, 'Bruno Fernandes', '1994-09-08', 'Portugal', 179, 'RIGHT', 1),  -- Manchester United
                                                                                                           (2, 'Mohamed Salah', '1992-06-15', 'Egypt', 175, 'LEFT', 3),        -- Liverpool
                                                                                                           (3, 'Bukayo Saka', '2001-09-05', 'England', 178, 'LEFT', 2),        -- Arsenal
                                                                                                           (4, 'Erling Haaland', '2000-07-21', 'Norway', 194, 'LEFT', 5),      -- Manchester City
                                                                                                           (5, 'Thiago Silva', '1984-09-22', 'Brazil', 181, 'RIGHT', 4);       -- Chelsea

-- Insert player positions (eksempel)
INSERT INTO player_positions (id, player_id, position_id, is_primary) VALUES
(1, 1, 7, true),   -- Bruno Fernandes -> Attacking Midfielder (primary)
(2, 1, 6, false),  -- Bruno Fernandes -> Central Midfielder (secondary)
(3, 2, 9, true),   -- Mohamed Salah -> Right Winger (primary)
(4, 2, 10, false), -- Mohamed Salah -> Striker (secondary)
(5, 3, 8, true),   -- Bukayo Saka -> Left Winger (primary)
(6, 3, 9, false),  -- Bukayo Saka -> Right Winger (secondary)
(7, 4, 10, true),  -- Erling Haaland -> Striker (primary)
(8, 5, 2, true);   -- Thiago Silva -> Centre-back (primary)


-- Insert referees
INSERT INTO referees (id, name, nationality) VALUES
(1, 'Michael Oliver', 'England'),
(2, 'Anthony Taylor', 'England'),
(3, 'Martin Atkinson', 'England'),
(4, 'Craig Pawson', 'England'),
(5, 'Paul Tierney', 'England');

-- Insert competitions
INSERT INTO competitions (id, name, type, country, organizer) VALUES
(1, 'Premier League', 'LEAGUE', 'England', 'Premier League Ltd'),
(2, 'FA Cup', 'CUP', 'England', 'The FA'),
(3, 'UEFA Champions League', 'CONTINENTAL', null, 'UEFA'),
(4, 'UEFA Europa League', 'CONTINENTAL', null, 'UEFA'),
(5, 'EFL Cup', 'CUP', 'England', 'EFL');

-- Insert seasons
INSERT INTO seasons (id, label, start_date, end_date) VALUES
(1, '2023/24', '2023-08-12', '2024-05-19'),
(2, '2024/25', '2024-08-17', '2025-05-25'),
(3, '2022/23', '2022-08-06', '2023-05-28');




-- Insert coaches
INSERT INTO coaches (id, name, date_of_birth, nationality, licence, current_club_id) VALUES
(1, 'Erik ten Hag', '1970-02-02', 'Netherlands', 'UEFA Pro', 1),      -- Manchester United
(2, 'Mikel Arteta', '1982-03-26', 'Spain', 'UEFA Pro', 2),            -- Arsenal
(3, 'Jürgen Klopp', '1967-06-16', 'Germany', 'UEFA Pro', 3),          -- Liverpool
(4, 'Mauricio Pochettino', '1972-03-02', 'Argentina', 'UEFA Pro', 4), -- Chelsea
(5, 'Pep Guardiola', '1971-01-18', 'Spain', 'UEFA Pro', 5);           -- Manchester City
