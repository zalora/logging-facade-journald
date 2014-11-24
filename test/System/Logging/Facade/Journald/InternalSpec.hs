{-# LANGUAGE OverloadedStrings #-}

module System.Logging.Facade.Journald.InternalSpec where


import           Data.HashMap.Strict
import           Data.Monoid
import           Test.Hspec

import           System.Logging.Facade.Journald.Internal
import           System.Logging.Facade.Types


spec :: Spec
spec = do
  describe "logRecordToJournalFields" $ do
    let record = LogRecord {
          logRecordLevel = ERROR,
          logRecordLocation = Nothing,
          logRecordMessage = "foo"
        }
        expected = fromList $
          ("MESSAGE", "foo") :
          ("PRIORITY", "3") :
          []
    it "maps LogRecords to JournalFields" $ do
      logRecordToJournalFields record `shouldBe` expected

    context "when LogRecord has a location" $ do
      let location = Location {
            locationPackage = "foo",
            locationModule = "Main",
            locationFile = "./foo/Main.hs",
            locationLine = 42,
            locationColumn = 23
          }
          locationFields = fromList $
            ("CODE_FILE", "./foo/Main.hs") :
            ("CODE_LINE", "42") :
            []
      it "includes the location as user journal fields" $ do
        logRecordToJournalFields record{logRecordLocation = Just location} `shouldBe`
          expected <> locationFields
