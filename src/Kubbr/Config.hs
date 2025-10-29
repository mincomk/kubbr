{-# LANGUAGE OverloadedStrings #-}

module Kubbr.Config where

import Kubbr.Model

import qualified Data.Aeson.Key as K
import qualified Data.Aeson.KeyMap as KM
import Data.Char (toLower)
import qualified Data.Text as T
import Data.Yaml hiding (Parser)

objToPairs :: Object -> [StringPair]
objToPairs = map (\(k, v) -> (T.unpack (K.toText k), extractString v)) . KM.toList
  where
    extractString (String t) = T.unpack t
    extractString _ = error "Expected a string value in YAML object"

instance FromJSON AbbrConfig where
    parseJSON = withObject "AbbrConfig" $ \v -> do
        baseObj <- v .: "base"
        basePair <-
            withObject
                "base"
                ( \o -> do
                    cmd <- o .: "command"
                    shortVal <- o .: "short"
                    return (shortVal, cmd)
                )
                baseObj
        actionsObj <- v .: "actions"
        resourcesObj <- v .: "resources"
        extrasObj <- v .: "extras"
        return $
            AbbrConfig
                { base = basePair
                , actions = objToPairs actionsObj
                , resources = objToPairs resourcesObj
                , extras = objToPairs extrasObj
                }

loadAbbrConfig :: FilePath -> IO (Either ParseException AbbrConfig)
loadAbbrConfig = decodeFileEither
