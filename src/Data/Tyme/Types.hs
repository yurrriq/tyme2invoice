{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}


module Data.Tyme.Types where


import           Data.Aeson
import           Data.Text
import           GHC.Generics


data Time =
  Time { notes           :: Text
       , rate            :: Double
       , timeEnd         :: Text -- TODO: refine this type
       , category        :: Text
       , roundingMinutes :: Int
       , task            :: Text
       , roundingMethod  :: Text
       , timeStart       :: Text
       , duration        :: Int
       , sum             :: Double
       , subtask         :: Text
       , project         :: Text
       }


instance ToJSON Time where
  toJSON t =
    object [ "notes" .= notes t ]


instance FromJSON Time where
  parseJSON (Object v) = Time <$>
                         v .: "notes" <*>
                         v .: "rate" <*>
                         v .: "timeEnd" <*>
                         v .: "category" <*>
                         v .: "roundingMinutes" <*>
                         v .: "task" <*>
                         v .: "roundingMethod" <*>
                         v .: "timeStart" <*>
                         v .: "duration" <*>
                         v .: "sum" <*>
                         v .: "subtask" <*>
                         v .: "project"
  -- parseJSON _ = empty
