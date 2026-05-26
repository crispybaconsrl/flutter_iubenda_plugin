
function sdk_injectStyle(style) {
    console.log("adding style");
    var _body = document.getElementsByTagName('head')[0];
    var _style = document.createElement('style');
    var _text = document.createTextNode(style);
    _style.appendChild(_text);
    _body.appendChild(_style);
}