# hubot-5rolli

[![Greenkeeper badge](https://badges.greenkeeper.io/moqada/hubot-5rolli.svg)](https://greenkeeper.io/)

[![NPM version][npm-image]][npm-url]
[![NPM downloads][npm-download-image]][npm-download-url]
[![Build Status][travis-image]][travis-url]
[![Dependency Status][daviddm-image]][daviddm-url]
[![DevDependency Status][daviddm-dev-image]][daviddm-dev-url]
[![License][license-image]][license-url]

[5ROLLI](https://github.com/tongariboyz/5rolli) for Hubot

## Installation

```
npm install hubot-5rolli --save
```

Then add **hubot-5rolli** to your `external-scripts.json`:

```json
["hubot-5rolli"]
```

## Sample Interaction

```
user> @hubot 5rolli
Hubot>
## test-project
- 残り: 29.5 days (38.4 days/people, to: 2016/03/06)
- 消化: 31.2 days (40.6 days/people, es: 247%)

user> @hubot 5rolli info test-project
hubot>
## test-project

### タスク残り時間 (5時間/日, 1.3人換算)
- 予想: 29.5 days (38.4 days/people, to: 2016/03/06)
- 最速: 21 days (27.4 days/people, to: 2016/02/28)
- 最悪: 65.4 days (85.1 days/people, to: 2016/05/01)

### 完了タスク消化時間
- 31.2 days (40.6 days/people)

### タスク消化率
- 予想: 31.4%
- 最速: 32.7%
- 最悪: 25.9%

### 完了タスク消化ペース
- 予想: 247%
- 最速: 303%
- 最悪: 136%

### 初回終了予想日 (開始日: 2015/11/27)
- 予想: 2016/01/31 (diff: 35 days)
- 最速: 2016/01/17 (diff: 42 days)
- 最悪: 2016/04/03 (diff: 28 days)
```


## Commands

```
hubot 5rolli - List Summary of project
hubot 5rolli info [project] - List Detail of project
```

## Configurations

```
HUBOT_5ROLLI_PROJECTS - Set projects info by JSON string
HUBOT_5ROLLI_TRELLO_API_KEY - Set Trello API Key
HUBOT_5ROLLI_TRELLO_API_TOKEN - Set Trello API Token
HUBOT_5ROLLI_WORK_HOURS - Set work hours of a day
```


[npm-url]: https://www.npmjs.com/package/hubot-5rolli
[npm-image]: https://img.shields.io/npm/v/hubot-5rolli.svg?style=flat-square
[npm-download-url]: https://www.npmjs.com/package/hubot-5rolli
[npm-download-image]: https://img.shields.io/npm/dt/hubot-5rolli.svg?style=flat-square
[travis-url]: https://travis-ci.org/moqada/hubot-5rolli
[travis-image]: https://img.shields.io/travis/moqada/hubot-5rolli.svg?style=flat-square
[daviddm-url]: https://david-dm.org/moqada/hubot-5rolli
[daviddm-image]: https://img.shields.io/david/moqada/hubot-5rolli.svg?style=flat-square
[daviddm-dev-url]: https://david-dm.org/moqada/hubot-5rolli#info=devDependencies
[daviddm-dev-image]: https://img.shields.io/david/dev/moqada/hubot-5rolli.svg?style=flat-square
[license-url]: http://opensource.org/licenses/MIT
[license-image]: https://img.shields.io/npm/l/hubot-5rolli.svg?style=flat-square
