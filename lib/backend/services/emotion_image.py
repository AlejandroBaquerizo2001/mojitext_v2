from typing import Dict, Any
import cv2
import numpy as np

def analyze(image_path: str) -> Dict[str, Any]:
    try:
        # Simulación de análisis de imagen (en un sistema real usarías un modelo entrenado)
        return {
            "dominant_emotion": "feliz",
            "emotions": {
                "feliz": 70.0,
                "neutral": 20.0,
                "sorpresa": 10.0
            }
        }
    except Exception as e:
        return {
            "dominant_emotion": "error",
            "emotions": {
                "error": 100.0
            },
            "message": str(e)
        }