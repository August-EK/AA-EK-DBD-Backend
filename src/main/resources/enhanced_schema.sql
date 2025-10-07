-- Enhanced Premier League Database Schema
-- This builds on your existing import.sql with proper constraints, indexes, and referential integrity

-- =====================================================
-- CONSTRAINTS (Business Logic Validation)
-- =====================================================

-- Club constraints
ALTER TABLE clubs ADD CONSTRAINT chk_founded_year CHECK (founded_year > 1800 AND founded_year <= EXTRACT(YEAR FROM CURRENT_DATE));
ALTER TABLE clubs ADD CONSTRAINT chk_uefa_coefficient CHECK (uefa_coefficient >= 0 AND uefa_coefficient <= 200);

-- Player constraints
ALTER TABLE players ADD CONSTRAINT chk_height CHECK (height_cm > 140 AND height_cm < 220);
ALTER TABLE players ADD CONSTRAINT chk_birth_date CHECK (date_of_birth < CURRENT_DATE);

-- Stadium constraints
ALTER TABLE stadiums ADD CONSTRAINT chk_capacity CHECK (capacity > 0 AND capacity < 200000);
ALTER TABLE stadiums ADD CONSTRAINT chk_opened_year CHECK (opened_year > 1800 AND opened_year <= EXTRACT(YEAR FROM CURRENT_DATE));

-- Match constraints
ALTER TABLE matches ADD CONSTRAINT chk_goals CHECK (home_goals >= 0 AND away_goals >= 0);
ALTER TABLE matches ADD CONSTRAINT chk_match_date CHECK (match_datetime > '1992-08-15'); -- Premier League started
ALTER TABLE matches ADD CONSTRAINT chk_different_clubs CHECK (home_club_id != away_club_id);

-- Transfer constraints
ALTER TABLE transfers ADD CONSTRAINT chk_transfer_fee CHECK (fee >= 0);
ALTER TABLE transfers ADD CONSTRAINT chk_transfer_date CHECK (transfer_date >= '1992-08-15');
ALTER TABLE transfers ADD CONSTRAINT chk_different_clubs_transfer CHECK (from_club_id != to_club_id);

-- Contract constraints
ALTER TABLE contracts ADD CONSTRAINT chk_contract_dates CHECK (end_date > start_date);
ALTER TABLE contracts ADD CONSTRAINT chk_shirt_number CHECK (shirt_number >= 1 AND shirt_number <= 99);
ALTER TABLE contracts ADD CONSTRAINT chk_salary CHECK (salary >= 0);

-- Appearance constraints
ALTER TABLE appearances ADD CONSTRAINT chk_minutes CHECK (
    (minute_on IS NULL AND minute_off IS NULL) OR  -- Full match
    (minute_on IS NOT NULL AND minute_off IS NULL) OR  -- Subbed on
    (minute_on IS NULL AND minute_off IS NOT NULL) OR  -- Subbed off
    (minute_on IS NOT NULL AND minute_off IS NOT NULL AND minute_off > minute_on) -- Both
);
ALTER TABLE appearances ADD CONSTRAINT chk_shirt_number_appearance CHECK (shirt_number >= 1 AND shirt_number <= 99);

-- Standings constraints
ALTER TABLE standings ADD CONSTRAINT chk_played_matches CHECK (played >= 0 AND played <= 50);
ALTER TABLE standings ADD CONSTRAINT chk_won_drawn_lost CHECK (won + drawn + lost = played);
ALTER TABLE standings ADD CONSTRAINT chk_goal_difference CHECK (goal_difference = goals_for - goals_against);
ALTER TABLE standings ADD CONSTRAINT chk_points_calculation CHECK (points = (won * 3) + drawn);

-- =====================================================
-- INDEXES (Performance Optimization)
-- =====================================================

-- Primary lookup indexes
CREATE INDEX idx_clubs_name ON clubs(name);
CREATE INDEX idx_clubs_country ON clubs(country);
CREATE INDEX idx_clubs_city ON clubs(city);

CREATE INDEX idx_players_name ON players(name);
CREATE INDEX idx_players_nationality ON players(nationality);
CREATE INDEX idx_players_birth_date ON players(date_of_birth);

CREATE INDEX idx_stadiums_city ON stadiums(city);
CREATE INDEX idx_stadiums_country ON stadiums(country);

-- Match-related indexes
CREATE INDEX idx_matches_date ON matches(match_datetime);
CREATE INDEX idx_matches_home_club ON matches(home_club_id);
CREATE INDEX idx_matches_away_club ON matches(away_club_id);
CREATE INDEX idx_matches_status ON matches(status);
CREATE INDEX idx_matches_competition ON matches(competition_id);
CREATE INDEX idx_matches_season ON matches(season_id);

-- Composite indexes for common queries
CREATE INDEX idx_matches_season_competition ON matches(season_id, competition_id);
CREATE INDEX idx_matches_season_competition_round ON matches(season_id, competition_id, matchday_round);
CREATE INDEX idx_matches_club_season ON matches(season_id, home_club_id, away_club_id);

-- Transfer indexes
CREATE INDEX idx_transfers_date ON transfers(transfer_date);
CREATE INDEX idx_transfers_player ON transfers(player_id);
CREATE INDEX idx_transfers_from_club ON transfers(from_club_id);
CREATE INDEX idx_transfers_to_club ON transfers(to_club_id);
CREATE INDEX idx_transfers_fee ON transfers(fee);

-- Appearance indexes
CREATE INDEX idx_appearances_player ON appearances(player_id);
CREATE INDEX idx_appearances_match ON appearances(match_id);
CREATE INDEX idx_appearances_club ON appearances(club_id);
CREATE INDEX idx_appearances_position ON appearances(position_at_kickoff);

-- Contract indexes
CREATE INDEX idx_contracts_player ON contracts(player_id);
CREATE INDEX idx_contracts_club ON contracts(club_id);
CREATE INDEX idx_contracts_dates ON contracts(start_date, end_date);
CREATE INDEX idx_contracts_active ON contracts(start_date, end_date) WHERE end_date > CURRENT_DATE;

-- Standings indexes
CREATE INDEX idx_standings_season_competition ON standings(season_id, competition_id);
CREATE INDEX idx_standings_points ON standings(season_id, competition_id, points DESC);
CREATE INDEX idx_standings_position ON standings(season_id, competition_id, points DESC, goal_difference DESC);

-- Match events indexes
CREATE INDEX idx_match_events_match ON match_events(match_id);
CREATE INDEX idx_match_events_player ON match_events(player_id);
CREATE INDEX idx_match_events_type ON match_events(type);
CREATE INDEX idx_match_events_minute ON match_events(minute);

-- =====================================================
-- UNIQUE CONSTRAINTS (Data Integrity)
-- =====================================================

-- Ensure unique combinations
ALTER TABLE standings ADD CONSTRAINT uk_standings_season_competition_club
    UNIQUE (season_id, competition_id, club_id);

ALTER TABLE contracts ADD CONSTRAINT uk_contracts_player_club_overlapping
    EXCLUDE USING GIST (
        player_id WITH =,
        daterange(start_date, end_date, '[]') WITH &&
    );

-- Unique shirt numbers per club per season (simplified version)
-- Note: This is a simplified constraint - in reality you'd need more complex logic
ALTER TABLE contracts ADD CONSTRAINT uk_contracts_shirt_number_club_active
    UNIQUE (club_id, shirt_number, start_date, end_date);

-- =====================================================
-- ADDITIONAL REFERENTIAL INTEGRITY
-- =====================================================

-- Ensure match events belong to players who appeared in the match
-- This would be implemented as a trigger in real scenario, showing concept here
-- ALTER TABLE match_events ADD CONSTRAINT chk_player_appeared_in_match ...

-- =====================================================
-- VIEWS (Common Queries)
-- =====================================================

-- Current Premier League table
CREATE VIEW v_current_pl_table AS
SELECT
    ROW_NUMBER() OVER (ORDER BY s.points DESC, s.goal_difference DESC, s.goals_for DESC) as position,
    c.name as club,
    s.played as P,
    s.won as W,
    s.drawn as D,
    s.lost as L,
    s.goals_for as GF,
    s.goals_against as GA,
    s.goal_difference as GD,
    s.points as Pts
FROM standings s
JOIN clubs c ON s.club_id = c.id
JOIN seasons se ON s.season_id = se.id
JOIN competitions co ON s.competition_id = co.id
WHERE se.label = '2024/25'
  AND co.name = 'Premier League'
ORDER BY s.points DESC, s.goal_difference DESC, s.goals_for DESC;

-- Player appearances this season
CREATE VIEW v_player_appearances_current AS
SELECT
    p.name as player_name,
    c.name as club_name,
    COUNT(*) as total_appearances,
    COUNT(CASE WHEN a.is_starter = true THEN 1 END) as starts,
    COUNT(CASE WHEN a.is_starter = false THEN 1 END) as sub_appearances
FROM players p
JOIN appearances a ON p.id = a.player_id
JOIN clubs c ON a.club_id = c.id
JOIN matches m ON a.match_id = m.id
JOIN seasons se ON m.season_id = se.id
WHERE se.label = '2024/25'
GROUP BY p.id, c.id, p.name, c.name
ORDER BY total_appearances DESC;

-- Top scorers view
CREATE VIEW v_top_scorers_current AS
SELECT
    p.name as player_name,
    c.name as club_name,
    COUNT(*) as goals
FROM match_events me
JOIN players p ON me.player_id = p.id
JOIN clubs c ON me.club_id = c.id
JOIN matches m ON me.match_id = m.id
JOIN seasons se ON m.season_id = se.id
WHERE me.type = 'GOAL'
  AND se.label = '2024/25'
  AND me.details != 'own-goal'
GROUP BY p.id, c.id, p.name, c.name
ORDER BY goals DESC
LIMIT 20;

-- Club transfer spending
CREATE VIEW v_club_transfer_spending AS
SELECT
    c.name as club_name,
    se.label as season,
    COUNT(*) as transfers_in,
    COALESCE(SUM(t.fee), 0) as total_spent,
    COALESCE(AVG(t.fee), 0) as avg_fee
FROM clubs c
LEFT JOIN transfers t ON c.id = t.to_club_id
LEFT JOIN matches m ON m.season_id = (SELECT id FROM seasons WHERE label = '2024/25' LIMIT 1)
LEFT JOIN seasons se ON se.id = m.season_id
WHERE t.transfer_date >= se.start_date AND t.transfer_date <= se.end_date
GROUP BY c.id, c.name, se.label
ORDER BY total_spent DESC;