{-# LANGUAGE OverloadedStrings #-}
module Database.DIME.Server.HttpError
    (badRequest, badRequest', notFound, badMethod, internalServerError, ok,

     contentTypeJson
    ) where

import Control.Monad.IO.Class

import Network.Wai
import Network.HTTP.Types
import Network.HTTP.Types.Header

--import Data.ByteString.Lazy.Char8 ()
import qualified Data.ByteString.Lazy.Char8 as LBS
import Data.Text

notFound :: MonadIO m => m Response
notFound = return $ responseLBS status404 [("Content-Type", "text/plain")] "Not Found"

badRequest :: MonadIO m => m Response
badRequest = badRequest' "Bad Request"

badRequest' :: MonadIO m => LBS.ByteString -> m Response
badRequest' lbs = return $ responseLBS status400 [("Content-Type", "text/plain")] lbs

badMethod :: MonadIO m => m Response
badMethod = liftIO $ return $ responseLBS status401 [("Content-Type", "text/plain")] "Bad Method"

internalServerError :: MonadIO m => m Response
internalServerError = liftIO $ return $ responseLBS status500 [("Content-Type", "text/plain")] "Internal Server Error"

ok :: MonadIO m => ResponseHeaders -> LBS.ByteString -> m Response
ok headers lbs = return $ responseLBS status200 headers (LBS.append lbs (LBS.pack "\n"))

contentTypeJson :: Header
contentTypeJson = (hContentType, "text/json")