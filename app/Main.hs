module Main where

import Kubbr.Prelude
import Options.Applicative

main :: IO ()
main = do
    opts <- execParser optsInfo
    config <- loadAbbrConfig $ configFile opts
    case config of
        Left e -> do
            putStrLn $ "Error: " ++ show e
        Right cfg -> do
            let aliasSet = generateAliasSet cfg
            let code = outputCodeGen opts aliasSet
            putStrLn code
