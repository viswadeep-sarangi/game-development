from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from typing import List, Dict
from game_server_manager import GameManager

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
        await manager.disconnect(game_id, player_id)

# Get the list of games that have only one player connected along with the player ID of that player
@app.get("/games/one_player")
async def get_games_with_one_player() -> List[Dict[str, str]]:
    one_player_games = []
    for game_id, game in manager.games.items():
        if len(game["players"]) == 1:
            player_id = next(iter(game["players"].keys()))
            one_player_games.append({"game_id": game_id, "player_id": player_id})
    return one_player_games