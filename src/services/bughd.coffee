moment = require 'moment-timezone'

util = require '../util'

_receiveWebhook = ({body}) ->
  payload = body
  return unless (payload.user_name == 'BugHD')
  info = payload.datas[0]
  title = "#{info.project_name} #{info.project_version}"
  text = ""
  text += "TITLE: #{info.issue_title}\n" if info.issue_title
  text += "STACK: #{info.issue_stack}\n" if info.issue_stack
  text += "CREATED_AT: #{moment(Number(info.created_at) * 1000).tz('Asia/Shanghai').format('YYYY-MM-DD hh:mm:ss')}" if info.created_at

  message =
    attachments: [
      category: 'quote'
      data:
        title: title
        text: text
        redirectUrl: if info.uri?.length then info.uri else undefined
    ]

  message

module.exports = ->

  @title = 'BugHD'

  @template = 'webhook'

  @summary = util.i18n
    zh: '实时收集应用崩溃信息，定位应用崩溃原因。'
    en: 'BugHD is a real-time crashes collection tool, it can find out the reasons of app crashes.'

  @description = util.i18n
    zh: 'BugHD 可实时收集应用崩溃信息，帮你定位应用崩溃原因。可提供详尽的崩溃分析报告，快速地定位崩溃到代码行。'
    en: 'BugHD is a real-time crashes collection tool, it can find out the reasons of app crashes.
It also provides detailed reports of crash analysis, which can help you find out the wrong lines of code quickly.'

  @iconUrl = util.static 'images/icons/bughd@2x.png'

  @_fields.push
    key: 'webhookUrl'
    type: 'text'
    readonly: true
    description: util.i18n
      zh: '复制 web hook 地址到你的 BugHD 中使用。'
      en: 'Copy this web hook to your BugHD account to use it.'

  @registerEvent 'service.webhook', _receiveWebhook
