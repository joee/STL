import qualified Data.Text.IO as T
import           Options.Applicative
import           Data.Attoparsec.Text (parseOnly)
import qualified Data.ByteString.Lazy as BS
import           Data.ByteString.Lazy.Builder (toLazyByteString)

import           Graphics.Formats.STL

data Opts = Opts String

opts = Opts <$> argument Just (metavar "FILENAME" <> help "Input STL file")

copySTL :: Opts -> IO ()
copySTL (Opts fn) = do
    i <- T.readFile fn
    case parseOnly stlParser i of
        Left error -> do
            putStrLn $ "Encountered error reading "++fn
            putStrLn error
        Right stl -> do
            BS.writeFile "pretty.stl" . toLazyByteString . textSTL $ stl
            putStrLn "wrote output to pretty.stl"

main :: IO ()
main = execParser withHelp >>= copySTL where
  withHelp = info (helper <*> opts)
               ( fullDesc <> progDesc "pretty print FILENAME"
                 <> header "indent-stl - a test for STL library" )
