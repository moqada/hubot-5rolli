summarizer = require '5rolli-time-summarizer'
StoryClient = require '5rolli-story-client'
moment = require 'moment'

storiesToSummary = (stories) ->
  return summarizer stories.map (s) -> s.time

calcWorkDays = (minutes, hoursOfDay) ->
  minutesOfDay = hoursOfDay * 60
  days = minutes / minutesOfDay
  parseInt(days * 10, 10) / 10

calcLeftDays = (days, people) ->
  parseInt(10 * days / people, 10) / 10

calcFinishDate = (days) ->
  moment().add(Math.ceil(days / 5), 'weeks').endOf('isoweek').toDate()

minToHours = (minutes) ->
  hours = moment.duration(minutes, 'minutes').asHours()
  parseInt(hours * 10, 10) / 10

calcPace = (spent, es) ->
  parseInt(100 * spent / es, 10)

getSummaryInfo = (stories) ->
  opens = (s for s in stories when s.status in ['open', 'waiting'])
  closes = (s for s in stories when s.status is 'close')
  return {
    open:
      summary: storiesToSummary(opens)
      stories: opens
    close:
      summary: storiesToSummary(closes)
      stories: closes
  }

getDetailInfo = (stories) ->
  summaryInfo = getSummaryInfo stories
  perLists = getStoriesPerLists summaryInfo.close.stories
  Object.assign({}, summaryInfo, {
    sprints: perLists
  })

getStoriesPerLists = (stories) ->
  perLists = {}
  stories.forEach (story) ->
    perLists[story.sprint.name] = (perLists[story.sprint.name] or []).concat([story])
  Object.keys(perLists).map (key) ->
    {
      sprint: perLists[key][0].sprint
      stories: perLists[key]
      summary: storiesToSummary perLists[key]
    }
  .sort (a, b) -> a.sprint.due - b.sprint.due

fetchStories = (token, key, boardId) ->
  client = new StoryClient(token, key, boardId)
  client.getStories().then (stories) -> stories.filter (s) -> s.type is 'story'


module.exports =
  summary: (token, key, boardId) ->
    fetchStories(token, key, boardId).then getSummaryInfo
  detail: (token, key, boardId) ->
    fetchStories(token, key, boardId).then getDetailInfo
  calcFinishDate: calcFinishDate
  calcPace: calcPace
  calcLeftDays: calcLeftDays
  calcWorkDays: calcWorkDays
