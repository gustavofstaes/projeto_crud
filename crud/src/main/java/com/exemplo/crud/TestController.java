package com.exemplo.crud;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestController {

    @GetMapping("/")
    public String hello() {
        return "🚀 Spring Boot com MySQL está rodando com sucesso!";
    }
}

