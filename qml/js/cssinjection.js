// ==UserScript==
// @name          ifarchive
// @namespace     https://ifarchive.info
// @description	  
// @author       
// @homepage      https://ifarchive.info
// @run-at        document-start
// ==/UserScript==
(function() {var css = [ 
".Page { margin: 0 !important; background-color: #fdfdfd !important; color: #333333 !important; border-right: 0 !important; padding: 0.1em 1em 4em !important; }",
"h1 { color: #0e8cba !important; font-size: 2.5em !important; font-family: sans-serif !important; }",
"a, a:hover, #indexpage .Header a { color: #0e8cba !important; }",
"#indexpage .ParentLinks a { color: #d0d0d0 !important; }"
].join("\n");
if (typeof GM_addStyle != "undefined") {
	GM_addStyle(css);
} else if (typeof PRO_addStyle != "undefined") {
	PRO_addStyle(css);
} else if (typeof addStyle != "undefined") {
	addStyle(css);
} else {
	var node = document.createElement("style");
	node.type = "text/css";
	node.appendChild(document.createTextNode(css));
	var heads = document.getElementsByTagName("head");
	if (heads.length > 0) {
		heads[0].appendChild(node); 
	} else {
		// no head yet, stick it whereever
		document.documentElement.appendChild(node);
	}
}
})();
