sonar-scanner \
   -Dsonar.projectKey=documentationf       \
   -Dsonar.sources=./src \
   -Dsonar.host.url=http://localhost:9000 \
   -Dsonar.login=admin \
   -Dsonar.password=sonar

   docker push bilelabbass/repos_fromation:production
