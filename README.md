# Task Manager - DevOps Cloud Deployment Pipeline

## 📋 Project Overview
A full-stack Task Manager application demonstrating complete DevOps deployment pipeline from local development to Azure Kubernetes Service (AKS).

## 🏗️ Architecture
- **Frontend**: HTML5, CSS3, JavaScript (Vanilla)
- **Backend**: Node.js with Express.js
- **Database**: MongoDB
- **Containerization**: Docker
- **Orchestration**: Kubernetes (AKS)
- **CI/CD**: GitHub, Docker Hub

## ✨ Features
- ➕ Create tasks with title and description
- ✅ Mark tasks as completed
- 🗑️ Delete tasks
- 📱 Responsive design
- 🔄 Real-time data persistence
- 🏥 Health check endpoint

## 🚀 Local Development

### Prerequisites
- Node.js (v18 or higher)
- Docker Desktop
- MongoDB (or use Docker Compose)

### Setup & Run

1. **Install dependencies**:
```bash
cd backend
npm install
```

2. **Run with Docker Compose**:
```bash
docker-compose up -d
```

3. **Access the application**:
- Frontend: http://localhost:3000
- Health Check: http://localhost:3000/health
- API: http://localhost:3000/api/tasks

## 🐳 Docker Commands

### Build Image
```bash
docker build -t task-manager:latest .
```

### Run Container
```bash
docker run -p 3000:3000 task-manager:latest
```

### Push to Docker Hub
```bash
docker tag task-manager:latest YOUR_USERNAME/task-manager:latest
docker push YOUR_USERNAME/task-manager:latest
```

## ☸️ Kubernetes Deployment

### Deploy to AKS
```bash
# Apply deployment
kubectl apply -f k8s/deployment.yaml

# Check status
kubectl get pods
kubectl get services

# Get external IP
kubectl get service taskmanager-service
```

## 📁 Project Structure
```
task-manager-app/
├── backend/
│   ├── server.js           # Express server & API routes
│   └── package.json        # Node.js dependencies
├── frontend/
│   ├── index.html          # Main HTML file
│   ├── style.css           # Styling
│   └── app.js              # Frontend JavaScript
├── k8s/
│   └── deployment.yaml     # Kubernetes manifests
├── Dockerfile              # Docker configuration
├── docker-compose.yml      # Local development
└── README.md              # This file
```

## 🔗 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/tasks | Get all tasks |
| POST | /api/tasks | Create new task |
| PUT | /api/tasks/:id | Update task |
| DELETE | /api/tasks/:id | Delete task |
| GET | /health | Health check |

## 📦 Environment Variables
- `PORT`: Server port (default: 3000)
- `MONGO_URI`: MongoDB connection string
- `NODE_ENV`: Environment (development/production)

## 👨‍💻 Author
DevOps Student - CSC418 Lab Midterm Exam

## 📄 License
ISC
