# Description
#   Listing SINCHOKU summary of 5ROLLI projects.
#
# Commands:
#   hubot 5rolli - List Summary of project
#   hubot 5rolli info [project] - List Detail of project
#
# Configuration:
#   HUBOT_5ROLLI_PROJECTS - Set projects info by JSON string
#   HUBOT_5ROLLI_TRELLO_API_KEY - Set Trello API Key
#   HUBOT_5ROLLI_TRELLO_API_TOKEN - Set Trello API Token
#   HUBOT_5ROLLI_WORK_HOURS - Set work hours of a day
#
# Author:
#   moqada <moqada@gmail.com>
summarize = require '../summarize'
format = require '../format'

PREFIX = 'HUBOT_5ROLLI_'
TRELLO_API_KEY = process.env["#{PREFIX}TRELLO_API_KEY"]
TRELLO_API_TOKEN = process.env["#{PREFIX}TRELLO_API_TOKEN"]
PROJECTS = JSON.parse process.env["#{PREFIX}PROJECTS"] or '{}'
WORK_HOURS = process.env["#{PREFIX}WORK_HOURS"] or 5


module.exports = (robot) ->

  robot.respond /5rolli$/i, (res) ->
    sendSummary res, PROJECTS, summarize.summary, format.renderSummaryInfo

  robot.respond /5rolli info(?:\s+(.*))?$/i, (res) ->
    projectNames = res.match.slice(1)[0]
    projects = PROJECTS
    if projectNames
      names = projectNames.toLowerCase().split(' ').filter (name) -> name
      projects = projects.filter (project) ->
        names.indexOf(project.name.toLowerCase()) >= 0
    sendSummary res, projects, summarize.detail, format.renderDetailInfo

  sendSummary = (res, projects, summaryFunc, renderFunc) ->
    promises = projects.map (project) ->
      summaryFunc(TRELLO_API_TOKEN, TRELLO_API_KEY, project.id)
        .then (summary) ->
          """
          ## #{project.name}
          #{renderFunc(summary, WORK_HOURS, project.people)}
          """
    Promise.all(promises).then (results) ->
      res.send results.join('\n\n')
    .catch (e) ->
      console.error e
      res.send 'Error'
