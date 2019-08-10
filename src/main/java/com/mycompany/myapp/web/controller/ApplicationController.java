package com.mycompany.myapp.web.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;



@RestController
@RequestMapping("/api")
@Slf4j
public class ApplicationController {
	
	@Value("${spring.application.version}")
	private String version;
	

	@GetMapping(value = "/version")
	@ApiOperation(value = "Show API application", notes = "Notes on displaying application version")
	public String showVersion() {

		return version;
	}


}
