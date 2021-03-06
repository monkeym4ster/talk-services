Promise = require 'bluebird'
marked = require 'marked'

util = require '../util'

###*
 * Define handler when receive incoming webhook from jenkins
 * @param  {Object}   req      Express request object
 * @param  {Object}   res      Express response object
 * @param  {Function} callback
 * @return {Promise}
###
_receiveWebhook = ({body}) ->
  payload = body or {}

  {content, authorName, title, text, redirectUrl, imageUrl} = payload

  throw new Error("Title and text can not be empty") unless title?.length or text?.length or content?.length

  message =
    body: content
    authorName: authorName
    attachments: [
      category: 'quote'
      data:
        title: title
        text: text
        redirectUrl: redirectUrl
        imageUrl: imageUrl
    ]

  message

module.exports = ->
  @title = 'Jenkins'

  @template = 'webhook'

  @summary = util.i18n
    zh: '开源持续集成服务'
    en: 'An open source continuous integration server.'

  @description = util.i18n
    zh: 'Jenkins 是一个开源持续集成服务。它提供超过 800 个插件来支持各种项目的构建和测试。'
    en: 'Jenkins CI is the leading open-source continuous integration server. It provides over 800 plugins to support building and testing virtually any project.'

  @iconUrl = util.static 'images/icons/jenkins@2x.png'

  @_fields.push
    key: 'webhookUrl'
    type: 'text'
    readOnly: true
    description: util.i18n
      zh: '复制 web hook 地址到你的 Jenkins 当中使用。你也可以在管理界面当中找到这个 web hook 地址。'
      en: 'Copy this web hook to your Jenkins server to use it. You may also find this url in the manager tab.'

  # Apply function on `webhook` event
  @registerEvent 'service.webhook', _receiveWebhook
