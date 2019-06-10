package org.acme.hibernate.orm.panache;

import io.quarkus.hibernate.orm.panache.PanacheQuery;
import org.jboss.resteasy.annotations.jaxrs.PathParam;

import javax.enterprise.context.ApplicationScoped;
import javax.ws.rs.*;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Path("bookings")
@ApplicationScoped
@Produces("application/json")
@Consumes("application/json")
public class BookingResource {
    @GET
    @Path("hotel/{id}")
    public List<Booking> allForHotel(@PathParam Long id) {
        if (id == null) {
            throw new WebApplicationException("hotelId must be specified", 422);
        }
        Stream<Booking> bookings = Booking.stream("hotel_id", id);
        return bookings
                .map(Booking::clearCreditCard)
                .collect(Collectors.toList());
    }

    @GET
    @Path("counterForHotel/{hotelId}")
    public Long counterForHotel(@PathParam String hotelId) {
        if (hotelId == null) {
            throw new WebApplicationException("hotelId must be specified", 422);
        }
        return Booking.count("hotelid",hotelId);
    }


    @GET
    @Path("ref/{bookingRef}")
    public Booking findByReference(@PathParam UUID bookingRef) {
        PanacheQuery<Booking> query = Booking.find("bookingRef = ?1", bookingRef);
        if (query.count() == 0) {
            throw new WebApplicationException("No booking for this reference", 404);
        }
        return query.firstResult();
    }
}
