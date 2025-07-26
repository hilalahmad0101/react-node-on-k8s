# Step 1: Build image
docker build -t my-app:latest .

# Step 2: Tag for GitLab registry
docker tag my-app:latest registry.gitlab.com/username/project-name/my-app:latest

# Step 3: Login
docker login registry.gitlab.com

# Step 4: Push image
docker push registry.gitlab.com/username/project-name/my-app:latest