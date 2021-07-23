const express = require('express')
const app = express()
const os = require('os')
const cors = require('cors')
const logger = require('pino')({
  messageKey: 'message',
  name: 'backend-app',
})

const { getCars, getCarById, getRandomCar } = require('./cars');

const port = +process.env.SERVER_PORT

app.use(cors())

app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'OK'
  })
})

app.use((req, res, next) => {
  res.reqStartedAt = Date.now()
  res.setHeader('X-Response-Hostname', os.hostname())

  res.on('finish', function () {
    const latency = Date.now() - res.reqStartedAt
    logger.info(`${req.method} ${req.path} - ${res.statusCode} ${res.statusMessage} - ${latency}ms`)
  })

  next()
})

app.get('/api/cars', (req, res) => {
  res.status(200).json(
    getCars()
  )
})


app.get('/api/cars/:id', (req, res) => {
  const car = getCarById(+req.params.id)

  if (car) {
    res.status(200).json(car)
  }
  else {
    res.status(404).json({
      message: 'Car not found'
    })
  }
})

app.get('/api/random-car', (req, res) => {
  res.status(200).json(getRandomCar())
})

app.get('*', function (req, res) {
  res.status(404).json({
    message: 'Not found'
  })
})

app.listen(port, () => {
  logger.info(`Started application at port ${port}`)
})