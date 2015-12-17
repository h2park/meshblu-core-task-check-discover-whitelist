WhitelistManager = require 'meshblu-core-manager-whitelist'
http             = require 'http'

class VerifyDiscoverWhitelist

  constructor: ({datastore, @whitelistManager, uuidAliasResolver}) ->
    @whitelistManager ?= new WhitelistManager {datastore, uuidAliasResolver}

  do: (job, callback) =>
    {toUuid, fromUuid, responseId, auth} = job.metadata
    fromUuid ?= auth.uuid
    @whitelistManager.canDiscover {fromUuid, toUuid}, fromUuid, (error, canDiscover) =>
      return @sendResponse responseId, 500, callback if error?
      return @sendResponse responseId, 403, callback unless canDiscover
      @sendResponse responseId, 204, callback

  sendResponse: (responseId, code, callback) =>
    callback null,
      metadata:
        responseId: responseId
        code: code
        status: http.STATUS_CODES[code]

module.exports = VerifyDiscoverWhitelist
