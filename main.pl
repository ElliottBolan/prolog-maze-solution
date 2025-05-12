% CS4337 Project 2 - Maze Solver
% This program contains a predicate find_exit/2 that can solve a maze.

% get_cell/4: Gets the type of cell at a specific position
get_cell(Maze, Row, Col, CellType) :-
    nth0(Row, Maze, MazeRow),
    nth0(Col, MazeRow, CellType).

% find_start/3: Finds the position of the start cell in the maze
find_start(Maze, Row, Col) :-
    nth0(Row, Maze, MazeRow),
    nth0(Col, MazeRow, s).

% Counts the number of cells of a specific type in the maze
count_cells(Maze, CellType, Count) :-
    findall(1, maze_contains(Maze, CellType), Ones),
    length(Ones, Count).

% Checks if the maze contains a specific cell type
maze_contains(Maze, CellType) :-
    nth0(_, Maze, Row),
    nth0(_, Row, CellType).

% find_exit/2: Solves the maze and finds the exit
find_exit(Maze, Path) :-
    find_start(Maze, StartRow, StartCol),
    find_exit_helper(Maze, StartRow, StartCol, [], Path).
    