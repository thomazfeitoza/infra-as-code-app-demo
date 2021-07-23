const buildCarObject = (manufacturer, model, imageUrl) => {
  return {
    manufacturer,
    model,
    imageUrl
  }
}

const carList = [
  buildCarObject('Nissan', 'Skyline R34', 'images/skyline.jpg'),
  buildCarObject('Toyota', 'Supra', 'images/supra.jpg'),
  buildCarObject('Mercedez-AMG', 'F1', 'images/f1.jpg'),
  buildCarObject('Ford', 'Mustang GT-500', 'images/mustang-gt-500.jpg'),
  buildCarObject('Chevrolet', 'Impala', 'images/impala.jpg'),
  buildCarObject('Lamborghini', 'Aventador', 'images/aventador.jpg'),
]

module.exports.getCars = () => {
  return carList
}


module.exports.getCarById = (id) => {
  return carList[id - 1]
}

module.exports.getRandomCar = () => {
  const index = Math.floor(Math.random() * carList.length)
  return carList[index]
}
