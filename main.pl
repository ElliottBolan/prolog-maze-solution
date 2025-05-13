% Elliott Bolan CS4337 Project 2

% Gets the type of cell at a specific position
getCell(Maze, Row, Col, CellType) :-
    nth0(Row, Maze, MazeRow),
    nth0(Col, MazeRow, CellType).

% Finds the position of the start cell in the maze
findStart(Maze, Row, Col) :-
    nth0(Row, Maze, MazeRow),
    nth0(Col, MazeRow, s).

% Counts the number of cells of a specific type in the maze
countCells(Maze, CellType, Count) :-
    findall(1, mazeContains(Maze, CellType), Ones),
    length(Ones, Count).

% Checks if the maze contains a specific type of cell
mazeContains(Maze, CellType) :-
    nth0(_, Maze, Row),
    nth0(_, Row, CellType).

% Selects an action to take
select_action(up).
select_action(down).
select_action(left).
select_action(right).

% Applies an action to get the new position
apply_action(Row, Col, up, NewRow, Col) :- NewRow is Row - 1.
apply_action(Row, Col, down, NewRow, Col) :- NewRow is Row + 1.
apply_action(Row, Col, left, Row, NewCol) :- NewCol is Col - 1.
apply_action(Row, Col, right, Row, NewCol) :- NewCol is Col + 1.

% Checks if a move is valid (not a wall, not off the maze)
isValidMove(Maze, Row, Col) :-
    % Check if the position is within the maze boundaries
    Row >= 0,
    nth0(0, Maze, FirstRow),
    length(FirstRow, Width),
    Col >= 0, Col < Width,
    length(Maze, Height),
    Row < Height,
    % Check if the position is not a wall
    getCell(Maze, Row, Col, CellType),
    CellType \= w.

% Finds a path from the current position to an exit. Arguments:
% 1. The maze
% 2. The current row
% 3. The current column
% 4. The actions taken so far (in reverse order)
% 5. The final list of actions
findPath(Maze, Row, Col, RevActions, Actions) :-
    % Check if the current position is an exit
    getCell(Maze, Row, Col, e),
    % If it is, reverse the actions to get them in the correct order
    reverse(RevActions, Actions).

findPath(Maze, Row, Col, RevActions, Actions) :-
    % Choose a direction to move
    select_action(Action),
    % Apply the action to get the new position
    apply_action(Row, Col, Action, NewRow, NewCol),
    % Check if the new position is valid (not a wall and within the maze)
    isValidMove(Maze, NewRow, NewCol),
    % Add the action to the list of actions taken
    findPath(Maze, NewRow, NewCol, [Action|RevActions], Actions).


