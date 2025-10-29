module Kubbr.AbbrGen where

import Kubbr.Model

combinePair :: StringPair -> (StringPair, StringPair) -> StringPair
combinePair b ((actionShort, actionLong), (resShort, resLong)) = (shortVal, longVal)
  where
    shortVal = fst b ++ actionShort ++ resShort
    longVal = snd b ++ actionLong ++ resLong

generateAliasSet :: AbbrConfig -> AliasSet
generateAliasSet cfg = resourcePairs ++ extraPairs (base cfg) (extras cfg)
  where
    extraPairs (baseShort, baseLong) pairs = [(baseShort ++ shortExtra, baseLong ++ longExtra) | (shortExtra, longExtra) <- pairs]
    resourcePairs = combinePair (base cfg) <$> [(a, r) | a <- actions cfg, r <- resources cfg]
