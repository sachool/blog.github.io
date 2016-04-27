$220(function() {
  $220("#toggle").click(function() {
   $220(".main-navigation").slideToggle();
    return false;
  });
  
  $220(window).resize(function() {
   var win = $(window).width();
   var p = 550;
   if(win > p) {
    $220(".main-navigation").show();
   }
   else {
    $220(".main-navigation").hide();
   }
 });
});
