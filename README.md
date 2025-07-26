# Full-Stack Application on Kubernetes

A complete containerized application stack featuring React frontend, Node.js backend, and MongoDB database, deployed on Kubernetes with MongoDB Express for database management.

## 🏗️ Architecture

- **Frontend**: React application served via Kubernetes service
- **Backend**: Node.js API server with REST endpoints
- **Database**: MongoDB with persistent storage
- **Admin**: MongoDB Express for database management
- **Orchestration**: Kubernetes for container management

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- [Docker](https://docs.docker.com/get-docker/) (v20.0+)
- [Kubernetes](https://kubernetes.io/docs/setup/) (v1.20+)
  - Local: [Minikube](https://minikube.sigs.k8s.io/docs/start/) or [Docker Desktop](https://www.docker.com/products/docker-desktop)
  - Cloud: EKS, GKE, or AKS
- [kubectl](https://kubernetes.io/docs/tasks/tools/) CLI tool
- [Git](https://git-scm.com/downloads)

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone <your-repository-url>
cd <your-project-name>
```

### 2. Verify Kubernetes Cluster

```bash
# Check if kubectl is configured
kubectl cluster-info

# Verify nodes are ready
kubectl get nodes
```

### 3. Deploy the Application

Deploy in the following order to ensure proper dependency resolution:

#### Step 1: Deploy MongoDB Storage
```bash
# Create persistent volume and claim for MongoDB
kubectl apply -f mongodb-pv.yml
kubectl apply -f mongodb-pvc.yml

# Deploy MongoDB database
kubectl apply -f mongodb-deployment.yml
kubectl apply -f mongodb-service.yml
```

#### Step 2: Deploy Backend Services
```bash
# Create backend secrets (update with your values first)
kubectl apply -f backend-secret.yml

# Deploy backend API
kubectl apply -f backend-deployment.yml
kubectl apply -f backend-service.yml
```

#### Step 3: Deploy Frontend
```bash
# Deploy React frontend
kubectl apply -f k8s/frontend-k8s/deployment.yml
kubectl apply -f k8s/frontend-k8s/service.yml
```

#### Step 4: Deploy MongoDB Express (Optional)
```bash
# Deploy MongoDB admin interface
kubectl apply -f k8s/mongodb-express/deployment.yml
kubectl apply -f k8s/mongodb-express/service.yml
```

### 4. Verify Deployment

```bash
# Check all pods are running
kubectl get pods

# Check services
kubectl get services

# View deployment status
kubectl get deployments
```

## 🔧 Configuration

### Environment Variables

Update the following files with your specific configuration:

#### `backend-secret.yml`
```yaml
# Add your MongoDB connection string, JWT secrets, etc.
data:
  MONGODB_URI: <base64-encoded-connection-string>
  JWT_SECRET: <base64-encoded-jwt-secret>
```

#### Backend Deployment
Ensure your backend deployment references the correct:
- Docker image
- Environment variables
- Port configurations

#### Frontend Deployment
Configure your React app to point to the correct backend service URL.

## 🌐 Accessing the Application

### Local Development (Minikube)

```bash
# Get Minikube IP
minikube ip

# Port forward services for local access
kubectl port-forward service/frontend-service 3000:3000
kubectl port-forward service/backend-service 5000:5000
kubectl port-forward service/mongodb-express-service 8081:8081
```

Access URLs:
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:5000
- **MongoDB Express**: http://localhost:8081

### Cloud Deployment

If using LoadBalancer services:

```bash
# Get external IPs
kubectl get services

# Or use ingress controller for domain-based routing
kubectl get ingress
```

## 📁 Project Structure

```
├── backend/                      # Backend application code
├── frontend/                     # React frontend code
├── k8s/                         # Kubernetes manifests
│   ├── frontend-k8s/
│   │   ├── deployment.yml       # Frontend deployment config
│   │   └── service.yml          # Frontend service config
│   └── mongodb-express/
│       ├── deployment.yml       # MongoDB Express deployment
│       └── service.yml          # MongoDB Express service
├── backend-deployment.yml       # Backend API deployment
├── backend-secret.yml          # Backend secrets & env vars
├── backend-service.yml         # Backend service configuration
├── mongodb-deployment.yml      # MongoDB database deployment
├── mongodb-pv.yml             # MongoDB persistent volume
├── mongodb-pvc.yml            # MongoDB persistent volume claim
├── mongodb-secret.yml         # MongoDB credentials
├── mongodb-service.yml        # MongoDB service configuration
├── namespace.yml              # Kubernetes namespace (optional)
└── README.md                  # This file
```

## 🛠️ Development Workflow

### Building and Pushing Images

If you need to update the application:

```bash
# Build backend image
cd backend
docker build -t your-registry/backend:latest .
docker push your-registry/backend:latest

# Build frontend image
cd ../frontend
docker build -t your-registry/frontend:latest .
docker push your-registry/frontend:latest

# Update deployments
kubectl set image deployment/backend-deployment backend=your-registry/backend:latest
kubectl set image deployment/frontend-deployment frontend=your-registry/frontend:latest
```

### Scaling the Application

```bash
# Scale backend replicas
kubectl scale deployment backend-deployment --replicas=3

# Scale frontend replicas
kubectl scale deployment frontend-deployment --replicas=2
```

## 📊 Monitoring and Logs

```bash
# View pod logs
kubectl logs -f deployment/backend-deployment
kubectl logs -f deployment/frontend-deployment

# Describe resources for troubleshooting
kubectl describe pod <pod-name>
kubectl describe service <service-name>

# Get resource usage
kubectl top pods
kubectl top nodes
```

## 🔒 Security Considerations

- Update default passwords in `backend-secret.yml`
- Use proper RBAC (Role-Based Access Control)
- Configure network policies for pod-to-pod communication
- Use TLS/SSL certificates for production
- Regularly update base images and dependencies

## 🧪 Testing

```bash
# Test backend health
kubectl port-forward service/backend-service 5000:5000
curl http://localhost:5000/health

# Test database connection
kubectl exec -it deployment/mongodb-deployment -- mongo
```

## 🚨 Troubleshooting

### Common Issues

1. **Pods stuck in Pending state**
   ```bash
   kubectl describe pod <pod-name>
   # Check for resource constraints or node selector issues
   ```

2. **Service not accessible**
   ```bash
   kubectl get endpoints
   # Ensure pods are ready and labels match
   ```

3. **MongoDB connection issues**
   ```bash
   kubectl logs deployment/backend-deployment
   # Check connection string and credentials
   ```

4. **Persistent volume issues**
   ```bash
   kubectl get pv,pvc
   # Verify storage class and volume availability
   ```

## 📚 Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [MongoDB on Kubernetes](https://docs.mongodb.com/kubernetes-operator/)
- [React Deployment Guide](https://create-react-app.dev/docs/deployment/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📧 Support

If you encounter any issues or have questions:
- Create an issue in this repository
- Check the troubleshooting section above
- Review Kubernetes and Docker documentation

---

**Happy Coding! 🚀**
