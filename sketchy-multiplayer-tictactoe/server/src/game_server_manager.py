from typing import Dict, List
from fastapi import WebSocket

class GameManager:
    def __init__(self):
        self.games: Dict[str, Dict] = {}  # game_id -> {'players': {}, 'board': []}

    async def connect(self, game_id: str, player_id: str, websocket: WebSocket):
        await websocket.accept()
        if game_id not in self.games:
            self.games[game_id] = {"players": {}, "board": [["" for _ in range(3)] for _ in range(3)]}
        self.games[game_id]["players"][player_id] = websocket

        await self.broadcast(game_id, f"JOIN|{player_id}")

    def disconnect(self, game_id: str, player_id: str):
        self.games[game_id]["players"].pop(player_id, None)

    async def receive_move(self, game_id: str, player_id: str, message: str):
        # Example message: "MOVE|1|2"
        parts = message.split("|")
        if parts[0] == "MOVE":
            row, col = int(parts[1]), int(parts[2])
            symbol = "X" if player_id == "player1" else "O"

            board = self.games[game_id]["board"]
            if board[row][col] == "":
                board[row][col] = symbol
                await self.broadcast(game_id, f"UPDATE|{row}|{col}|{symbol}")
                await self.broadcast(game_id, self.draw_board(self.games[game_id]["board"]))

                if self.check_win(board, symbol):
                    await self.broadcast(game_id, f"WIN|{player_id}")
                elif self.check_draw(board):
                    await self.broadcast(game_id, "DRAW")

    async def broadcast(self, game_id: str, message: str):
        for ws in self.games[game_id]["players"].values():
            await ws.send_text(message)

    def check_win(self, board, symbol):
        for i in range(3):
            if all(board[i][j] == symbol for j in range(3)): return True
            if all(board[j][i] == symbol for j in range(3)): return True
        if all(board[i][i] == symbol for i in range(3)): return True
        if all(board[i][2-i] == symbol for i in range(3)): return True
        return False

    def check_draw(self, board):
        return all(cell != "" for row in board for cell in row)
    
    def draw_board(self, board):
        _board = '\n|'
        for row in board:
            for x in row:
                _board+=f' {x} |'
            _board+='\n|'
        return _board
