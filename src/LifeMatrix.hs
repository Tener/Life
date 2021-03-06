module LifeMatrix (randomGame, LifeSnapshot, Health (Alive, Dead), toListWithPos) where

-- Libraries
import Control.Monad

-- Imports
import ArrayMatrix
import RandomList
import Random

type LifeSnapshot = ArrayMatrix Health

data Health = Alive | Dead deriving (Eq, Show)

randomGame :: (Integral i) => i -> IO [LifeSnapshot]
randomGame = liftM (iterate nextSnapshot) . randomSnapshot

randomSnapshot :: Integral i => i -> IO LifeSnapshot
randomSnapshot size = do
  gen <- newStdGen
  return $ fromRows $ randomRowsN gen [Alive, Dead] size size

nextSnapshot :: LifeSnapshot -> LifeSnapshot
nextSnapshot = neighbourMap nextCell

nextCell :: Health -> [Health] -> Health
nextCell cell = nextState cell . countHealth

countHealth :: [Health] -> Integer
countHealth = foldr f 0
  where
    f Alive n = n + 1
    f Dead n = n

nextState :: Health -> Integer -> Health
nextState Alive neighbours
  | neighbours < 2 = Dead
  | neighbours > 3 = Dead
  | otherwise      = Alive

nextState Dead neighbours
  | neighbours == 3 = Alive
  | otherwise       = Dead

instance Show LifeSnapshot
  where
    show l = unlines (map (map f) (toRows l))
      where
        f Alive = 'x'
        f Dead  = ' '

-- This probably doesn't work as I have no idea what I'm doing... But it typechecks ^___^
instance Read LifeSnapshot
  where
    readsPrec _ str = [(result, str)]
      where
        result = fromRows rows
        rows = map (map f) l
        l = lines str
        f 'x' = Alive
        f ' ' = Dead
