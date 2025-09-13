from fastapi.testclient import TestClient
from main import app   # assumes your FastAPI app is in main.py

client = TestClient(app)

def test_root():
    response = client.get("/")
    assert response.status_code == 200
    assert "Hello" in response.text
