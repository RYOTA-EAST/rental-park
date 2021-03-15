$(function() {
  return $('#user_postal_code').jpostal({
    postcode: ['#user_postal_code'],
    address: {
      '#user_prefecture_code': '%3',
      '#user_city': '%4',
      '#user_street': '%5%6%7',
    },
  });
});