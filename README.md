# java-2-cloudrun

## Build the sample JBoss war file

```bash
git clone https://github.com/aeimer/java-example-helloworld-war.git temp_war_src 
mkdir -p war_contents/WEB-INF 
cp temp_war_src/index.jsp war_contents/ 
cp temp_war_src/WEB-INF/web.xml war_contents/WEB-INF/ 
cd war_contents 
jar -cvf ../helloworld.war .
rm -rf temp_war_src war_contents
```
## Wrap the war file into a container and deploy to Google Cloud Run

Authenticate with Google Cloud

```bash
gcloud auth login
gcloud config set project [PROJECT_ID]
```

Build the Docker image

```bash
docker build -t gcr.io/[PROJECT_ID]/[IMAGE_NAME]:latest .
```

Push the image to Google Container Registry

```bash
docker push gcr.io/[PROJECT_ID]/[IMAGE_NAME]:latest
```

Deploy to Google Cloud Run

```bash
gcloud run deploy [SERVICE_NAME] \
  --image gcr.io/[PROJECT_ID]/[IMAGE_NAME]:latest \
  --platform managed \
  --region [REGION] \
  --allow-unauthenticated \
  --port 8080
```

e.g.

```bash
docker build -t gcr.io/addo-argolis-demo/jboss-helloworld:latest .
docker push gcr.io/addo-argolis-demo/jboss-helloworld:latest
gcloud run deploy jboss-helloworld \
  --image gcr.io/addo-argolis-demo/jboss-helloworld:latest \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --port 8080
```

## Validate helloworld.war using podman

```bash
podman run --name hello-wildfly -d -p 8081:8080 -v $(pwd)/helloworld.war:/opt/jboss/wildfly/standalone/deployments/helloworld.war:Z quay.io/wildfly/wildfly:latest

curl http://localhost:8081/helloworld/

podman logs hello-wildfly
podman stop hello-wildfly
podman rm -f hello-wildfly
```

## Notes

1. Install Docker if needed

```bash
sudo yum install -y docker
sudo systemctl start docker || sudo systemctl start podman
```

1. Authenticate Docker is needed

```bash
gcloud auth configure-docker
```

1. If Cloud Run service requires for authentication, manually remove the Security requirement for "Use IAM to authenticate incoming requests"