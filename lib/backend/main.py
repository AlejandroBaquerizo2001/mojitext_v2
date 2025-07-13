from fastapi import FastAPI, UploadFile, File, Form, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import os
from services import emotion_text, emotion_voice, emotion_image
from typing import Dict, Any

app = FastAPI()

# Configura CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/analyze_text")
async def analyze_text(text: str = Form(...)) -> Dict[str, Any]:
    if not text or len(text) < 3:
        raise HTTPException(status_code=400, detail="Texto muy corto (mínimo 3 caracteres)")
    
    try:
        result = emotion_text.analyze(text)
        return {
            "status": "success",
            "dominant_emotion": result["dominant_emotion"],
            "emotions": result["emotions"]
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error en el análisis: {str(e)}")

@app.post("/analyze_voice")
async def analyze_voice(file: UploadFile = File(...)) -> Dict[str, Any]:
    if not file.content_type.startswith('audio/'):
        raise HTTPException(status_code=400, detail="Se requiere un archivo de audio")
    
    temp_path = f"temp_voice_{file.filename}"
    try:
        with open(temp_path, "wb") as buffer:
            buffer.write(await file.read())
        
        result = emotion_voice.analyze(temp_path)
        return {
            "status": "success",
            "dominant_emotion": result["dominant_emotion"],
            "emotions": result["emotions"]
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error en el análisis: {str(e)}")
    finally:
        if os.path.exists(temp_path):
            os.remove(temp_path)

@app.post("/analyze_image")
async def analyze_image(file: UploadFile = File(...)) -> Dict[str, Any]:
    if not file.content_type.startswith('image/'):
        raise HTTPException(status_code=400, detail="Se requiere un archivo de imagen")
    
    temp_path = f"temp_image_{file.filename}"
    try:
        with open(temp_path, "wb") as buffer:
            buffer.write(await file.read())
        
        result = emotion_image.analyze(temp_path)
        return {
            "status": "success",
            "dominant_emotion": result["dominant_emotion"],
            "emotions": result["emotions"]
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error en el análisis: {str(e)}")
    finally:
        if os.path.exists(temp_path):
            os.remove(temp_path)