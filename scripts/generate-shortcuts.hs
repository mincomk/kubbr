#! /usr/bin/env cabal
{- cabal:
build-depends: base, process
-}

import System.Process (callCommand)

data Language = Language
    { lName :: String
    , lFileExtension :: String
    }

data ShortcutGenConfig = ShortcutGenConfig
    { sKubbrBinary :: String
    , sFileName :: String
    }

genCommandForLanguage :: ShortcutGenConfig -> Language -> String
genCommandForLanguage
    ShortcutGenConfig{sKubbrBinary = kubbrBinary, sFileName = fileName}
    Language{lName = lang, lFileExtension = langExt} =
        unwords [kubbrBinary, "--language", lang, "--output", fileName ++ "." ++ langExt]

runCommands :: ShortcutGenConfig -> [Language] -> IO ()
runCommands cfg langs = mapM_ callCommand $ genCommandForLanguage cfg <$> langs

defaultConfig :: ShortcutGenConfig
defaultConfig = ShortcutGenConfig{sKubbrBinary = "kubbr", sFileName = "shortcuts/kube"}

idLang :: String -> Language
idLang s = Language s s

defaultLangs = [idLang "bash", idLang "nu", idLang "fish"]

main :: IO ()
main = runCommands defaultConfig defaultLangs
