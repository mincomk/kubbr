module Kubbr.CodeGen where

import Data.Char (toLower)

import Kubbr.Model

bashCodeGen :: CodeGen
bashCodeGen alias = unlines $ genLine <$> alias
  where
    genLine (shortVal, longVal) = "alias " ++ shortVal ++ "=\"" ++ longVal ++ "\""

fishCodeGen :: CodeGen
fishCodeGen alias = unlines $ genLine <$> alias
  where
    genLine (shortVal, longVal) = "alias " ++ shortVal ++ " \'" ++ longVal ++ "\'"

nushellCodeGen :: CodeGen
nushellCodeGen alias = unlines $ genLine <$> alias
  where
    genLine (shortVal, longVal) = "alias " ++ shortVal ++ " = " ++ longVal

parseLanguage :: String -> Either String CodeGen
parseLanguage s =
    case map toLower s of
        "nu" -> Right nushellCodeGen
        "nushell" -> Right nushellCodeGen
        "bash" -> Right bashCodeGen
        "fish" -> Right fishCodeGen
        _ -> Left $ "Invalid language:" ++ s
