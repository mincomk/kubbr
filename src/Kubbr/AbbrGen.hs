module Kubbr.AbbrGen where

import Kubbr.Model

combinePair :: StringPair -> (StringPair, StringPair) -> StringPair
combinePair b ((actionShort, actionLong), (resShort, resLong)) = (shortVal, longVal)
  where
    shortVal = fst b ++ actionShort ++ resShort
    longVal = unwords [snd b, actionLong, resLong]

combinePairNoResource :: StringPair -> StringPair -> StringPair
combinePairNoResource b (actionShort, actionLong) = (shortVal, longVal)
  where
    shortVal = fst b ++ actionShort
    longVal = unwords [snd b, actionLong]

generateAliasSet :: AbbrConfig -> AliasSet
generateAliasSet cfg = resourcePairs ++ extraPairs (base cfg) (extras cfg) ++ noResourcePairs ++ basePairs
  where
    -- kgp: kubectl get po
    resourcePairs = combinePair (base cfg) <$> [(a, r) | a <- actions cfg, r <- resources cfg]

    -- kg: kubectl get
    noResourcePairs = combinePairNoResource (base cfg) <$> actions cfg

    -- basePair
    basePairs = [base cfg]

    -- e.g. kpf: kubectl port-forward
    extraPairs (baseShort, baseLong) pairs = [(baseShort ++ shortExtra, baseLong ++ " " ++ longExtra) | (shortExtra, longExtra) <- pairs]
