{-# LANGUAGE OverloadedStrings #-}

module System.Logging.Facade.Journald.Internal where


import           Data.HashMap.Strict
import           Data.Monoid
import           Data.String
import qualified Data.Text.Encoding          as Text
import           System.Logging.Facade.Types
import           Systemd.Journal


logRecordToJournalFields :: LogRecord -> JournalFields
logRecordToJournalFields record =
  locationFields <>
  priority (logLevelToPriority (logRecordLevel record)) <>
  message (fromString (logRecordMessage record))
 where
  locationFields =
    fromList $ maybe [] toLocationFields (logRecordLocation record)
  toLocationFields loc =
    ("CODE_FILE", encodeUtf8 (locationFile loc)) :
    ("CODE_LINE", fromString (show (locationLine loc))) :
    []

  encodeUtf8 = Text.encodeUtf8 . fromString

logLevelToPriority :: LogLevel -> Priority
logLevelToPriority l = case l of
  TRACE -> Debug
  DEBUG -> Debug
  INFO -> Info
  WARN -> Warning
  ERROR -> Error
