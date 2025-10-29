module Kubbr.Model where

type StringPair = (String, String)
type CodeGen = AliasSet -> String
type AliasSet = [StringPair]

data Options = Options {configFile :: FilePath, outputCodeGen :: CodeGen, outputFile :: FilePath}
data AbbrConfig = AbbrConfig {base :: StringPair, actions :: [StringPair], resources :: [StringPair], extras :: [StringPair]}
    deriving (Show)
