// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//



//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .


$(function () {
  $('#users th a, #users .pagination a').click(function () {
    $.getScript(this.href);
    return false;
  });

  // Search form.
  $('#users_search input').keyup(function () {
    $.get(this.action, $(this).serialize(), null, 'script');
    return false;
  });

  $('#events th a, #events .pagination a').click(function () {
    console.log(this)
    $.getScript(this.href);
    return false;
  });

  // Search form.
  $('#events_search input').keyup(function () {
    $.get(this.action, $(this).serialize(), null, 'script');
    return false;
  });

})


