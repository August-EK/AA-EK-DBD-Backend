package resource;

import entity.Club;
import service.ClubService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;

@Path("/api/mysql/clubs")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ClubResource {

    @Inject
    ClubService clubService;

    @GET
    public List<Club> getAllClubs() {
        return clubService.getAllClubs();
    }

    @GET
    @Path("/{id}")
    public Response getClubById(@PathParam("id") Long id) {
        Club club = clubService.getClubById(id);
        if (club == null) {
            return Response.status(Response.Status.NOT_FOUND).build();
        }
        return Response.ok(club).build();
    }

    @GET
    @Path("/country/{country}")
    public List<Club> getClubsByCountry(@PathParam("country") String country) {
        return clubService.getClubsByCountry(country);
    }

    @GET
    @Path("/search")
    public List<Club> searchClubs(@QueryParam("q") String searchTerm) {
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            return clubService.getAllClubs();
        }
        return clubService.searchClubs(searchTerm);
    }

    @POST
    public Response createClub(Club club) {
        try {
            Club createdClub = clubService.createClub(club);
            return Response.status(Response.Status.CREATED).entity(createdClub).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("Error creating club: " + e.getMessage()).build();
        }
    }

    @PUT
    @Path("/{id}")
    public Response updateClub(@PathParam("id") Long id, Club club) {
        try {
            Club updatedClub = clubService.updateClub(id, club);
            if (updatedClub == null) {
                return Response.status(Response.Status.NOT_FOUND).build();
            }
            return Response.ok(updatedClub).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("Error updating club: " + e.getMessage()).build();
        }
    }

    @DELETE
    @Path("/{id}")
    public Response deleteClub(@PathParam("id") Long id) {
        boolean deleted = clubService.deleteClub(id);
        if (!deleted) {
            return Response.status(Response.Status.NOT_FOUND).build();
        }
        return Response.noContent().build();
    }
    // Add this method to your ClubResource.java

    @GET
    @Path("/test")
    public Response testDatabase() {
        try {
            long count = Club.count();
            return Response.ok("Database connection OK. Club count: " + count).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Database error: " + e.getMessage()).build();
        }
    }
}