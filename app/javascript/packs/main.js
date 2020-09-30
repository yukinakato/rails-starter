$(".mytext").on("click", function () {
  $(this).text("clicked!!");
});
$(".mytext").animate({ opacity: 0.25 }, 3000, function () {
  $(this).text("completed");
});
