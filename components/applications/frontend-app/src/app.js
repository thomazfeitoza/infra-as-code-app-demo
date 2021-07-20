$.get(appConfig.apiUrl + '/api/me', function (response) {
  var dataEl = $('#user-data')
  dataEl.append('<div>Nome:' + response.name + '</div>')
  dataEl.append('<div>Idade:' + response.age + '</div>')
})

$.get(appConfig.apiUrl + '/api/hostname', function (response) {
  $('#host-info').html('Requisição respondida pelo hostname <b>' + response.hostname + '</b>')
})