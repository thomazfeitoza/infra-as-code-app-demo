const express = require('express')
const app = express()
const os = require('os')
const cors = require('cors')
const logger = require('pino')({
  messageKey: 'message',
  name: 'backend-app',
})

const port = +process.env.SERVER_PORT

app.use(cors())

app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'OK'
  })
})

app.use((req, res, next) => {
  res.reqStartedAt = Date.now()

  res.on('finish', function () {
    const latency = Date.now() - res.reqStartedAt
    logger.info(`${req.method} ${req.path} - ${res.statusCode} ${res.statusMessage} - ${latency}ms`)
  })

  next()
})

app.get('/api/me', (req, res) => {
  res.status(200).json({
    id: 1001,
    name: 'James Hetfield',
    age: 57
  })
})

app.get('/api/hostname', (req, res) => {
  res.status(200).json({
    hostname: os.hostname()
  })
})

app.get('*', function (req, res) {
  res.status(404).json({
    message: 'Not found'
  })
})

app.listen(port, () => {
  logger.info(`Started application at port ${port}`)
})