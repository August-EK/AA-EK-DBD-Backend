-- =====================================================
-- COMPLETE STORED OBJECTS FOR ASSIGNMENT 1
-- Functions, Procedures, Triggers, Audit
-- Only for the 11 implemented entities
-- =====================================================

-- =====================================================
-- FUNCTIONS (Assignment Requirement)
-- =====================================================

-- Function 1: Calculate player age from birth date
CREATE OR REPLACE FUNCTION calculate_player_age(birth_date DATE)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF birth_date IS NULL THEN
        RETURN NULL;
    END IF;
    RETURN EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date));
END;
$$;

-- Function 2: Get total goals scored by a club in current season
CREATE OR REPLACE FUNCTION get_club_goals_current_season(club_name_param TEXT)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    total_goals INTEGER := 0;
    home_goals INTEGER := 0;
    away_goals INTEGER := 0;
BEGIN
    -- Goals scored at home
    SELECT COALESCE(SUM(m.home_goals), 0) INTO home_goals
    FROM matches m
    JOIN clubs c ON m.home_club_id = c.id
    JOIN seasons s ON m.season_id = s.id
    WHERE c.name = club_name_param
      AND s.label = '2024/25'
      AND m.status = 'FINISHED';

    -- Goals scored away
    SELECT COALESCE(SUM(m.away_goals), 0) INTO away_goals
    FROM matches m
    JOIN clubs c ON m.away_club_id = c.id
    JOIN seasons s ON m.season_id = s.id
    WHERE c.name = club_name_param
      AND s.label = '2024/25'
      AND m.status = 'FINISHED';

    total_goals := home_goals + away_goals;
    RETURN total_goals;
END;
$$;

-- Function 3: Calculate win percentage for a club
CREATE OR REPLACE FUNCTION calculate_club_win_percentage(club_id_param BIGINT)
RETURNS DECIMAL(5,2)
LANGUAGE plpgsql
AS $$
DECLARE
    total_matches INTEGER := 0;
    wins INTEGER := 0;
    win_pct DECIMAL(5,2) := 0.00;
BEGIN
    -- Count total finished matches
    SELECT COUNT(*) INTO total_matches
    FROM matches m
    WHERE (m.home_club_id = club_id_param OR m.away_club_id = club_id_param)
      AND m.status = 'FINISHED';

    IF total_matches = 0 THEN
        RETURN 0.00;
    END IF;

    -- Count wins
    SELECT COUNT(*) INTO wins
    FROM matches m
    WHERE ((m.home_club_id = club_id_param AND m.home_goals > m.away_goals)
        OR (m.away_club_id = club_id_param AND m.away_goals > m.home_goals))
      AND m.status = 'FINISHED';

    win_pct := (wins::DECIMAL / total_matches::DECIMAL) * 100;
    RETURN ROUND(win_pct, 2);
END;
$$;

-- =====================================================
-- STORED PROCEDURES (Assignment Requirement)
-- =====================================================

-- Procedure 1: Complete a match and update result
CREATE OR REPLACE FUNCTION complete_match(
    match_id_param BIGINT,
    home_goals_param INTEGER,
    away_goals_param INTEGER
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    match_exists BOOLEAN;
BEGIN
    -- Check if match exists and is scheduled
    SELECT EXISTS(
        SELECT 1 FROM matches
        WHERE id = match_id_param
        AND status = 'SCHEDULED'
    ) INTO match_exists;

    IF NOT match_exists THEN
        RETURN 'Error: Match not found or already completed';
    END IF;

    -- Validate goals
    IF home_goals_param < 0 OR away_goals_param < 0 THEN
        RETURN 'Error: Goals cannot be negative';
    END IF;

    -- Update match with result
    UPDATE matches
    SET home_goals = home_goals_param,
        away_goals = away_goals_param,
        status = 'FINISHED'
    WHERE id = match_id_param;

    RETURN FORMAT('Match completed successfully: %s-%s', home_goals_param, away_goals_param);
END;
$$;

-- Procedure 2: Transfer player to new club
CREATE OR REPLACE FUNCTION transfer_player(
    player_id_param BIGINT,
    new_club_id_param BIGINT
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    player_name TEXT;
    old_club_name TEXT;
    new_club_name TEXT;
BEGIN
    -- Get player and old club info
    SELECT p.name, c.name INTO player_name, old_club_name
    FROM players p
    LEFT JOIN clubs c ON p.current_club_id = c.id
    WHERE p.id = player_id_param;

    IF player_name IS NULL THEN
        RETURN 'Error: Player not found';
    END IF;

    -- Get new club name
    SELECT name INTO new_club_name
    FROM clubs
    WHERE id = new_club_id_param;

    IF new_club_name IS NULL THEN
        RETURN 'Error: New club not found';
    END IF;

    -- Update player's current club
    UPDATE players
    SET current_club_id = new_club_id_param
    WHERE id = player_id_param;

    RETURN FORMAT('Transfer completed: %s moved from %s to %s',
                  player_name,
                  COALESCE(old_club_name, 'Free Agent'),
                  new_club_name);
END;
$$;

-- Procedure 3: Schedule a new match
CREATE OR REPLACE FUNCTION schedule_match(
    competition_id_param BIGINT,
    season_id_param BIGINT,
    matchday_round_param INTEGER,
    match_datetime_param TIMESTAMP,
    home_club_id_param BIGINT,
    away_club_id_param BIGINT,
    stadium_id_param BIGINT,
    referee_id_param BIGINT
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    new_match_id BIGINT;
BEGIN
    -- Validate clubs are different
    IF home_club_id_param = away_club_id_param THEN
        RETURN 'Error: Home and away clubs must be different';
    END IF;

    -- Insert new match
    INSERT INTO matches (
        competition_id, season_id, matchday_round, match_datetime,
        home_club_id, away_club_id, stadium_id, referee_id, status
    ) VALUES (
        competition_id_param, season_id_param, matchday_round_param, match_datetime_param,
        home_club_id_param, away_club_id_param, stadium_id_param, referee_id_param, 'SCHEDULED'
    ) RETURNING id INTO new_match_id;

    RETURN FORMAT('Match scheduled successfully with ID: %s', new_match_id);
END;
$$;

-- =====================================================
-- TRIGGERS & AUDIT (Assignment Requirement)
-- =====================================================

-- Audit table for player transfers
CREATE TABLE IF NOT EXISTS player_transfer_audit (
    audit_id SERIAL PRIMARY KEY,
    player_id BIGINT NOT NULL,
    player_name TEXT,
    old_club_id BIGINT,
    old_club_name TEXT,
    new_club_id BIGINT,
    new_club_name TEXT,
    transfer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by TEXT DEFAULT CURRENT_USER
);

-- Trigger function for player transfer auditing
CREATE OR REPLACE FUNCTION audit_player_transfer()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    old_club TEXT;
    new_club TEXT;
BEGIN
    -- Only audit if club actually changed
    IF OLD.current_club_id IS DISTINCT FROM NEW.current_club_id THEN
        -- Get old club name
        SELECT name INTO old_club
        FROM clubs
        WHERE id = OLD.current_club_id;

        -- Get new club name
        SELECT name INTO new_club
        FROM clubs
        WHERE id = NEW.current_club_id;

        -- Insert audit record
        INSERT INTO player_transfer_audit (
            player_id, player_name,
            old_club_id, old_club_name,
            new_club_id, new_club_name
        ) VALUES (
            NEW.id, NEW.name,
            OLD.current_club_id, old_club,
            NEW.current_club_id, new_club
        );
    END IF;

    RETURN NEW;
END;
$$;

-- Create the trigger on players table
DROP TRIGGER IF EXISTS player_transfer_audit_trigger ON players;
CREATE TRIGGER player_transfer_audit_trigger
    AFTER UPDATE ON players
    FOR EACH ROW
    EXECUTE FUNCTION audit_player_transfer();

-- Audit table for match results
CREATE TABLE IF NOT EXISTS match_result_audit (
    audit_id SERIAL PRIMARY KEY,
    match_id BIGINT NOT NULL,
    home_club TEXT,
    away_club TEXT,
    final_score TEXT,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_by TEXT DEFAULT CURRENT_USER
);

-- Trigger function for match result auditing
CREATE OR REPLACE FUNCTION audit_match_result()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    home_club TEXT;
    away_club TEXT;
BEGIN
    -- Only audit when match is completed
    IF NEW.status = 'FINISHED' AND OLD.status = 'SCHEDULED' THEN
        -- Get club names
        SELECT c1.name, c2.name INTO home_club, away_club
        FROM clubs c1, clubs c2
        WHERE c1.id = NEW.home_club_id
        AND c2.id = NEW.away_club_id;

        -- Insert audit record
        INSERT INTO match_result_audit (
            match_id, home_club, away_club, final_score
        ) VALUES (
            NEW.id,
            home_club,
            away_club,
            FORMAT('%s - %s', NEW.home_goals, NEW.away_goals)
        );
    END IF;

    RETURN NEW;
END;
$$;

-- Create the trigger on matches table
DROP TRIGGER IF EXISTS match_result_audit_trigger ON matches;
CREATE TRIGGER match_result_audit_trigger
    AFTER UPDATE ON matches
    FOR EACH ROW
    EXECUTE FUNCTION audit_match_result();

-- =====================================================
-- TEST QUERIES FOR STORED OBJECTS
-- =====================================================

-- Test Function 1: Calculate player ages
-- SELECT name, date_of_birth, calculate_player_age(date_of_birth) as age FROM players ORDER BY age DESC;

-- Test Function 2: Get club goals
-- SELECT get_club_goals_current_season('Manchester City') as total_goals;

-- Test Function 3: Win percentage
-- SELECT c.name, calculate_club_win_percentage(c.id) as win_percentage FROM clubs c ORDER BY win_percentage DESC;

-- Test Procedure 1: Complete a match
-- SELECT complete_match(11, 2, 1);

-- Test Procedure 2: Transfer player
-- SELECT transfer_player(1, 3);  -- Transfer Bruno Fernandes to Liverpool

-- Test Procedure 3: Schedule new match
-- SELECT schedule_match(1, 3, 4, '2024-09-14 15:00:00', 1, 5, 1, 1);

-- View audit logs
-- SELECT * FROM player_transfer_audit ORDER BY transfer_date DESC;
-- SELECT * FROM match_result_audit ORDER BY completed_at DESC;