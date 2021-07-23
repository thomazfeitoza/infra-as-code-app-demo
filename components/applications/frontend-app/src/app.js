var app = new Vue({
  el: '#app',
  data: {
    mainCar: {},
    cars: []
  }
})

$.get(appConfig.apiUrl + '/api/cars', function (response) {
  app.cars = response
})


$.get(appConfig.apiUrl + '/api/random-car', function (response) {
  app.mainCar = response
})