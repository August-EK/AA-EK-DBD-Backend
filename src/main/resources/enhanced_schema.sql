-- =====================================================
-- ENHANCED SCHEMA FOR 11 ENTITIES
-- Constraints, Indexes, Views for Assignment 1
-- =====================================================

-- =====================================================
-- BUSINESS LOGIC CONSTRAINTS
-- =====================================================

-- Stadium constraints
ALTER TABLE stadiums ADD CONSTRAINT chk_stadium_capacity CHECK (capacity > 0 AND capacity < 200000);
ALTER TABLE stadiums ADD CONSTRAINT chk_stadium_opened_year CHECK (opened_year > 1800 AND opened_year <= EXTRACT(YEAR FROM CURRENT_DATE));

-- Club constraints
ALTER TABLE clubs ADD CONSTRAINT chk_club_founded_year CHECK (founded_year > 1800 AND founded_year <= EXTRACT(YEAR FROM CURRENT_DATE));

-- Coach constraints
ALTER TABLE coaches ADD CONSTRAINT chk_coach_birth_date CHECK (date_of_birth < CURRENT_DATE);

-- Player constraints
ALTER TABLE players ADD CONSTRAINT chk_player_height CHECK (height_cm > 140 AND height_cm < 220);
ALTER TABLE players ADD CONSTRAINT chk_player_birth_date CHECK (date_of_birth < CURRENT_DATE);

-- Match constraints
ALTER TABLE matches ADD CONSTRAINT chk_match_date CHECK (match_datetime > '1992-08-15'); -- Premier League started
ALTER TABLE matches ADD CONSTRAINT chk_different_clubs CHECK (home_club_id != away_club_id);
ALTER TABLE matches ADD CONSTRAINT chk_match_goals CHECK (
    (home_goals IS NULL AND away_goals IS NULL AND status = 'SCHEDULED') OR
    (home_goals >= 0 AND away_goals >= 0 AND status = 'FINISHED')
);

-- Referee constraints
ALTER TABLE referees ADD CONSTRAINT chk_referee_birth_date CHECK (date_of_birth < CURRENT_DATE);

-- Season constraints
ALTER TABLE seasons ADD CONSTRAINT chk_season_dates CHECK (end_date > start_date);

-- Honour constraints
ALTER TABLE honours ADD CONSTRAINT chk_honour_position CHECK (position > 0 AND position <= 20);

-- =====================================================
-- PERFORMANCE INDEXES
-- =====================================================

-- Stadium indexes
CREATE INDEX idx_stadiums_city ON stadiums(city);
CREATE INDEX idx_stadiums_country ON stadiums(country);
CREATE INDEX idx_stadiums_capacity ON stadiums(capacity);

-- Club indexes
CREATE INDEX idx_clubs_name ON clubs(name);
CREATE INDEX idx_clubs_country ON clubs(country);
CREATE INDEX idx_clubs_city ON clubs(city);
CREATE INDEX idx_clubs_stadium ON clubs(current_stadium_id);

-- Coach indexes
CREATE INDEX idx_coaches_name ON coaches(name);
CREATE INDEX idx_coaches_nationality ON coaches(nationality);
CREATE INDEX idx_coaches_club ON coaches(current_club_id);

-- Player indexes
CREATE INDEX idx_players_name ON players(name);
CREATE INDEX idx_players_nationality ON players(nationality);
CREATE INDEX idx_players_birth_date ON players(date_of_birth);
CREATE INDEX idx_players_club ON players(current_club_id);

-- Player Position indexes
CREATE INDEX idx_player_positions_player ON player_positions(player_id);
CREATE INDEX idx_player_positions_position ON player_positions(position_id);
CREATE INDEX idx_player_positions_primary ON player_positions(is_primary) WHERE is_primary = true;

-- Position indexes
CREATE INDEX idx_positions_code ON positions(code);

-- Competition indexes
CREATE INDEX idx_competitions_name ON competitions(name);
CREATE INDEX idx_competitions_type ON competitions(type);
CREATE INDEX idx_competitions_country ON competitions(country);

-- Season indexes
CREATE INDEX idx_seasons_label ON seasons(label);
CREATE INDEX idx_seasons_dates ON seasons(start_date, end_date);

-- Honour indexes
CREATE INDEX idx_honours_club ON honours(club_id);
CREATE INDEX idx_honours_competition ON honours(competition_id);
CREATE INDEX idx_honours_season ON honours(season_id);
CREATE INDEX idx_honours_position ON honours(position);

-- Referee indexes
CREATE INDEX idx_referees_name ON referees(name);
CREATE INDEX idx_referees_nationality ON referees(nationality);

-- Match indexes
CREATE INDEX idx_matches_date ON matches(match_datetime);
CREATE INDEX idx_matches_home_club ON matches(home_club_id);
CREATE INDEX idx_matches_away_club ON matches(away_club_id);
CREATE INDEX idx_matches_status ON matches(status);
CREATE INDEX idx_matches_competition ON matches(competition_id);
CREATE INDEX idx_matches_season ON matches(season_id);
CREATE INDEX idx_matches_referee ON matches(referee_id);
CREATE INDEX idx_matches_stadium ON matches(stadium_id);

-- Composite indexes for common queries
CREATE INDEX idx_matches_season_competition ON matches(season_id, competition_id);
CREATE INDEX idx_matches_season_round ON matches(season_id, matchday_round);
CREATE INDEX idx_matches_club_season_home ON matches(home_club_id, season_id);
CREATE INDEX idx_matches_club_season_away ON matches(away_club_id, season_id);

-- =====================================================
-- UNIQUE CONSTRAINTS
-- =====================================================

-- Ensure unique combinations
ALTER TABLE honours ADD CONSTRAINT uk_honours_season_competition_club_position
    UNIQUE (season_id, competition_id, club_id, position);

-- =====================================================
-- VIEWS FOR COMMON QUERIES
-- =====================================================

-- View: Current Premier League season fixtures
CREATE OR REPLACE VIEW v_current_pl_fixtures AS
SELECT
    m.id as match_id,
    m.match_datetime,
    m.matchday_round,
    hc.name as home_team,
    ac.name as away_team,
    s.name as stadium,
    r.name as referee,
    m.home_goals,
    m.away_goals,
    m.status
FROM matches m
JOIN clubs hc ON m.home_club_id = hc.id
JOIN clubs ac ON m.away_club_id = ac.id
JOIN stadiums s ON m.stadium_id = s.id
LEFT JOIN referees r ON m.referee_id = r.id
JOIN seasons se ON m.season_id = se.id
JOIN competitions co ON m.competition_id = co.id
WHERE se.label = '2024/25'
  AND co.name = 'Premier League'
ORDER BY m.matchday_round, m.match_datetime;

-- View: Club squad overview
CREATE OR REPLACE VIEW v_club_squads AS
SELECT
    c.name as club_name,
    p.name as player_name,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.date_of_birth)) as age,
    p.nationality,
    pos.name as primary_position,
    p.height_cm,
    p.preferred_foot
FROM clubs c
JOIN players p ON c.id = p.current_club_id
LEFT JOIN player_positions pp ON p.id = pp.player_id AND pp.is_primary = true
LEFT JOIN positions pos ON pp.position_id = pos.id
ORDER BY c.name, pos.name, p.name;

-- View: Match results current season
CREATE OR REPLACE VIEW v_match_results_current AS
SELECT
    m.match_datetime,
    hc.name as home_team,
    m.home_goals,
    ac.name as away_team,
    m.away_goals,
    CASE
        WHEN m.home_goals > m.away_goals THEN hc.name
        WHEN m.away_goals > m.home_goals THEN ac.name
        ELSE 'Draw'
    END as winner
FROM matches m
JOIN clubs hc ON m.home_club_id = hc.id
JOIN clubs ac ON m.away_club_id = ac.id
JOIN seasons se ON m.season_id = se.id
WHERE se.label = '2024/25'
  AND m.status = 'FINISHED'
ORDER BY m.match_datetime DESC;

-- View: Honours by club
CREATE OR REPLACE VIEW v_club_honours AS
SELECT
    c.name as club_name,
    co.name as competition,
    s.label as season,
    h.position,
    h.description
FROM honours h
JOIN clubs c ON h.club_id = c.id
JOIN competitions co ON h.competition_id = co.id
JOIN seasons s ON h.season_id = s.id
ORDER BY c.name, s.start_date DESC, h.position;