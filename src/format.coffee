moment = require 'moment'
summarize = require './summarize'


renderOpenRow = (min, hoursOfDay, people) ->
  wd = summarize.calcWorkDays(min, hoursOfDay)
  ld = summarize.calcLeftDays(wd, people)
  to = moment(summarize.calcFinishDate(ld)).format('YYYY/MM/DD')
  "#{ld} days (#{wd} days/p, to: #{to})"


renderSummaryInfo = (summaryInfo, hoursOfDay, people) ->
  open = summaryInfo.open.summary
  close = summaryInfo.close.summary

  closeRow = (summary) ->
    wd = summarize.calcWorkDays(summary.spent, hoursOfDay)
    ld = summarize.calcLeftDays(wd, people)
    pace = summarize.calcPace(summary.spent, summary.es)
    st = "#{ld} days (#{wd} days/p, es: #{pace}%)"

  """
  - 残り: #{renderOpenRow(open.es, hoursOfDay, people)}
  - 消化: #{closeRow(close)}
  """


renderDetailInfo = (detailInfo, hoursOfDay, people) ->
  open = detailInfo.open.summary
  close = detailInfo.close.summary

  openRow = (min) ->
    renderOpenRow min, hoursOfDay, people

  closeRow = (min) ->
    wd = summarize.calcWorkDays(min, hoursOfDay)
    ld = summarize.calcLeftDays(wd, people)
    st = "#{ld} days (#{wd} days/p)"

  """
  ### タスク残り時間 (#{hoursOfDay}時間/日, #{people}人換算)
  - 予想: #{openRow(open.es)}
  - 最速: #{openRow(open.es50)}
  - 最悪: #{openRow(open.es90)}

  ### 完了タスク消化時間
  - #{closeRow(close.spent)}

  ### 完了タスク消化ペース
  - 予想: #{summarize.calcPace(close.spent, close.es)}%
  - 最速: #{summarize.calcPace(close.spent, close.es50)}%
  - 最悪: #{summarize.calcPace(close.spent, close.es90)}%
  """

module.exports =
  renderDetailInfo: renderDetailInfo
  renderSummaryInfo: renderSummaryInfo
