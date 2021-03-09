$(function () {
  $(document).on("mouseover", "h2", function () {
    $(this).css({ "color": "blue" });
  }).on("mouseout", "h2", function () {
    $(this).css({ "color": "" });
  })
});