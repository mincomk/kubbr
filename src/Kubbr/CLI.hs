module Kubbr.CLI where

import Kubbr.CodeGen (bashCodeGen, parseLanguage)
import Kubbr.Model

import Options.Applicative

optionsParser :: Parser Options
optionsParser =
    Options
        <$> strArgument (metavar "CONFIG_FILE" <> help "Input file" <> value "abbr.yml" <> showDefault)
        <*> option (eitherReader parseLanguage) (long "language" <> short 'l' <> metavar "LANG" <> help "Output language: bash, nushell" <> value bashCodeGen)
        <*> strOption (long "output" <> short 'o' <> metavar "OUTPUT" <> help "Output file")

optsInfo :: ParserInfo Options
optsInfo =
    info
        (optionsParser <**> helper)
        (fullDesc <> progDesc "Haskell kubectl alias generator")
