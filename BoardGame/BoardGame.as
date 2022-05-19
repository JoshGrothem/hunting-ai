package {
	import flash.display.MovieClip;
	import flash.events.*;

	public class BoardGame extends MovieClip {
		public var board: Array;
		public var boardOfObjects: Array;
		public var player: Player;
		public var wolf: Wolf;

		public function BoardGame() {
			// constructor code
			board = new Array();
			boardOfObjects = new Array();
			makeBoard();
			displayBoard();

			player = new Player(1, 1);
			addChild(player);
			wolf = new Wolf(Game.ROWS - 2, Game.COLS - 2);
			addChild(wolf);

			stage.addEventListener(KeyboardEvent.KEY_UP, playerMoves);
			stage.addEventListener(Event.ENTER_FRAME, checkCollision);

		}
		public function checkCollision(event: Event): void {
			if (player.mRow == wolf.mRow && player.col == wolf.col) {
				removeChild(player);
				stage.removeEventListener(Event.ENTER_FRAME, checkCollision);
			}
		}

		public function playerMoves(event: KeyboardEvent) {
			switch (event.keyCode) {
				case Game.UPARROW:
					if (validMove(player.mRow - 1, player.col)) {
						player.mRow--;
					}
					break;
				case Game.DOWNARROW:
					if (validMove(player.mRow + 1, player.col)) {
						player.mRow++;
					}
					break;
				case Game.LEFTARROW:
					if (validMove(player.mRow, player.col - 1)) {
						player.col--;
					}
					break;
				case Game.RIGHTARROW:
					if (validMove(player.mRow, player.col + 1)) {
						player.col++;
					}
			}
			player.reposition();
			hunt();
			wolf.reposition();

		}

		public function hunt(): void {
			var distR: int = player.mRow - wolf.mRow;
			var distC: int = player.col - wolf.col;
			//trace(distR);
			//trace(distC);
		
			if (Math.abs(distR) > Math.abs(distC)) {
				if (distR < 0 && validMove(wolf.mRow - 1, wolf.col)) {
					wolf.mRow--;
				} if (distR > 0 && validMove(wolf.mRow +1, wolf.col)) {
					wolf.mRow++;
				}
			} else {
				if (distC > 0 && validMove(wolf.mRow, wolf.col +1)) {
					wolf.col++;
				} if(distC < 0 && validMove(wolf.mRow, wolf.col -1)) {
					wolf.col--;
				}
			}


		}

		public function validMove(r, c: int) {
			if (board[r][c] != 1) {
				return true;
			}
		}


		public function makeBoard(): void {
			for (var r: int = 0; r < Game.ROWS; r++) {
				board[r] = new Array();

				for (var c: int = 0; c < Game.COLS; c++) {
					if (r == 0 || r == Game.ROWS - 1 || c == 0 || c == Game.COLS - 1) {
						board[r][c] = Game.BLOCK;
					} else {
						var percent: Number = Math.random();
						if (percent < .85) {
							board[r][c] = Game.FREE;
						} else {
							board[r][c] = Game.BLOCK;
						}
					}
				}
			}
			board[Game.EXIT_ROW][Game.EXIT_COL] = Game.EXIT;
		}

		public function displayBoard(): void {
			for (var r: int = 0; r < Game.ROWS; r++) {
				for (var c: int = 0; c < Game.COLS; c++) {
					var cell: MovieClip;

					if (board[r][c] == Game.FREE) {
						cell = new Free();
					} else if (board[r][c] == Game.EXIT) {
						cell = new ExitDoor();
					} else {
						cell = new Block();
					}
					cell.x = c * Game.WIDTH + Game.OFFSET;
					cell.y = r * Game.WIDTH + Game.OFFSET;
					cell.alpha = .7;
					boardOfObjects.push(cell);
					addChild(cell);
				}
			}
		}

	}

}