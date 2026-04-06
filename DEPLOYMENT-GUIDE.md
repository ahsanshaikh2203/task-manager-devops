# 🚀 DevOps Cloud Deployment Pipeline - Complete Guide

## Student Information
**Course**: CSC418 - DevOps  
**Project**: Cloud Computing Deployment Pipeline  
**Application**: Task Manager (Full Stack)

---

## 📊 Project Summary

### Application Stack
- **Frontend**: HTML5, CSS3, Vanilla JavaScript
- **Backend**: Node.js + Express.js
- **Database**: MongoDB
- **Container**: Docker
- **Cloud Platform**: Azure Kubernetes Service (AKS)
- **Repository**: GitHub
- **Registry**: Docker Hub

---

## PART 1: LOCAL DEVELOPMENT & TESTING (10 Marks)

### Step 1: Setup Application Locally (2 Marks)

#### 1.1 Navigate to project directory
```bash
cd "d:\University\Semester_6\DevOps\Lab exam\task-manager-app"
```

#### 1.2 Install dependencies
```bash
cd backend
npm install
```

#### 1.3 Test locally (Optional - requires MongoDB)
If you have MongoDB installed locally:
```bash
# Set environment variable
set MONGO_URI=mongodb://localhost:27017/taskmanager

# Start server
npm start
```

**Expected Output**:
```
🚀 Server running on port 3000
✅ MongoDB Connected Successfully
```

#### 1.4 Verify in browser
- Open: http://localhost:3000
- You should see the Task Manager interface

---

### Step 2: Create Dockerfile (3 Marks)

**✅ Already Created**: `Dockerfile`

**Dockerfile Explanation**:
```dockerfile
FROM node:18-alpine          # Base image (lightweight)
WORKDIR /app                 # Set working directory
COPY backend/package.json ./ # Copy dependencies file
RUN npm install --production # Install production dependencies
COPY backend/ ./backend/     # Copy backend code
COPY frontend/ ./frontend/   # Copy frontend code
EXPOSE 3000                  # Expose application port
CMD ["node", "server.js"]    # Start command
```

---

### Step 3: Build & Run Docker Container (3 Marks)

#### 3.1 Build Docker Image
```bash
# Navigate to project root
cd "d:\University\Semester_6\DevOps\Lab exam\task-manager-app"

# Build image
docker build -t task-manager:latest .
```

**Expected Output**:
```
Successfully built <image-id>
Successfully tagged task-manager:latest
```

#### 3.2 Verify Image
```bash
docker images
```

You should see `task-manager` in the list.

#### 3.3 Run with Docker Compose (Recommended)
```bash
# Start all services (app + MongoDB)
docker-compose up -d
```

**Verify Running Containers**:
```bash
docker ps
```

You should see 2 containers:
- `taskmanager-app`
- `taskmanager-mongodb`

#### 3.4 Test Application
- Open browser: http://localhost:3000
- Try adding a task
- Mark it complete
- Delete it

#### 3.5 Check Health
```bash
# In browser
http://localhost:3000/health

# Or using curl
curl http://localhost:3000/health
```

**Expected Response**:
```json
{
  "status": "healthy",
  "mongodb": "connected",
  "timestamp": "2026-04-06T15:56:58.113Z"
}
```

#### 3.6 View Logs
```bash
# View app logs
docker logs taskmanager-app

# View MongoDB logs
docker logs taskmanager-mongodb
```

📸 **SCREENSHOT 1**: Take screenshot of `docker ps` showing running containers  
📸 **SCREENSHOT 2**: Take screenshot of application running in browser

---

### Step 4: Push to Docker Hub (2 Marks)

#### 4.1 Login to Docker Hub
```bash
docker login
```

Enter your Docker Hub username and password.

#### 4.2 Tag the Image
```bash
# Replace YOUR_USERNAME with your Docker Hub username
docker tag task-manager:latest YOUR_USERNAME/task-manager:latest
```

**Example**:
```bash
docker tag task-manager:latest johndoe/task-manager:latest
```

#### 4.3 Push to Docker Hub
```bash
docker push YOUR_USERNAME/task-manager:latest
```

**Expected Output**:
```
The push refers to repository [docker.io/YOUR_USERNAME/task-manager]
latest: digest: sha256:xxx size: xxx
```

#### 4.4 Verify on Docker Hub
- Go to: https://hub.docker.com
- Login
- Check your repositories
- You should see `task-manager`

📸 **SCREENSHOT 3**: Take screenshot of Docker Hub repository page

**🔗 Note the Docker Hub Link**:
```
https://hub.docker.com/r/YOUR_USERNAME/task-manager
```

---

## PART 2: AZURE KUBERNETES DEPLOYMENT (10 Marks)

### Step 1: Create Azure Kubernetes Cluster (3 Marks)

#### 1.1 Login to Azure Portal
- Go to: https://portal.azure.com
- Login with your Azure account

#### 1.2 Create AKS Cluster
1. Click **"Create a resource"**
2. Search for **"Kubernetes Service"**
3. Click **"Create"**

#### 1.3 Configure Basic Settings
- **Subscription**: Your subscription
- **Resource Group**: Create new → `devops-lab-rg`
- **Cluster name**: `taskmanager-aks`
- **Region**: Choose nearest (e.g., East US)
- **Kubernetes version**: Latest stable
- **Node size**: Standard_B2s (cost-effective)
- **Node count**: 2

#### 1.4 Review + Create
- Click **"Review + create"**
- Click **"Create"**
- Wait 5-10 minutes for deployment

📸 **SCREENSHOT 4**: Take screenshot of AKS cluster creation page

---

### Step 2: Connect to AKS Cluster

#### 2.1 Install Azure CLI (if not installed)
```bash
# Download from: https://aka.ms/installazurecliwindows
```

#### 2.2 Login to Azure
```bash
az login
```

#### 2.3 Get Cluster Credentials
```bash
az aks get-credentials --resource-group devops-lab-rg --name taskmanager-aks
```

#### 2.4 Verify Connection
```bash
kubectl get nodes
```

**Expected Output**:
```
NAME                       STATUS   ROLES   AGE   VERSION
aks-nodepool1-xxxxx-0     Ready    agent   5m    v1.28.x
aks-nodepool1-xxxxx-1     Ready    agent   5m    v1.28.x
```

📸 **SCREENSHOT 5**: Take screenshot of `kubectl get nodes` output

---

### Step 3: Deploy Application to AKS (4 Marks)

#### 3.1 Update Kubernetes Manifest
Edit `k8s/deployment.yaml` and replace:
```yaml
image: YOUR_DOCKERHUB_USERNAME/task-manager:latest
```

With your actual Docker Hub username:
```yaml
image: johndoe/task-manager:latest
```

#### 3.2 Deploy to AKS
```bash
# Navigate to project directory
cd "d:\University\Semester_6\DevOps\Lab exam\task-manager-app"

# Apply deployment
kubectl apply -f k8s/deployment.yaml
```

**Expected Output**:
```
deployment.apps/mongodb created
service/mongodb created
deployment.apps/taskmanager-app created
service/taskmanager-service created
```

#### 3.3 Check Deployment Status
```bash
# Check pods
kubectl get pods

# Check services
kubectl get services

# Check deployments
kubectl get deployments
```

Wait until all pods show `STATUS: Running`

📸 **SCREENSHOT 6**: Take screenshot of `kubectl get pods` showing Running status

---

### Step 4: Expose Application with Public IP (3 Marks)

#### 4.1 Get External IP
```bash
kubectl get service taskmanager-service
```

**Initial Output** (wait for External-IP):
```
NAME                   TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)
taskmanager-service   LoadBalancer   10.0.x.x       <pending>     80:xxxxx/TCP
```

Wait 2-5 minutes, then run again:
```bash
kubectl get service taskmanager-service
```

**After External IP is assigned**:
```
NAME                   TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)
taskmanager-service   LoadBalancer   10.0.x.x       20.xxx.xxx.xxx   80:xxxxx/TCP
```

#### 4.2 Access Application
Copy the EXTERNAL-IP and open in browser:
```
http://20.xxx.xxx.xxx
```

You should see your Task Manager application!

#### 4.3 Test the Application
- Add multiple tasks
- Mark some as complete
- Delete tasks
- Verify data persists

📸 **SCREENSHOT 7**: Take screenshot of application running on Azure public IP

**🔗 Note the Azure Public URL**:
```
http://YOUR_EXTERNAL_IP
```

---

### Step 5: Verify Deployment

#### 5.1 Check All Resources
```bash
# List all resources
kubectl get all

# Check pod details
kubectl describe pod <pod-name>

# View logs
kubectl logs <pod-name>
```

#### 5.2 Scale Application (Optional)
```bash
# Scale to 3 replicas
kubectl scale deployment taskmanager-app --replicas=3

# Verify
kubectl get pods
```

📸 **SCREENSHOT 8**: Take screenshot of `kubectl get all` output

---

## PART 3: GITHUB REPOSITORY (5 Marks)

### Step 1: Initialize Git Repository (1 Mark)

```bash
# Navigate to project directory
cd "d:\University\Semester_6\DevOps\Lab exam\task-manager-app"

# Initialize git
git init
```

**Expected Output**:
```
Initialized empty Git repository in ...
```

---

### Step 2: Add Files to Repository (2 Marks)

```bash
# Check status
git status

# Add all files
git add .

# Verify staged files
git status
```

**Expected Output**:
```
Changes to be committed:
  new file:   .gitignore
  new file:   Dockerfile
  new file:   README.md
  new file:   backend/package.json
  new file:   backend/server.js
  new file:   docker-compose.yml
  new file:   frontend/app.js
  new file:   frontend/index.html
  new file:   frontend/style.css
  new file:   k8s/deployment.yaml
```

---

### Step 3: Commit and Push (2 Marks)

#### 3.1 Commit Changes
```bash
git commit -m "Initial commit: Task Manager DevOps project with Docker and Kubernetes"
```

#### 3.2 Create GitHub Repository
1. Go to: https://github.com
2. Click **"New repository"**
3. Name: `task-manager-devops`
4. Description: `DevOps Cloud Deployment Pipeline - Full Stack Task Manager`
5. Visibility: Public
6. Click **"Create repository"**

#### 3.3 Add Remote and Push
```bash
# Add remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/task-manager-devops.git

# Push to GitHub
git branch -M main
git push -u origin main
```

**Expected Output**:
```
Enumerating objects: xx, done.
Writing objects: 100% (xx/xx), done.
To https://github.com/YOUR_USERNAME/task-manager-devops.git
 * [new branch]      main -> main
```

#### 3.4 Verify on GitHub
- Go to your repository URL
- You should see all files

📸 **SCREENSHOT 9**: Take screenshot of GitHub repository page

**🔗 Note the GitHub Repository Link**:
```
https://github.com/YOUR_USERNAME/task-manager-devops
```

---

### Step 4: Additional Git Commands (Demonstration)

#### Pull Changes
```bash
git pull origin main
```

#### Check History
```bash
git log --oneline
```

#### Create Branch (Optional)
```bash
git checkout -b feature/add-authentication
git branch
git checkout main
```

📸 **SCREENSHOT 10**: Take screenshot of git log and git status

---

## 📝 SUBMISSION CHECKLIST

### Required Links
✅ **GitHub Repository**: https://github.com/YOUR_USERNAME/task-manager-devops  
✅ **Docker Hub Image**: https://hub.docker.com/r/YOUR_USERNAME/task-manager  
✅ **Azure Public URL**: http://YOUR_EXTERNAL_IP

### Required Screenshots
1. ✅ `docker ps` - Running containers
2. ✅ Application running locally in browser
3. ✅ Docker Hub repository page
4. ✅ Azure AKS cluster creation
5. ✅ `kubectl get nodes` output
6. ✅ `kubectl get pods` - Running pods
7. ✅ Application running on Azure public IP
8. ✅ `kubectl get all` - All Kubernetes resources
9. ✅ GitHub repository page
10. ✅ Git log and status

### Document Structure
Create a Word/PDF document with:

1. **Cover Page**
   - Name, Roll Number
   - Course: CSC418 DevOps
   - Title: Cloud Deployment Pipeline Project

2. **Introduction**
   - Project overview
   - Technology stack

3. **Part 1: Dockerization (10 Marks)**
   - Local setup steps
   - Docker commands used
   - Screenshots 1-3

4. **Part 2: Azure Kubernetes (10 Marks)**
   - AKS creation steps
   - Deployment commands
   - Screenshots 4-8

5. **Part 3: GitHub (5 Marks)**
   - Git commands used
   - Screenshots 9-10

6. **Links Section**
   - GitHub repository URL
   - Docker Hub image URL
   - Azure public application URL

7. **Conclusion**
   - Challenges faced
   - Learnings

---

## 🔧 TROUBLESHOOTING

### Issue: Docker build fails
```bash
# Clear cache and rebuild
docker system prune -a
docker build --no-cache -t task-manager:latest .
```

### Issue: Pods not starting
```bash
# Check pod details
kubectl describe pod <pod-name>

# Check logs
kubectl logs <pod-name>

# Check events
kubectl get events --sort-by=.metadata.creationTimestamp
```

### Issue: External IP stuck on <pending>
```bash
# Wait 5 minutes, then check again
kubectl get service taskmanager-service

# If still pending, check LoadBalancer
kubectl describe service taskmanager-service
```

### Issue: MongoDB connection error
```bash
# Check if MongoDB pod is running
kubectl get pods

# Check MongoDB logs
kubectl logs <mongodb-pod-name>

# Verify service exists
kubectl get service mongodb
```

---

## 📚 Git Commands Summary

| Command | Description |
|---------|-------------|
| `git init` | Initialize repository |
| `git status` | Check file status |
| `git add .` | Stage all files |
| `git commit -m "message"` | Commit changes |
| `git remote add origin <url>` | Add remote repository |
| `git push -u origin main` | Push to GitHub |
| `git pull origin main` | Pull latest changes |
| `git log` | View commit history |
| `git branch` | List branches |

---

## 🐳 Docker Commands Summary

| Command | Description |
|---------|-------------|
| `docker build -t name .` | Build image |
| `docker images` | List images |
| `docker ps` | List running containers |
| `docker-compose up -d` | Start services |
| `docker-compose down` | Stop services |
| `docker logs <container>` | View logs |
| `docker login` | Login to Docker Hub |
| `docker tag <src> <dest>` | Tag image |
| `docker push <image>` | Push to registry |

---

## ☸️ Kubernetes Commands Summary

| Command | Description |
|---------|-------------|
| `kubectl get nodes` | List nodes |
| `kubectl get pods` | List pods |
| `kubectl get services` | List services |
| `kubectl get all` | List all resources |
| `kubectl apply -f <file>` | Apply configuration |
| `kubectl describe pod <name>` | Pod details |
| `kubectl logs <pod>` | View pod logs |
| `kubectl delete -f <file>` | Delete resources |
| `kubectl scale deployment <name> --replicas=n` | Scale deployment |

---

## 🎯 Grading Breakdown

### Part 1: Dockerization (10 Marks)
- Local setup & testing: 2 marks
- Dockerfile creation: 3 marks
- Docker build & run: 3 marks
- Push to Docker Hub: 2 marks

### Part 2: Azure Kubernetes (10 Marks)
- Create AKS cluster: 3 marks
- Deploy application: 4 marks
- Expose with public IP: 3 marks

### Part 3: GitHub (5 Marks)
- Create repository: 1 mark
- Add files: 2 marks
- Git commands usage: 2 marks

**Total: 25 Marks**

---

## ✅ COMPLETION CHECKLIST

Before submitting, ensure:
- [ ] Application runs locally
- [ ] Docker image built successfully
- [ ] Image pushed to Docker Hub
- [ ] AKS cluster created
- [ ] Application deployed to AKS
- [ ] Public IP accessible
- [ ] GitHub repository created
- [ ] All files pushed to GitHub
- [ ] All screenshots captured
- [ ] Document created with all links
- [ ] Document formatted professionally

---

**Good luck with your deployment! 🚀**
