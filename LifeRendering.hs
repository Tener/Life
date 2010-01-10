module LifeRendering where

import Graphics.UI.GLUT
import Control.Monad (mapM_)

import LifeBool
import Colors
import ListUtils
import LifeStructures (toNestedRaw, state)

type Point = (Integer, Integer)

renderSnapshot :: HealthSnapshot -> IO ()
renderSnapshot snapshot = renderInner points
  where
    nestedRaw = toNestedRaw snapshot
    width = (length $ head nestedRaw) - 1
    height = (length nestedRaw) - 1
    points = [(fromIntegral x, fromIntegral y) | x <- [0..width], y <- [0..height]]
    health = map (\(x, y) -> nestedAt x y nestedRaw) points
    pointsHealth = zip points health

    renderInner :: [Point] -> IO ()
    renderInner points = do
      color white
      renderPrimitive Quads $ mapM_ renderPoint pointsHealth

renderPoint :: (Point, Health) -> IO ()
renderPoint ((x, y), True) = point x y
renderPoint _ = return ()

point :: Integer -> Integer -> IO ()
point x y = do
  v x  y  0
  v x  y' 0
  v x' y' 0
  v x' y  0
  where
    x' = x + 1
    y' = y + 1

v x y z = vertex $ Vertex3 (f x) (f y) (f z)
  where
    f = fromIntegral :: Integer -> GLdouble
