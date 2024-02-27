FROM openjdk: 8
ADD target/demo-workshop-2.1.2.jar my-jar.jar
ENTRYPOINT ["java", "-jar", "my-jar.jar"]