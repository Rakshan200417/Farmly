# Farmly AI Inference Service (FastAPI)

Cloud fallback microservice for crop disease vision detection and Sri Lankan acreage dosage calculations.

## Getting Started

### 1. Install Dependencies
```bash
pip install -r requirements.txt
```

### 2. Run the Service
```bash
uvicorn main:app --reload --port 8000
```

### 3. API Documentation
Once running, open your browser to:
- **Interactive Swagger Docs:** [http://localhost:8000/docs](http://localhost:8000/docs)
- **Redoc:** [http://localhost:8000/redoc](http://localhost:8000/redoc)
- **Health Check:** [http://localhost:8000/health](http://localhost:8000/health)
