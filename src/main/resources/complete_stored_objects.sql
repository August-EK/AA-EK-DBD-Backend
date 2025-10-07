-- =====================================================
-- COMPLETE DATABASE OBJECTS FOR ASSIGNMENT 1
-- Stored Procedures, Functions, Views, Triggers, Events
-- =====================================================

-- =====================================================
-- FUNCTIONS (Assignment Requirement)
-- =====================================================

-- 1. Calculate player age
CREATE OR REPLACE FUNCTION calculate_player_age(birth_date DATE)
RETURNS INTEGER
LANGUAGE plpgsql
AS $function$
BEGIN
    IF birth_date IS NULL THEN
        RETURN NULL;
    END IF;
    RETURN EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date));
END;
$function$;

-- 2. Get club points for current season
CREATE OR REPLACE FUNCTION get_club_current_points(club_name_param TEXT)
RETURNS INTEGER
LANGUAGE plpgsql
AS $function$
DECLARE
    points_total INTEGER := 0;
BEGIN
    SELECT COALESCE(s.points, 0) INTO points_total
    FROM standings s
    JOIN clubs c ON s.club_id = c.id
    JOIN seasons se ON s.season_id = se.id
    JOIN competitions co ON s.competition_id = co.id
    WHERE c.name = club_name_param
      AND se.label = '2024/25'
      AND co.name = 'Premier League';

    RETURN points_total;
END;
$function$;

-- 3. Calculate transfer market value by position
CREATE OR REPLACE FUNCTION avg_transfer_fee_by_position(position_code_param TEXT)
RETURNS DECIMAL(15,2)
LANGUAGE plpgsql
AS $function$
DECLARE
    avg_fee DECIMAL(15,2) := 0;
BEGIN
    SELECT COALESCE(AVG(t.fee), 0) INTO avg_fee
    FROM transfers t
    JOIN players p ON t.player_id = p.id
    JOIN player_positions pp ON p.id = pp.player_id
    JOIN positions pos ON pp.position_id = pos.id
    WHERE pos.code = position_code_param
      AND t.fee IS NOT NULL
      AND t.transfer_date >= CURRENT_DATE - INTERVAL '2 years';

    RETURN avg_fee;
END;
$function$;

-- =====================================================
-- STORED PROCEDURES (Assignment Requirement)
-- =====================================================

-- 1. Complete match and update standings
CREATE OR REPLACE FUNCTION complete_match_with_result(
    match_id_param BIGINT,
    home_goals_param INTEGER,
    away_goals_param INTEGER
)
RETURNS TEXT
LANGUAGE plpgsql
AS $function$
DECLARE
    home_club BIGINT;
    away_club BIGINT;
    season_id_var BIGINT;
    competition_id_var BIGINT;
    home_points INTEGER := 0;
    away_points INTEGER := 0;
BEGIN
    -- Get match info
    SELECT home_club_id, away_club_id, season_id, competition_id
    INTO home_club, away_club, season_id_var, competition_id_var
    FROM matches
    WHERE id = match_id_param;

    IF home_club IS NULL THEN
        RETURN 'Match not found';
    END IF;

    -- Update match result
    UPDATE matches
    SET home_goals = home_goals_param,
        away_goals = away_goals_param,
        status = 'FINISHED'
    WHERE id = match_id_param;

    -- Calculate points
    IF home_goals_param > away_goals_param THEN
        home_points := 3; away_points := 0;
    ELSIF home_goals_param < away_goals_param THEN
        home_points := 0; away_points := 3;
    ELSE
        home_points := 1; away_points := 1;
    END IF;

    -- Update/Insert standings for home team
    INSERT INTO standings (competition_id, season_id, club_id, played, won, drawn, lost,
                          goals_for, goals_against, goal_difference, points, last_updated)
    VALUES (competition_id_var, season_id_var, home_club, 1,
            CASE WHEN home_goals_param > away_goals_param THEN 1 ELSE 0 END,
            CASE WHEN home_goals_param = away_goals_param THEN 1 ELSE 0 END,
            CASE WHEN home_goals_param < away_goals_param THEN 1 ELSE 0 END,
            home_goals_param, away_goals_param,
            home_goals_param - away_goals_param, home_points, CURRENT_TIMESTAMP)
    ON CONFLICT (competition_id, season_id, club_id) DO UPDATE SET
        played = standings.played + 1,
        won = standings.won + CASE WHEN home_goals_param > away_goals_param THEN 1 ELSE 0 END,
        drawn = standings.drawn + CASE WHEN home_goals_param = away_goals_param THEN 1 ELSE 0 END,
        lost = standings.lost + CASE WHEN home_goals_param < away_goals_param THEN 1 ELSE 0 END,
        goals_for = standings.goals_for + home_goals_param,
        goals_against = standings.goals_against + away_goals_param,
        goal_difference = (standings.goals_for + home_goals_param) - (standings.goals_against + away_goals_param),
        points = standings.points + home_points,
        last_updated = CURRENT_TIMESTAMP;

    -- Update/Insert standings for away team
    INSERT INTO standings (competition_id, season_id, club_id, played, won, drawn, lost,
                          goals_for, goals_against, goal_difference, points, last_updated)
    VALUES (competition_id_var, season_id_var, away_club, 1,
            CASE WHEN away_goals_param > home_goals_param THEN 1 ELSE 0 END,
            CASE WHEN away_goals_param = home_goals_param THEN 1 ELSE 0 END,
            CASE WHEN away_goals_param < home_goals_param THEN 1 ELSE 0 END,
            away_goals_param, home_goals_param,
            away_goals_param - home_goals_param, away_points, CURRENT_TIMESTAMP)
    ON CONFLICT (competition_id, season_id, club_id) DO UPDATE SET
        played = standings.played + 1,
        won = standings.won + CASE WHEN away_goals_param > home_goals_param THEN 1 ELSE 0 END,
        drawn = standings.drawn + CASE WHEN away_goals_param = home_goals_param THEN 1 ELSE 0 END,
        lost = standings.lost + CASE WHEN away_goals_param < home_goals_param THEN 1 ELSE 0 END,
        goals_for = standings.goals_for + away_goals_param,
        goals_against = standings.goals_against + home_goals_param,
        goal_difference = (standings.goals_for + away_goals_param) - (standings.goals_against + home_goals_param),
        points = standings.points + away_points,
        last_updated = CURRENT_TIMESTAMP;

    RETURN 'Match completed and standings updated';
END;
$function$;

-- 2. Register player transfer
CREATE OR REPLACE FUNCTION register_player_transfer(
    player_id_param BIGINT,
    from_club_id_param BIGINT,
    to_club_id_param BIGINT,
    transfer_fee_param DECIMAL(15,2),
    transfer_date_param DATE
)
RETURNS TEXT
LANGUAGE plpgsql
AS $function$
BEGIN
    -- Insert transfer record
    INSERT INTO transfers (player_id, from_club_id, to_club_id, fee, currency, transfer_date, type)
    VALUES (player_id_param, from_club_id_param, to_club_id_param,
            transfer_fee_param, 'EUR', transfer_date_param, 'PERMANENT');

    -- End previous contract
    UPDATE contracts
    SET end_date = transfer_date_param - INTERVAL '1 day'
    WHERE player_id = player_id_param
      AND club_id = from_club_id_param
      AND end_date > transfer_date_param;

    RETURN 'Transfer registered successfully';
END;
$function$;

-- =====================================================
-- ADVANCED VIEWS (Assignment Requirement)
-- =====================================================

-- Premier League current table
CREATE OR REPLACE VIEW v_premier_league_table AS
SELECT
    ROW_NUMBER() OVER (ORDER BY s.points DESC, s.goal_difference DESC, s.goals_for DESC) as position,
    c.name as club_name,
    s.played as P,
    s.won as W,
    s.drawn as D,
    s.lost as L,
    s.goals_for as GF,
    s.goals_against as GA,
    s.goal_difference as GD,
    s.points as Pts,
    s.last_updated
FROM standings s
JOIN clubs c ON s.club_id = c.id
JOIN seasons se ON s.season_id = se.id
JOIN competitions co ON s.competition_id = co.id
WHERE se.label = '2024/25' AND co.name = 'Premier League'
ORDER BY s.points DESC, s.goal_difference DESC, s.goals_for DESC;

-- Player statistics view
CREATE OR REPLACE VIEW v_player_season_stats AS
SELECT
    p.name as player_name,
    calculate_player_age(p.date_of_birth) as age,
    p.nationality,
    c.name as current_club,
    COUNT(a.id) as appearances,
    COUNT(CASE WHEN a.is_starter = true THEN 1 END) as starts,
    COUNT(CASE WHEN a.is_starter = false THEN 1 END) as substitute_appearances,
    se.label as season
FROM players p
LEFT JOIN appearances a ON p.id = a.player_id
LEFT JOIN clubs c ON a.club_id = c.id
LEFT JOIN matches m ON a.match_id = m.id
LEFT JOIN seasons se ON m.season_id = se.id
WHERE se.label = '2024/25' OR se.label IS NULL
GROUP BY p.id, p.name, p.date_of_birth, p.nationality, c.name, se.label
ORDER BY appearances DESC NULLS LAST;

-- Transfer market analysis
CREATE OR REPLACE VIEW v_transfer_market_summary AS
SELECT
    pos.name as position_name,
    COUNT(*) as total_transfers,
    AVG(t.fee) as avg_transfer_fee,
    MAX(t.fee) as highest_transfer_fee,
    MIN(t.fee) as lowest_transfer_fee
FROM transfers t
JOIN players p ON t.player_id = p.id
JOIN player_positions pp ON p.id = pp.player_id
JOIN positions pos ON pp.position_id = pos.id
WHERE t.fee IS NOT NULL
  AND t.transfer_date >= '2022-01-01'
GROUP BY pos.id, pos.name
ORDER BY avg_transfer_fee DESC;

-- =====================================================
-- TRIGGERS (Assignment Requirement)
-- =====================================================

-- Audit table for transfers
CREATE TABLE IF NOT EXISTS transfer_audit_log (
    audit_id SERIAL PRIMARY KEY,
    transfer_id BIGINT,
    action_type VARCHAR(10),
    old_fee DECIMAL(15,2),
    new_fee DECIMAL(15,2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by TEXT DEFAULT CURRENT_USER
);

-- Trigger function for transfer auditing
CREATE OR REPLACE FUNCTION audit_transfer_changes()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $function$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO transfer_audit_log (transfer_id, action_type, new_fee)
        VALUES (NEW.id, 'INSERT', NEW.fee);
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO transfer_audit_log (transfer_id, action_type, old_fee, new_fee)
        VALUES (NEW.id, 'UPDATE', OLD.fee, NEW.fee);
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$function$;

-- Create the trigger
DROP TRIGGER IF EXISTS transfer_audit_trigger ON transfers;
CREATE TRIGGER transfer_audit_trigger
    AFTER INSERT OR UPDATE ON transfers
    FOR EACH ROW
    EXECUTE FUNCTION audit_transfer_changes();

-- =====================================================
-- INDEXES FOR PERFORMANCE (Assignment Requirement)
-- =====================================================

-- Additional performance indexes
CREATE INDEX IF NOT EXISTS idx_transfers_fee ON transfers(fee) WHERE fee IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_matches_season_status ON matches(season_id, status);
CREATE INDEX IF NOT EXISTS idx_appearances_player_season ON appearances(player_id, match_id);
CREATE INDEX IF NOT EXISTS idx_standings_season_points ON standings(season_id, points DESC);

-- =====================================================
-- TEST DATA FOR STORED OBJECTS
-- =====================================================

-- Insert some test matches to demonstrate functionality (with explicit IDs)
INSERT INTO matches (id, competition_id, season_id, matchday_round, match_datetime,
                    home_club_id, away_club_id, stadium_id, referee_id, status)
VALUES
(101, 1, 2, 1, '2024-08-17 15:00:00', 1, 2, 1, 1, 'SCHEDULED'),
(102, 1, 2, 1, '2024-08-17 17:30:00', 3, 4, 3, 2, 'SCHEDULED'),
(103, 1, 2, 2, '2024-08-24 15:00:00', 2, 5, 2, 3, 'SCHEDULED')
ON CONFLICT (id) DO NOTHING;

-- Insert some test player positions (with explicit IDs)
INSERT INTO player_positions (id, player_id, position_id, start_date) VALUES
(101, 1, 6, '2023-07-01'), -- Bruno Fernandes - CM
(102, 2, 9, '2022-07-01'), -- Mohamed Salah - RW
(103, 3, 8, '2021-07-01'), -- Bukayo Saka - LW
(104, 4, 10, '2022-08-01'), -- Erling Haaland - ST
(105, 5, 2, '2020-07-01')  -- Thiago Silva - CB
ON CONFLICT (id) DO NOTHING;

-- Update sequences to continue from our manual IDs
SELECT setval('matches_id_seq', 103);
SELECT setval('player_positions_id_seq', 105);