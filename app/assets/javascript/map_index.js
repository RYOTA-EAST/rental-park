let map
let geocoder
let marker = []; // マーカーを複数表示させたいので、配列化
let infoWindow = []; // 吹き出しを複数表示させたいので、配列化
const parks = gon.parks; // コントローラーで定義したインスタンス変数を変数に代入

function initMap(){
  // geocoderを初期化
  geocoder = new google.maps.Geocoder()
  var bounds = new google.maps.LatLngBounds();
  // mapの初期位置設定
  map = new google.maps.Map(document.getElementById('map'), {
  center: {lat: -35.6809591, lng: 139.7673068},
  zoom: 16
  });
  // forは繰り返し処理
  // 変数iを0と定義し、
  // その後gonで定義したusers分繰り返し加える処理を行う
  for (let i = 0; i < parks.length; i++) {
      // geocoderで addressの経緯緯度取得
      // users[i]は変数iのユーザーを取得している
      geocoder.geocode( { 'address': parks[i].city + parks[i].street }, function(results, status) {
          // statusがOKであれば
      if (status == 'OK') {
  　　　　// map.setCenterで地図が移動
          map.setCenter(results[0].geometry.location);
          marker[i] = new google.maps.Marker({
              map: map,
              position: results[0].geometry.location
          });
          bounds.extend (marker[i].position);
          // 変数iを変数idに代入
          let id = parks[i]['id']
          // infoWindowは吹き出し
          infoWindow[i] = new google.maps.InfoWindow({
          // contentで中身を指定
          // 今回は文字にリンクを貼り付けた形で表示
          content: `<a href='/parks/${id}'>${parks[i].name}</a>`
          });
          // markerがクリックされた時、
          marker[i].addListener("click", function(){
              // infoWindowを表示
              infoWindow[i].open(map, marker[i]);
          });
      } else {
          alert('Geocode was not successful for the following reason: ' + status);
      }
      map.fitBounds(bounds);
      });
  }
}