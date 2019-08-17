package com.mycompany.myapp;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication

public class SpringBootRestApiApplication {

	private static final Logger logger = LoggerFactory.getLogger(SpringBootRestApiApplication.class);
	
    public static void main(String[] args) {
        SpringApplication.run(SpringBootRestApiApplication.class, args);
        
        logger.debug("Logging from demo app");
        logger.debug("Logging from demo app");
        logger.debug("Logging from demo app");
    }
}
