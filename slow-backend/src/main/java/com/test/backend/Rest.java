package com.test.backend;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

import org.jboss.logging.Logger;

import io.smallrye.common.annotation.Blocking;
import io.smallrye.mutiny.Uni;

import java.util.concurrent.*;

@Path("/{a:vertx|ahc|netty}")
public class Rest {
    private static final Logger LOG = Logger.getLogger(Rest.class);
    private static ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
    private static int DELAY = 2000;

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public Uni<String> hello(String a) throws InterruptedException {

        LOG.info("Sleeping for %s ms".formatted(DELAY));
        
        Uni<String> uni = Uni.createFrom().emitter(em -> {
            scheduler.schedule(new Runnable() {
                @Override
                public void run() {
                    LOG.info("I woke up!");
                    em.complete("Hello from %s".formatted(a));
                }
            }, DELAY, TimeUnit.MILLISECONDS);
        });
        LOG.info("Returning Uni");
        return uni;
    }

    //@GET
    //@Produces(MediaType.TEXT_PLAIN)
    public String hello2(String a) throws InterruptedException {
        LOG.info("Sleeping for %s ms".formatted(DELAY));
        Thread.sleep(DELAY);
        return "Hello from %s\n".formatted(a);
    }
}
