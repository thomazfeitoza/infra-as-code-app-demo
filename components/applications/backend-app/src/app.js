const express = require('express')
const app = express()
const logger = require('pino')()
const os = require('os')
const cors = require('cors')

const port = +process.env.SERVER_PORT

app.use(cors())

app.use((req, res, next) => {
  logger.info(`${req.method} ${req.path} - ${req.ip}`)
  next()
})

app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'OK'
  })
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