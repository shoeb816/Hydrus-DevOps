# Hydrus-DevOps
Task Contents & Description Task:

**Docker:**

Dockerfile is using php-apache:7 as a base images for image creation.
Built image: docker build . -t shoeb:v1 
Tag Image: docker tag shoeb:v1 faizul56/shoeb:v1
Push Image: docker push faizul56/shoeb:v1

**Kubernetes:**

kubectl create deploy hydrus-dev-pod --image=faizul56/shoeb:v1 --port=80 $do > hydrus-dev-pod-deployment.yaml
k expose deploy hydrus-dev-pod --name hydrus-dev-pod-svc --type=NodePort --port=30035 $do > hydrus-dev-pod-svc

Modify with necessary requiremets and combine Two file under **hydrus_app.yaml**


**Terraform:**
1. Run in Terminal. And also you can configure in terraform file.
$ export AWS_ACCESS_KEY_ID=AK************IEVXQ
$ export AWS_SECRET_ACCESS_KEY=gbaIbK*********************iwN0dGfS
2. Create a Directory and write down the following file and save it as main.tf
3. Execute the command **terraform init** to initialize.
4. Execute the command **terraform plan** to check what change would be made.
5. Then execute **terraform apply** to commit and start the build if everythings seems fine.


N.B.: aws-cli/2.7.2, Python/3.9.11, Terraform v1.2.0, Docker version 20.10.13, kubernet v1.21.2.

