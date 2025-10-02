package entity;

import io.quarkus.test.junit.QuarkusTest;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import jakarta.transaction.Transactional;
import static org.junit.jupiter.api.Assertions.*;
import java.util.ArrayList;

@QuarkusTest
public class ClubCompetitionRelationshipTest {

    @BeforeEach
    @Transactional
    public void cleanup() {
        Club.deleteAll();
        Competition.deleteAll();
    }

    @Test
    @Transactional
    public void testClubCompetitionRelationship() {
        // Create competition
        Competition premierLeague = new Competition();
        premierLeague.name = "Premier League";
        premierLeague.type = Competition.CompetitionType.LEAGUE;
        premierLeague.country = "England";
        premierLeague.organizer = "Premier League Ltd";
        premierLeague.clubs = new ArrayList<>();
        premierLeague.persist();

        // Create club
        Club liverpool = new Club();
        liverpool.name = "Liverpool FC";
        liverpool.shortName = "LFC";
        liverpool.country = "England";
        liverpool.city = "Liverpool";
        liverpool.foundedYear = 1892;
        liverpool.competitions = new ArrayList<>();
        liverpool.competitions.add(premierLeague);
        liverpool.persist();

        // IMPORTANT: Set both sides of the bidirectional relationship
        premierLeague.clubs.add(liverpool);
        premierLeague.persist();

        // Verify relationship works
        Club foundClub = Club.findById(liverpool.id);
        assertEquals(1, foundClub.competitions.size());
        assertEquals("Premier League", foundClub.competitions.get(0).name);

        // Verify bidirectional
        Competition foundComp = Competition.findById(premierLeague.id);
        assertNotNull(foundComp.clubs);
        assertEquals(1, foundComp.clubs.size());
        assertEquals("Liverpool FC", foundComp.clubs.get(0).name);
    }
}
