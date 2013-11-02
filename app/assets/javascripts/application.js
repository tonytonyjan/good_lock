// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require angular.min
//= require_tree .


var app = angular.module('app', []);

app.controller('LoginCtrl', ['$scope', function ($scope) {

   $scope.googleOauth2 = function () {
      window.location.href = "/auth/google_oauth2";
   };

}]);

app.controller('CalCtrl', ['$scope', function ($scope) {

}]);

app.controller('CalHeaderCtrl', ['$scope', function ($scope) {

   $scope.openSettings = function () {

      var calendarPage = angular.element($('#calendar-page'));
      var settingsPage = angular.element($('#settings-page'));

      if (settingsPage.hasClass('hide') && !calendarPage.hasClass('hide')) {
         // open settings
         settingsPage.removeClass('hide');
         settingsPage.removeClass('animated fadeOutDownBig');
         settingsPage.addClass('slideUp');
         setTimeout(function () {
            calendarPage.addClass('hide');
         }, 1500);
         
      }
 
   };

}]);