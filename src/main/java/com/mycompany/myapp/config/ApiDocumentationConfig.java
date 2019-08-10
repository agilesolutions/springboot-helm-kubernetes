package com.mycompany.myapp.config;

import io.swagger.annotations.Contact;
import io.swagger.annotations.ExternalDocs;
import io.swagger.annotations.Info;
import io.swagger.annotations.License;
import io.swagger.annotations.SwaggerDefinition;

@SwaggerDefinition(
        info = @Info(
                description = "demo",
                version = "V1.0",
                title = "Certificate Revocation API",
                contact = @Contact(
                   name = "Robert Rong", 
                   email = "robert.rong@agilesolutions.com", 
                   url = "https://www.agilesolutions.com"
                ),
                license = @License(
                   name = "Apache 2.0", 
                   url = "http://www.agilesolutions.com/licenses/LICENSE-2.0"
                )
        ),
        consumes = {"application/json", "application/xml"},
        produces = {"application/json", "application/xml"},
        schemes = {SwaggerDefinition.Scheme.HTTP, SwaggerDefinition.Scheme.HTTPS},
        externalDocs = @ExternalDocs(value = "Read This For Sure", url = "http://projects.spring.io/spring-cloud/")
)
public interface ApiDocumentationConfig {

}