import Data.List ((\\), sort)

type Board = [[Int]]

inputBoard :: Board
inputBoard = 
    [[5,3,0, 0,7,0, 0,0,0],
     [6,0,0, 1,9,5, 0,0,0],
     [0,9,8, 0,0,0, 0,6,0],
     [8,0,0, 0,6,0, 0,0,3],
     [4,0,0, 8,0,3, 0,0,1],
     [7,0,0, 0,2,0, 0,0,6],
     [0,6,0, 0,0,0, 2,8,0],
     [0,0,0, 4,1,9, 0,0,5],
     [0,0,0, 0,8,0, 0,7,9]]

solvedBoard :: Board
solvedBoard = 
    [[5,3,4, 6,7,8, 9,1,2],
     [6,7,2, 1,9,5, 3,4,8],
     [1,9,8, 3,4,2, 5,6,7],
     [8,5,9, 7,6,1, 4,2,3],
     [4,2,6, 8,5,3, 7,9,1],
     [7,1,3, 9,2,4, 8,5,6],
     [9,6,1, 5,3,7, 2,8,4],
     [2,8,7, 4,1,9, 6,3,5],
     [3,4,5, 2,8,6, 1,7,9]]

type Coords = (Int,Int)
type BoardElement = (Coords,Int)

inputBoardElements :: [BoardElement]
inputBoardElements = 
    [((0,0),5),((0,1),3),((0,4),7),((1,0),6),((1,3),1),((1,4),9),((1,5),5),
     ((2,1),9),((2,2),8),((2,7),6),((3,0),8),((3,4),6),((3,8),3),((4,0),4),
     ((4,3),8),((4,5),3),((4,8),1),((5,0),7),((5,4),2),((5,8),6),((6,1),6),
     ((6,6),2),((6,7),8),((7,3),4),((7,4),1),((7,5),9),((7,8),5),((8,4),8),
     ((8,7),7),((8,8),9)]

inputBoardEmpty :: [Coords]
inputBoardEmpty = 
    [(0,2),(0,3),(0,5),(0,6),(0,7),(0,8),(1,1),(1,2),(1,6),(1,7),(1,8),
     (2,0),(2,3),(2,4),(2,5),(2,6),(2,8),(3,1),(3,2),(3,3),(3,5),(3,6),
     (3,7),(4,1),(4,2),(4,4),(4,6),(4,7),(5,1),(5,2),(5,3),(5,5),(5,6),
     (5,7),(6,0),(6,2),(6,3),(6,4),(6,5),(6,8),(7,0),(7,1),(7,2),(7,6),
     (7,7),(8,0),(8,1),(8,2),(8,3),(8,5),(8,6)]

solvedBoardElements :: [BoardElement]
solvedBoardElements = 
    [((0,0),5),((0,1),3),((0,2),4),((0,3),6),((0,4),7),((0,5),8),((0,6),9),
     ((0,7),1),((0,8),2),((1,0),6),((1,1),7),((1,2),2),((1,3),1),((1,4),9),
     ((1,5),5),((1,6),3),((1,7),4),((1,8),8),((2,0),1),((2,1),9),((2,2),8),
     ((2,3),3),((2,4),4),((2,5),2),((2,6),5),((2,7),6),((2,8),7),((3,0),8),
     ((3,1),5),((3,2),9),((3,3),7),((3,4),6),((3,5),1),((3,6),4),((3,7),2),
     ((3,8),3),((4,0),4),((4,1),2),((4,2),6),((4,3),8),((4,4),5),((4,5),3),
     ((4,6),7),((4,7),9),((4,8),1),((5,0),7),((5,1),1),((5,2),3),((5,3),9),
     ((5,4),2),((5,5),4),((5,6),8),((5,7),5),((5,8),6),((6,0),9),((6,1),6),
     ((6,2),1),((6,3),5),((6,4),3),((6,5),7),((6,6),2),((6,7),8),((6,8),4),
     ((7,0),2),((7,1),8),((7,2),7),((7,3),4),((7,4),1),((7,5),9),((7,6),6),
     ((7,7),3),((7,8),5),((8,0),3),((8,1),4),((8,2),5),((8,3),2),((8,4),8),
     ((8,5),6),((8,6),1),((8,7),7),((8,8),9)]

main :: IO ()
main = print (sudoku inputBoard == solvedBoard)
   
sudoku :: Board -> Board
sudoku b = let (i, j) = toElements b
               k = sudokuElements [i] j
               in fromElements (sort (head k))

sudokuElements :: [[BoardElement]] -> [Coords] -> [[BoardElement]]
sudokuElements be [] = be
sudokuElements be (c:cs) = let passBoards = [[(i,j):k | i <- [c] , j <- validVals k c] | k <- be] in sudokuElements (concat passBoards) cs


validVals :: [BoardElement] -> Coords -> [Int]
validVals [] _ = []
validVals be c = let row = map snd (filter (\x -> (fst (fst x)) == fst c) be)
                     col = map snd (filter (\x -> (snd (fst x)) == snd c) be)
                     box = map snd (filter (\x -> ((fst (fst x) `div` 3 == (fst c) `div` 3) && (snd (fst x) `div` 3 == (snd c) `div` 3))) be)
                     in [1..9] \\ (row ++ col ++ box)


toElements :: Board -> ([BoardElement],[Coords])
toElements [] = ([], [])
toElements (x : xs) = (fst (helperToElements x (8 - (length xs)) 0) ++ fst (toElements xs) , snd (helperToElements x (8 - (length xs)) 0) ++ snd (toElements xs))


helperToElements :: [Int] -> Int -> Int -> ([BoardElement], [Coords])
helperToElements [] _ _ = ([], [])
helperToElements (x:xs) row col | x == 0 = (fst (helperToElements xs row (col + 1)) , (row, col) : snd (helperToElements xs row (col + 1)))
                                | otherwise = (((row,col),x) : fst (helperToElements xs row (col + 1)), snd (helperToElements xs row (col + 1)))


fromElements :: [BoardElement] -> Board
fromElements [] = []
fromElements ls = let (fst9, other) = splitAt 9 ls in (map snd fst9) : fromElements other

