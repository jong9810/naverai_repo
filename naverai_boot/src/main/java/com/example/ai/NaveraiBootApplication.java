package com.example.ai;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

import mymapping.MapController;
import objectdetection.ObjectDetectionController;

@SpringBootApplication
@ComponentScan
@ComponentScan(basePackages={"cfr", "pose", "stt_csr", "tts_voice", "ocr", "chatbot"})
@ComponentScan(basePackageClasses=ObjectDetectionController.class)
@ComponentScan(basePackageClasses=MapController.class)
@MapperScan(basePackages={"chatbot"})
public class NaveraiBootApplication {

	public static void main(String[] args) {
		SpringApplication.run(NaveraiBootApplication.class, args);
	}

}
