---
layout: post
title: React and AngularJS Notes
---
# React  
* A component is a self-contained module that renders some output
** For example, a button.  A component might include one or more other components in its output.  eg. a Form.
*  Wow, this caching thing on index.html is pretty terrible for a new user.
*  All components have a `render` function that SPECIFIES what the HTML output of the COMPONENT is.
*  JSX: JS Extension, allows writing JS that LOOKS LIKE HTML
```
class HelloWorld extends React.Component {
  render() {  //The component has a RENDER Function
    return (  //The render function RETURNS HTML
      <h1 className='large'>Hello World</h1>  //THIS IS NOT ACTUALLY HTML
    );
  }
}
```
* h1 className GETS CONVERTED TO class.  This is because CLASS IS A RESERVED JS KEYWORD.
* JSX is very convenient notation for writing nested HTML snippets
* In order to load React from <script></script> , ie. client side, the following is needeed:
* react.min.js , react-dom.min.js, babel-core@x.x.x/browser.min.js
* Babel is a library for transpiling ES6 to ES5.
* Inside the body we have the following:
```
<script type="text/babel">
var app = <h1>Hello world</h1>
var mountComponent = document.querySelector('#app');
ReactDOM.render(app, mountComponent);
</script>
``` 
* This tells Bable to convert the above ES6 into ES5
* render() :  `ReactDOM.render(<what>, <where>)`
* Interesting, in this case the WHERE is #app.  In other tutorials it was document root.















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
