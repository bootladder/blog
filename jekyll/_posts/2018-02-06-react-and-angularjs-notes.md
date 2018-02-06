---
layout: post
title: React and AngularJS Notes
---
  















# AngularJS
First you have this:  `<html ng-app="todoApp">`  
And eventually this:  `<div ng-controller="TodoListController as todoList">`
Then in the .js you have:  
```
angular.module('todoApp', [])
  .controller('TodoListController', function() {
```
The names have to match.  
`<html ng-app="todoApp">`  Does not have to be at the top, or in a html tag.  
In order to use $http requests, the controller is passed $http.  As in this:  
```
angular.module('myapp', [])
  .controller('myController', function($http) {
```
$http will give `No 'Access-Control-Allow-Origin' header is present on the requested resource.'`

*Meh, I don't like it.*  
*As soon as I found out how much has changed over the versions I immediately quit.  I'm not going to bother learning the history when I already think it sucks*
