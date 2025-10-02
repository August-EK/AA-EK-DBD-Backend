package service;

import entity.Club;
import repository.ClubRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import java.util.List;

@ApplicationScoped
public class ClubService {

    @Inject
    ClubRepository clubRepository;

    public List<Club> getAllClubs() {
        return clubRepository.listAll();
    }

    public Club getClubById(Long id) {
        return clubRepository.findById(id);
    }

    public List<Club> getClubsByCountry(String country) {
        return clubRepository.findByCountry(country);
    }

    public Club getClubByName(String name) {
        return clubRepository.findByName(name);
    }

    public List<Club> searchClubs(String searchTerm) {
        return clubRepository.searchByNameContaining(searchTerm);
    }

    @Transactional
    public Club createClub(Club club) {
        clubRepository.persist(club);
        return club;
    }

    @Transactional
    public Club updateClub(Long id, Club updatedClub) {
        Club club = clubRepository.findById(id);
        if (club != null) {
            club.name = updatedClub.name;
            club.shortName = updatedClub.shortName;
            club.country = updatedClub.country;
            club.city = updatedClub.city;
            club.foundedYear = updatedClub.foundedYear;
            club.currentStadium = updatedClub.currentStadium;
        }
        return club;
    }

    @Transactional
    public boolean deleteClub(Long id) {
        return clubRepository.deleteById(id);
    }
}