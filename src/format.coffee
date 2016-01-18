moment = require 'moment'
summarize = require './summarize'


renderOpenRow = (min, hoursOfDay, people) ->
  wd = summarize.calcWorkDays(min, hoursOfDay)
  ld = summarize.calcLeftDays(wd, people)
  to = moment(summarize.calcFinishDate(ld)).format('YYYY/MM/DD')
  "#{ld} days (#{wd} days/people, to: #{to})"

renderAllRow = (min, hoursOfDay, people, startDate, currentFinishDate) ->
  wd = summarize.calcWorkDays(min, hoursOfDay)
  ld = summarize.calcLeftDays(wd, people)
  prevFinishDate = moment(summarize.calcFinishDate(ld, startDate))
  diff = currentFinishDate.diff(moment(prevFinishDate), 'days')
  "#{prevFinishDate.format('YYYY/MM/DD')} (diff: #{diff} days)"


renderSummaryInfo = (summaryInfo, hoursOfDay, people) ->
  open = summaryInfo.open.summary
  close = summaryInfo.close.summary

  closeRow = (summary) ->
    wd = summarize.calcWorkDays(summary.spent, hoursOfDay)
    ld = summarize.calcLeftDays(wd, people)
    pace = summarize.calcPace(summary.spent, summary.es)
    st = "#{ld} days (#{wd} days/people, es: #{pace}%)"

  """
  - 残り: #{renderOpenRow(open.es, hoursOfDay, people)}
  - 消化: #{closeRow(close)}
  """


renderDetailInfo = (detailInfo, hoursOfDay, people, project) ->
  open = detailInfo.open.summary
  close = detailInfo.close.summary
  all = detailInfo.all.summary

  startDate = project.startDate or null
  if not startDate and detailInfo.sprints.length > 0 and detailInfo.sprints[0].sprint.due
    startDate = summarize.getStartDate detailInfo.sprints[0].sprint, project.sprintPeriod or 7

  allRow = (prevMin, currentMin) ->
    wd = summarize.calcWorkDays(currentMin, hoursOfDay)
    ld = summarize.calcLeftDays(wd, people)
    currentFinishDate = moment(summarize.calcFinishDate(ld))
    renderAllRow prevMin, hoursOfDay, people, startDate, currentFinishDate

  openRow = (min) ->
    renderOpenRow min, hoursOfDay, people

  closeRow = (min) ->
    wd = summarize.calcWorkDays(min, hoursOfDay)
    ld = summarize.calcLeftDays(wd, people)
    st = "#{ld} days (#{wd} days/people)"

  getProgress = (close, all) ->
    parseInt(1000 * close / all, 10) / 10

  """
  ### タスク残り時間 (#{hoursOfDay}時間/日, #{people}人換算)
  - 予想: #{openRow(open.es)}
  - 最速: #{openRow(open.es50)}
  - 最悪: #{openRow(open.es90)}

  ### 完了タスク消化時間
  - #{closeRow(close.spent)}

  ### タスク消化率
  - 予想: #{getProgress(close.es, all.es)}%
  - 最速: #{getProgress(close.es50, all.es50)}%
  - 最悪: #{getProgress(close.es90, all.es90)}%

  ### 完了タスク消化ペース
  - 予想: #{summarize.calcPace(close.spent, close.es)}%
  - 最速: #{summarize.calcPace(close.spent, close.es50)}%
  - 最悪: #{summarize.calcPace(close.spent, close.es90)}%

  ### 初回終了予想日 (開始日: #{moment(startDate).format('YYYY/MM/DD')})
  - 予想: #{allRow(all.es, open.es)}
  - 最速: #{allRow(all.es50, open.es50)}
  - 最悪: #{allRow(all.es90, open.es90)}
  """

module.exports =
  renderDetailInfo: renderDetailInfo
  renderSummaryInfo: renderSummaryInfo
