import com.github.jengelman.gradle.plugins.shadow.tasks.ShadowJar

plugins {
	java
	id("com.github.johnrengelman.shadow") version "8.1.1" // Shadowプラグイン
	id("org.springframework.boot") version "3.5.0"
	id("io.spring.dependency-management") version "1.1.7"
}

group = "com.example"
version = "0.0.1-SNAPSHOT"

java {
	toolchain {
		languageVersion.set(JavaLanguageVersion.of(21))
	}
}

repositories {
	mavenCentral()
}

dependencies {
	implementation("org.springframework.boot:spring-boot-starter-web")
	// AWS Lambda用
	implementation("com.amazonaws:aws-lambda-java-core:1.2.3")
	implementation("com.amazonaws:aws-lambda-java-events:3.11.3")

	testImplementation("org.springframework.boot:spring-boot-starter-test")
	testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

springBoot {
	mainClass.set("com.example.demo.DemoApplication")
}

tasks.test {
    useJUnitPlatform()
}

// Shadowプラグインを使って、fat jarを作成（Lambdaテスト）
tasks.withType<ShadowJar> {
    archiveBaseName.set("lambda-java-demo")
    archiveVersion.set(project.version.toString())
    archiveClassifier.set("")
    manifest {
        attributes["Main-Class"] = "com.example.demo.LambdaHandler"
    }
}

// AWS Lambdaテスト用、shadowJar + zipTree方式
tasks.register<Zip>("lambdaZip") {
    dependsOn(tasks.named("shadowJar"))
    from({
        tasks.named<ShadowJar>("shadowJar").get().archiveFile.get().asFile.let { zipTree(it) }
    })
    archiveFileName.set("lambda.zip")
    destinationDirectory.set(layout.buildDirectory.dir("distributions"))
}
