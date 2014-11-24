
-- | Implements a journald back-end for
-- <https://hackage.haskell.org/package/logging-facade logging-facade>.

module System.Logging.Facade.Journald where


import           System.Logging.Facade.Sink
import           Systemd.Journal

import           System.Logging.Facade.Journald.Internal


-- | Use this with `setLogSink` to switch logging to journald.
journaldLogSink :: LogSink
journaldLogSink = sendJournalFields . logRecordToJournalFields
