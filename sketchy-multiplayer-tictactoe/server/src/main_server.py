from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from typing import List, Dict
from game_manager import GameManager

app = FastAPI()
manager = GameManager()

@app.websocket("/ws/{game_id}/{player_id}")
async def websocket_endpoint(websocket: WebSocket, game_id: str, player_id: str):
    await manager.connect(game_id, player_id, websocket)
    try:
        while True:
            data = await websocket.receive_text()
            await manager.receive_move(game_id, player_id, data)
    except WebSocketDisconnect:
        manager.disconnect(game_id, player_id)
