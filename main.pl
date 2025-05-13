% Elliott Bolan CS4337 Project 2 - Optimized Version

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

% Checks if a move is valid (not a wall, not off the maze, not already visited)
isValidMove(Maze, Row, Col, Visited) :-
    % Check if the position is within the maze boundaries
    Row >= 0,
    nth0(0, Maze, FirstRow),
    length(FirstRow, Width),
    Col >= 0, Col < Width,
    length(Maze, Height),
    Row < Height,
    % Check if the position is not a wall
    getCell(Maze, Row, Col, CellType),
    CellType \= w,
    % Check if the position has not been visited
    \+ member(pos(Row, Col), Visited).

% Finds a path from the current position to an exit using an optimized approach
% that keeps track of visited cells to avoid revisiting them
findPathOptimized(Maze, Row, Col, Visited, RevActions, Actions) :-
    % Check if the current position is an exit
    getCell(Maze, Row, Col, e),
    % If it is, reverse the actions to get them in the correct order
    reverse(RevActions, Actions).

findPathOptimized(Maze, Row, Col, Visited, RevActions, Actions) :-
    % Choose a direction to move
    select_action(Action),
    % Apply the action to get the new position
    apply_action(Row, Col, Action, NewRow, NewCol),
    % Check if the new position is valid and not visited
    isValidMove(Maze, NewRow, NewCol, Visited),
    % Add the current position to the visited list
    findPathOptimized(Maze, NewRow, NewCol, [pos(Row, Col)|Visited], [Action|RevActions], Actions).

% Main predicate to find an exit in the maze - optimized version
findExitOptimized(Maze, Actions) :-
    % Validate the maze first
    validateMaze(Maze),
    % Find the starting position
    findStart(Maze, StartRow, StartCol),
    % Find a path from the start to any exit, keeping track of visited cells
    findPathOptimized(Maze, StartRow, StartCol, [], [], Actions).

% Alternative name for compatibility
find_exit_optimized(Maze, Actions) :- findExitOptimized(Maze, Actions).

% Original findPath and findExit predicates kept for reference
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
    isValidMove(Maze, NewRow, NewCol, []),
    % Add the action to the list of actions taken
    findPath(Maze, NewRow, NewCol, [Action|RevActions], Actions).

findExit(Maze, Actions) :-
    % Validate the maze first
    validateMaze(Maze),
    % Find the starting position
    findStart(Maze, StartRow, StartCol),
    % Find a path from the start to any exit
    findPath(Maze, StartRow, StartCol, [], Actions).

find_exit(Maze, Actions) :- findExit(Maze, Actions).

% Checks if a maze is valid
validateMaze(Maze) :-
    % Check if the maze is a list of lists (rows of cells)
    isListOfLists(Maze),
    % Count the number of start positions (should be 1)
    countCells(Maze, s, 1),
    % Count the number of exit positions (should be at least 1)
    countCells(Maze, e, ExitCount),
    ExitCount > 0.

% Checks if the maze is a list of lists
isListOfLists([]).
isListOfLists([H|T]) :-
    is_list(H),
    isListOfLists(T).

% Original mazes kept for reference
generate_maze(Maze) :-
    Maze = [
        [w, w, w, w, w, w, w],
        [w, s, o, o, w, e, w],
        [w, w, w, o, w, o, w],
        [w, o, o, o, o, o, w],
        [w, o, w, w, w, o, w],
        [w, o, o, o, w, o, w],
        [w, w, w, w, w, w, w]
    ].

generate_complex_maze(Maze) :-
    Maze = [
        [w, w, w, w, w, w, w, w, w, w],
        [w, s, o, o, w, o, o, o, o, w],
        [w, w, w, o, w, o, w, w, o, w],
        [w, o, o, o, o, o, w, e, o, w],
        [w, o, w, w, w, w, w, w, o, w],
        [w, o, o, o, o, o, o, o, o, w],
        [w, w, w, w, o, w, w, w, o, w],
        [w, e, o, o, o, o, o, w, o, w],
        [w, w, w, w, w, w, w, w, w, w]
    ].

% Visual representation of the maze
print_maze(Maze) :-
    print_rows(Maze).

print_rows([]).
print_rows([Row|Rows]) :-
    print_row(Row),
    nl,
    print_rows(Rows).

print_row([]).
print_row([Cell|Cells]) :-
    print_cell(Cell),
    print_row(Cells).

% Tell Prolog that print_cell/1 will be defined in multiple places
:- discontiguous print_cell/1.

% Cell display characters
print_cell(w) :- write('█').  % Wall
print_cell(o) :- write(' ').  % Open space
print_cell(s) :- write('S').  % Start
print_cell(e) :- write('E').  % Exit
print_cell(p) :- write('•').  % Path

% Helper predicate to visualize a solution
print_solution(Maze, Actions) :-
    % Find the starting position
    findStart(Maze, StartRow, StartCol),
    % Create a copy of the maze
    copy_maze(Maze, SolutionMaze),
    % Mark the path in the solution maze
    mark_path(SolutionMaze, StartRow, StartCol, Actions, FinalMaze),
    % Print the solution
    print_maze(FinalMaze).

% Copy a maze
copy_maze([], []).
copy_maze([Row|Rows], [CopyRow|CopyRows]) :-
    copy_row(Row, CopyRow),
    copy_maze(Rows, CopyRows).

copy_row([], []).
copy_row([Cell|Cells], [Cell|CopyCells]) :-
    copy_row(Cells, CopyCells).

% Mark the path in the maze
mark_path(Maze, _, _, [], Maze).
mark_path(Maze, Row, Col, [Action|Actions], FinalMaze) :-
    apply_action(Row, Col, Action, NewRow, NewCol),
    update_cell(Maze, NewRow, NewCol, p, UpdatedMaze),
    mark_path(UpdatedMaze, NewRow, NewCol, Actions, FinalMaze).

% Update a cell in the maze
update_cell(Maze, Row, Col, NewValue, NewMaze) :-
    nth0(Row, Maze, OldRow),
    replace_nth0(Col, OldRow, NewValue, NewRow),
    replace_nth0(Row, Maze, NewRow, NewMaze).

% Replace an element at a given position in a list
replace_nth0(0, [_|T], X, [X|T]) :- !.
replace_nth0(I, [H|T], X, [H|R]) :-
    I > 0,
    I1 is I - 1,
    replace_nth0(I1, T, X, R).

% Run an example
run_example :-
    generate_maze(Maze),
    print_maze(Maze),
    nl, write('Finding solution (optimized)...'), nl,
    findExitOptimized(Maze, Actions),
    write('Solution found: '), write(Actions), nl,
    nl, write('Solution path:'), nl,
    print_solution(Maze, Actions).

run_complex_example :-
    generate_complex_maze(Maze),
    print_maze(Maze),
    nl, write('Finding solution (optimized)...'), nl,
    findExitOptimized(Maze, Actions),
    write('Solution found: '), write(Actions), nl,
    nl, write('Solution path:'), nl,
    print_solution(Maze, Actions).