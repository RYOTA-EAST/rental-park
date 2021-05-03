function CurrentSearch() {
  if (!navigator.geolocation){//Geolocation apiがサポートされていない場合
    output.innerHTML = "<p>Geolocationはあなたのブラウザーでサポートされておりません</p>";
    return;
  }
  function success(position) {
    var latitude  = position.coords.latitude;//緯度
    var longitude = position.coords.longitude;//経度
    document.getElementById("search_word").value= latitude + ',' + longitude;
    document.getElementById("search-btn").click();
  };
  function error() {
    //エラーの場合
    output.innerHTML = "座標位置を取得できません";
  };
  navigator.geolocation.getCurrentPosition(success, error);//成功と失敗を判断
}


// const btn = document.getElementById('current-search');

// btn.addEventListener('click',(e) =>{
//   console.log("現在地検索します");
// });