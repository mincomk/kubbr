{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Kubbr.AbbrGen
import Kubbr.CodeGen
import Kubbr.Config
import Kubbr.Model

import qualified Data.Aeson.Key as K
import qualified Data.Aeson.KeyMap as KM
import Data.List (isInfixOf)
import qualified Data.List as L
import qualified Data.Text as T
import Data.Yaml hiding (Parser)
import Test.Tasty
import Test.Tasty.HUnit
import Test.Tasty.QuickCheck as QC

main :: IO ()
main = spec >>= defaultMain

-- Arbitrary instances for QuickCheck
instance {-# OVERLAPPING #-} Arbitrary StringPair where
    arbitrary = do
        s1 <- listOf (elements ['a' .. 'z'])
        s2 <- listOf (elements ['a' .. 'z'])
        return (s1, s2)

instance Arbitrary AbbrConfig where
    arbitrary = do
        base <- arbitrary
        actions <- arbitrary
        resources <- arbitrary
        extras <- arbitrary
        return AbbrConfig{..}

-- Tests
spec :: IO TestTree
spec = return $ testGroup "kubbr tests" [abbrGenTests, codeGenTests, configTests]

abbrGenTests :: TestTree
abbrGenTests =
    testGroup
        "AbbrGen"
        [ -- QC.testProperty "combinePair combines strings correctly" $
          -- \b (a, r) -> combinePair b (a, r) == (fst b ++ fst a ++ fst r, snd b ++ snd a ++ snd r)
          QC.testProperty "generateAliasSet generates all combinations" $
            \cfg ->
                let aliasSet = generateAliasSet cfg
                 in length aliasSet == length (actions cfg) * length (resources cfg) + length (extras cfg)
        ]

codeGenTests :: TestTree
codeGenTests =
    testGroup
        "CodeGen"
        [ QC.testProperty "bashCodeGen produces valid bash aliases" $
            \aliasSet ->
                let code = bashCodeGen aliasSet
                 in all (\(s, l) -> ("alias " ++ s ++ "=\"" ++ l ++ "\"") `isInfixOf` code) aliasSet
        , QC.testProperty "fishCodeGen produces valid fish aliases" $
            \aliasSet ->
                let code = fishCodeGen aliasSet
                 in all (\(s, l) -> ("alias " ++ s ++ " '" ++ l ++ "'") `isInfixOf` code) aliasSet
        , QC.testProperty "nushellCodeGen produces valid nushell aliases" $
            \aliasSet ->
                let code = nushellCodeGen aliasSet
                 in all (\(s, l) -> ("alias " ++ s ++ " = " ++ l) `isInfixOf` code) aliasSet
        , testGroup
            "parseLanguage"
            [ testCase "parses nu correctly" $
                case parseLanguage "nu" of
                    Right _ -> return ()
                    Left e -> assertFailure e
            , testCase "parses nushell correctly" $
                case parseLanguage "nushell" of
                    Right _ -> return ()
                    Left e -> assertFailure e
            , testCase "fails on invalid language" $
                case parseLanguage "invalid" of
                    Right _ -> assertFailure "Should have failed"
                    Left _ -> return ()
            ]
        ]

configTests :: TestTree
configTests =
    testGroup
        "Config"
        [ QC.testProperty "objToPairs converts Object to list of pairs" $
            \(obj :: [(String, String)]) ->
                let filteredObj = uniqueByKey $ filter (\(k, v) -> not $ null k || null v) obj
                    aesonObj = KM.fromList $ map (\(k, v) -> (K.fromText (T.pack k), String (T.pack v))) filteredObj
                    pairs = objToPairs aesonObj
                 in length pairs == length filteredObj && all (`elem` pairs) filteredObj
        ]

uniqueByKey :: [(String, String)] -> [(String, String)]
uniqueByKey = L.nubBy (\(k1, _) (k2, _) -> k1 == k2)
