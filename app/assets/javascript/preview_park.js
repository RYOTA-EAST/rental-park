document.addEventListener('DOMContentLoaded', function(){
  const vehicleImageList = document.getElementById('park-image-list');

  document.getElementById('park_image').addEventListener('change', function(e){
    // 画像が表示されている場合のみ、すでに存在している画像を削除する
    const imageContent = document.getElementsByClassName('park-img');
    if (!(imageContent.length===0)){
      imageContent.item(0).remove();
    }
    const file = e.target.files[0];
    const blob = window.URL.createObjectURL(file);

    // 画像を表示するためのdiv要素を生成
    const imageElement = document.createElement('div');

    // 表示する画像を生成
    const blobImage = document.createElement('img');
    blobImage.width = 200;
    blobImage.height = 200;
    blobImage.className = 'park-img'
    blobImage.setAttribute('src', blob);

  // 生成したHTMLの要素をブラウザに表示させる
    imageElement.appendChild(blobImage);
    vehicleImageList.appendChild(imageElement);
  });
});