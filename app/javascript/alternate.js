

$(function(){

  $('.btn').each(

    function(){

      var src = $(this).find('img').attr('src');
      var src_white = src.replace('.png', '_white.png');

      $(this).mouseover(
        function(){
          $(this).find('img').attr('src', src_white);
        }
      );

      $(this).mouseout(
        function(){
          $(this).find('img').attr('src', src);
        }
      );

    }

  );

});

