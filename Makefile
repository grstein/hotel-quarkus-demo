build-vue:
	cd hotel-quarkus && docker build -t vue:0.1 .

build-jvm:
	docker run -v ~/.m2:/opt/quarkus/.m2/ \
	           -ti --rm \
			   -u 1000 \
			   -e MAVEN_CONFIG=/opt/quarkus/.m2/ \
			   -v $(PWD):/project \
			   --entrypoint mvn \
			   quay.io/quarkus/centos-quarkus-maven:19.3.2-java8 \
			   package -Dmaven.repo.local=/opt/quarkus/.m2 -DskipTests
	docker build -f src/main/docker/Dockerfile.jvm -t quarkus-jvm:0.1 .

build-native:
	docker run -v ~/.m2:/opt/quarkus/.m2/ \
	           -ti --rm \
			   -u 1000 \
			   -e MAVEN_CONFIG=/opt/quarkus/.m2/ \
			   -v $(PWD):/project \
			   --entrypoint mvn \
			   quay.io/quarkus/centos-quarkus-maven:19.3.2-java11 \
			   package -Dmaven.repo.local=/opt/quarkus/.m2 -DskipTests -DskipITs -Dmaven.test.skip=true -Dnative 
	docker build -f src/main/docker/Dockerfile.native -t quarkus-native:0.1 .

clean:
	docker run -v ~/.m2:/opt/quarkus/.m2/ \
	           -ti --rm \
			   -u 1000 \
			   -e MAVEN_CONFIG=/opt/quarkus/.m2/ \
			   -v $(PWD):/project \
			   --entrypoint mvn \
			   quay.io/quarkus/centos-quarkus-maven:19.3.2-java11 \
			   clean -Dmaven.repo.local=/opt/quarkus/.m2