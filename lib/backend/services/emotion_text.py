import re
from typing import Dict, Any
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.svm import SVC
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler

# Dataset de entrenamiento ampliado
training_data = [
    ("estoy muy feliz hoy", "feliz"),
    ("me siento alegre y contento", "feliz"),
    ("qué día tan maravilloso", "feliz"),
    ("me encanta esto", "feliz"),
    ("estoy triste y deprimido", "triste"),
    ("me siento solo y abandonado", "triste"),
    ("qué día tan horrible", "triste"),
    ("no tengo ganas de nada", "triste"),
    ("estoy enojado y furioso", "enojado"),
    ("esto me molesta mucho", "enojado"),
    ("qué rabia me da esta situación", "enojado"),
    ("no puedo creer lo que hicieron", "sorpresa"),
    ("vaya sorpresa tan inesperada", "sorpresa"),
    ("tengo miedo de lo que pueda pasar", "miedo"),
    ("esto me asusta mucho", "miedo"),
    ("me da pánico pensar en eso", "miedo"),
    ("no sé qué hacer ahora", "confundido"),
    ("estoy indeciso sobre esto", "confundido"),
    ("todo está bien", "neutral"),
    ("nada especial hoy", "neutral")
]

# Separar datos de entrenamiento
texts, labels = zip(*training_data)

# Crear y entrenar el modelo
model = make_pipeline(
    TfidfVectorizer(),
    StandardScaler(with_mean=False),  # Necesario para datos dispersos
    SVC(probability=True, kernel='linear')
)
model.fit(texts, labels)

def analyze(text: str) -> Dict[str, Any]:
    text_clean = text.lower().strip()
    
    if not text_clean or len(text_clean.split()) < 2:
        return {
            "dominant_emotion": "neutral",
            "emotions": {"neutral": 100.0}
        }
    
    # Predecir probabilidades
    probas = model.predict_proba([text_clean])[0]
    emotion_probs = {
        emotion: round(float(prob) * 100, 1)
        for emotion, prob in zip(model.classes_, probas)
    }
    
    # Ordenar emociones por probabilidad
    sorted_emotions = dict(sorted(
        emotion_probs.items(),
        key=lambda item: item[1],
        reverse=True
    ))
    
    # Emoción dominante
    dominant = max(emotion_probs, key=emotion_probs.get)
    
    return {
        "dominant_emotion": dominant,
        "emotions": sorted_emotions
    }