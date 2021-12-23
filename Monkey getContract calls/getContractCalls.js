// ==UserScript==
// @name         Turtle:RDF to Contract calls
// @namespace    ----
// @version      0.1
// @author       Robb
// @match        https://riccardo.solidcommunity.net/profile/*
// @icon         https://www.google.com/s2/favicons?domain=solidcommunity.net
// @grant        none
// ==/UserScript==

let style = "font-family: monospace; font-size: 100%; min-width: 60em; margin: 1em 0.2em; padding: 1em; border: 0.1em solid rgb(136, 136, 136); border-radius: 0.5em; color: rgb(136, 136, 136);";
let hash = "";

function clearText(line){
    return line.substring(1, line.length-2);
}

function removePreSpaces(line){
    let out = "";
    let check = false;

    for(let c of line){
        if(check){ out += c; }
        else if(c != ' '){ out += c; check = true; }
    }

    return out;
}

(function() {
    'use strict';

    let rdf = [];
    let tmp = "";
    let dict = {};

    let inModes = [];
    let outModes = [];
    let outWebIDs = [];

    let oldModes = [];
    let oldWebIDs = [];

    function showResults(_oldModes, _oldWebIDs, _outModes, _outWebIDs){
        let input = prompt("POD path:","");
        let oldM = [];
        let newM = [];

        for(let i=0; i<oldModes.length; i++){ oldM.push(_oldModes[i] + '$' + _oldWebIDs[i]); }
        for(let i=0; i<outModes.length; i++){ newM.push(_outModes[i] + '$' + _outWebIDs[i]); }
        //console.log(oldM);
        //console.log(newM);

        if(input != null){
            let res = document.getElementById("boxResults");

            if(res != null){ res.remove(); }

            let out = "<pre><p>Deploy(" + sha256(input) + ");\n";

            let added = [];

            for(let _new of newM){
                let indexOld = oldM.indexOf(_new);
                let indexNew = newM.indexOf(_new);
                let parts = _new.split('$');

                if(indexOld != -1){
                    out += "<p><font style='color: #639C9C; font-size: 10px;'>"+parts[1]+"</font> ->  addRule(" + sha256(parts[1]) + ',' + parts[0] + ");</p>";

                    added.push(_new);
                }else{
                    let oldI = _oldWebIDs.indexOf(parts[1]);
                    if(oldI == -1){
                        out += "<p><font style='color: #639C9C; font-size: 10px;'>"+parts[1]+"</font> ->  addRule(" + sha256(parts[1]) + ',' + parts[0] + ");</p>";

                        added.push(_new);
                    }else{
                        out += "<p><font style='color: #639C9C; font-size: 10px;'>"+parts[1]+"</font> ->  changeRule("+ _oldModes[oldI] + ',' + sha256(parts[1]) + ',' + parts[0] + ");</p>";

                        added.push(_new);
                        added.push(_oldModes[oldI] + '$' + parts[1]);
                    }
                }
            }

            for(let _old of oldM){
                let parts = _old.split('$');

                if(added.indexOf(_old) == -1){
                    out += "<p><font style='color: #639C9C; font-size: 10px;'>"+parts[1]+"</font> ->  removeRule(" + sha256(parts[1]) + ',' + parts[0] + ");</p>";
                }
            }

            var box = document.createElement("div");
            var butt = document.createElement("button");

            butt.onclick = function(){ document.getElementById('boxResults').remove(); };
            butt.style.borderRadius = "8px";
            butt.style.background = "#DD1A1A";
            butt.innerHTML = "X";

            box.id = "boxResults";
            box.style.padding = "20px 20px 20px 20px";
            box.style.margin = "20px 20px 20px 20px";
            box.style.background = "#F6F6F6";
            box.style.borderRadius = "25px";
            box.style.position = "absolute";
            box.style.zIndex = "100000";
            box.style.border = "2px solid #D4D4D4";
            box.innerHTML = out + "</pre>";

            box.appendChild(butt);
            document.body.appendChild(box);

            oldM = [];
            newM = [];
        }
    }

    function onKeydown(evt) {
        // Start on alt + 'S' pressed
        if (evt.altKey && evt.keyCode == 83) {
            rdf = document.getElementsByTagName("textarea");

            if(rdf.length != 0){
                for (let textArea of rdf) {
                    if(textArea.getAttribute("style") == style){
                        if(hash != sha256(textArea.value)){
                            oldModes = outModes;
                            oldWebIDs = outWebIDs;
                            outModes = []; outWebIDs = []; inModes = [];

                            hash = sha256(textArea.value);
                        }

                        for(let line of textArea.value.split('\n')){

                            if(line[0] == '@'){
                                let tmpLine = line.split(" ");

                                if(tmpLine[1][0] != ':'){ dict[tmpLine[1]] = clearText(tmpLine[2]); }

                            }else if(line[0] == ':'){
                                let r = line.includes("R");
                                let w = line.includes("W");
                                let a = line.includes("A");
                                let c = line.includes("C");

                                let modes = "0000";

                                modes += (c) ? '1' : '0';
                                modes += (a) ? '1' : '0';
                                modes += (w) ? '1' : '0';
                                modes += (r) ? '1' : '0';

                                inModes.push(line);
                                outModes.push(modes);

                            }else if(line[0] == ' '){
                                if(line.includes("acl:agentClass")){
                                    outWebIDs.push(removePreSpaces(line.substring(0, line.length-1)));

                                }else if(line.includes("acl:origin")){
                                    tmp = removePreSpaces(line);

                                    let tmpLine = tmp.split(' ');

                                    tmp = tmpLine[0] + ' ' + clearText(tmpLine[1]);

                                    outWebIDs.push(tmp);

                                }else if(line.includes("acl:agent")){
                                    tmp = removePreSpaces(line);

                                    let tmpLine = tmp.split(' ');
                                    let tmpRes = tmpLine[1].split(':');

                                    tmp = tmpLine[0] + ' ' + dict[tmpRes[0] + ':'] + tmpRes[1].substring(0, tmpRes[1].length-1);

                                    outWebIDs.push(tmp);

                                }

                            }

                        }
                        //console.log(inModes);
                        //console.log(outModes);
                        //console.log(outWebIDs);
                        //console.log(hash);
                        //console.log(oldModes);
                        //console.log(oldWebIDs);

                        if(oldModes != []){ showResults(oldModes, oldWebIDs, outModes, outWebIDs); }
                    }
                }
            }
        }
    }

    document.addEventListener('keydown', onKeydown, true);
})();


// From: https://replit.com/@remarkablemark/Nodejs-SHA-256-hash
function sha256(ascii) {
	function rightRotate(value, amount) {
		return (value>>>amount) | (value<<(32 - amount));
	};

	var mathPow = Math.pow;
	var maxWord = mathPow(2, 32);
	var lengthProperty = 'length'
	var i, j; // Used as a counter across the whole file
	var result = ''

	var words = [];
	var asciiBitLength = ascii[lengthProperty]*8;

	//* caching results is optional - remove/add slash from front of this line to toggle
	// Initial hash value: first 32 bits of the fractional parts of the square roots of the first 8 primes
	// (we actually calculate the first 64, but extra values are just ignored)
	var hash = sha256.h = sha256.h || [];
	// Round constants: first 32 bits of the fractional parts of the cube roots of the first 64 primes
	var k = sha256.k = sha256.k || [];
	var primeCounter = k[lengthProperty];
	/*/
	var hash = [], k = [];
	var primeCounter = 0;
	//*/

	var isComposite = {};
	for (var candidate = 2; primeCounter < 64; candidate++) {
		if (!isComposite[candidate]) {
			for (i = 0; i < 313; i += candidate) {
				isComposite[i] = candidate;
			}
			hash[primeCounter] = (mathPow(candidate, .5)*maxWord)|0;
			k[primeCounter++] = (mathPow(candidate, 1/3)*maxWord)|0;
		}
	}

	ascii += '\x80' // Append Ƈ' bit (plus zero padding)
	while (ascii[lengthProperty]%64 - 56) ascii += '\x00' // More zero padding
	for (i = 0; i < ascii[lengthProperty]; i++) {
		j = ascii.charCodeAt(i);
		if (j>>8) return; // ASCII check: only accept characters in range 0-255
		words[i>>2] |= j << ((3 - i)%4)*8;
	}
	words[words[lengthProperty]] = ((asciiBitLength/maxWord)|0);
	words[words[lengthProperty]] = (asciiBitLength)

	// process each chunk
	for (j = 0; j < words[lengthProperty];) {
		var w = words.slice(j, j += 16); // The message is expanded into 64 words as part of the iteration
		var oldHash = hash;
		// This is now the undefinedworking hash", often labelled as variables a...g
		// (we have to truncate as well, otherwise extra entries at the end accumulate
		hash = hash.slice(0, 8);

		for (i = 0; i < 64; i++) {
			var i2 = i + j;
			// Expand the message into 64 words
			// Used below if
			var w15 = w[i - 15], w2 = w[i - 2];

			// Iterate
			var a = hash[0], e = hash[4];
			var temp1 = hash[7]
				+ (rightRotate(e, 6) ^ rightRotate(e, 11) ^ rightRotate(e, 25)) // S1
				+ ((e&hash[5])^((~e)&hash[6])) // ch
				+ k[i]
				// Expand the message schedule if needed
				+ (w[i] = (i < 16) ? w[i] : (
						w[i - 16]
						+ (rightRotate(w15, 7) ^ rightRotate(w15, 18) ^ (w15>>>3)) // s0
						+ w[i - 7]
						+ (rightRotate(w2, 17) ^ rightRotate(w2, 19) ^ (w2>>>10)) // s1
					)|0
				);
			// This is only used once, so *could* be moved below, but it only saves 4 bytes and makes things unreadble
			var temp2 = (rightRotate(a, 2) ^ rightRotate(a, 13) ^ rightRotate(a, 22)) // S0
				+ ((a&hash[1])^(a&hash[2])^(hash[1]&hash[2])); // maj

			hash = [(temp1 + temp2)|0].concat(hash); // We don't bother trimming off the extra ones, they're harmless as long as we're truncating when we do the slice()
			hash[4] = (hash[4] + temp1)|0;
		}

		for (i = 0; i < 8; i++) {
			hash[i] = (hash[i] + oldHash[i])|0;
		}
	}

	for (i = 0; i < 8; i++) {
		for (j = 3; j + 1; j--) {
			var b = (hash[i]>>(j*8))&255;
			result += ((b < 16) ? 0 : '') + b.toString(16);
		}
	}
	return result;
};