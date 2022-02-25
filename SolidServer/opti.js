
const Hash = require("./sha256");
const fs = require('fs');

const modesEnum = {
	"Read" : 0x01,
	"Write" : 0x02,
	"Append" : 0x04,
	"Control" : 0x08
};

// Allows to get essential informations from a acl links
// returns a string
//
// getName("http://www.w3.org/ns/auth/acl#Write") -> "Write"
function getName( path ){
	if(path.includes('#')){
		return path.split('#')[1];
	}
	return path;
}

// Allows to get path from Root dir = POD
// returns path from root
function getPath( path ){
	let tmpPath = path.substring( path.indexOf("OD/") + 3 );
	if(tmpPath == ".acl") return ".";
	return tmpPath.split(".")[0];
}

// Remove all 'null' element from an array
function clearArray( arr ){
	return arr.filter(function(ele){return ele!=null;});
}

// Search for element inside a dict value
// returns the index of the dict
function indexOfDict( dict, value ){
	for(let i=0; i<dict.length; i++)
		if(Object.keys(dict[i]).includes(value))
			return i;
	return -1;
}

// Uses a different idea from the smart contract solution:
//		Here we have to respect the Containers vision, in wich we have for every Container different modes and different WebIDs.
//
// Every POD has different Containers, for example:
//		TestPOD has 2 containers #Public and #Conf1 (Containers are associated to '.' [Root of the POD])
//			#Public has modes = 0x01 (Read) for every agentClass = Agent (for everyone)
// 			#Conf1 has modes = 0x07  (Read, Write, Append) for agent = [#me, #agentOne, #agentTwo]
//
//	We can rappresent this informations as:
//		{Deploy SC} 							 when creating the POD;
//		{call "addRule"/"removeRule"}  every time we add/remove a new webID/mode to the container, using as modes the actual modes of the container;
//		 and so on...
//
//
// Manages the "containers.json" in order to keep informations consistent and calls the Oracle.
async function formatRequest( value, method, path, container, input ){
	try{

		//#
		let containersjson = fs.readFileSync( "./containers.json", "utf-8" );
		let containers  = JSON.parse(containersjson);
		
		if(value == "Authorization"){
			if(method == "insert"){
				let more = {};
				
				if(!Object.keys(containers).includes(path))
					containers[path]  = [];
				
				if(!Object.values(containers[path]).includes(container)){
					more[container] =  {"webIDs" : [], "modes" : input };
					containers[path].push(more);
				}
				
			}else{
				// FOR LOOP SC
				
				delete containers[path][indexOfDict(Object.values(containers[path]), container)];
				containers[path] = clearArray(containers[path]);
			}
			
		}else if(Object.keys(modesEnum).includes(value)){    // Would be possible to remove "changeRule" from SmartContract ?
		
																					 // BUG in Penny when tuning on Write and when turning off Append !
																					 // 	Can be patched but this kind of policy is not supported by Solid
		
					var index = indexOfDict(Object.values(containers[path]), container);
					var path_ = Hash.sha256(path);
		
					if(method == "insert"){
						
						containers[path][index][container]["modes"] |= modesEnum[value];
						
						for(let i=0; i<containers[path][index][container]["webIDs"].length; i++)
							console.log("addRule( "+ path_ +", "+ Hash.sha256(containers[path][index][container]["webIDs"][i]) +", "+ modesEnum[value] +" )");
						
					}else{
						
						if(containers[path][index][container]["modes"] & modesEnum[value] == 0x00){
							console.log("ERROR     forbitten action! ");
						}else{
							containers[path][index][container]["modes"] ^= modesEnum[value];
							
							for(let i=0; i<containers[path][index][container]["webIDs"].length; i++)
								console.log("removeRule( "+ path_ +", "+ Hash.sha256(containers[path][index][container]["webIDs"][i]) +", "+ modesEnum[value] +" )");
						}		
						
					}
		}else{
			var index = indexOfDict(Object.values(containers[path]), container); 
			var path_ = Hash.sha256(path);
			
			if(method == "insert"){
				
					if( !containers[path][index][container]["webIDs"].includes(value) )
						containers[path][index][container]["webIDs"].push(value);
					
					if( containers[path][index][container]["modes"] != 0x00 )
						for(let i=0; i<containers[path][index][container]["webIDs"].length; i++)
								console.log("addRule( "+ path_ +", "+ Hash.sha256(containers[path][index][container]["webIDs"][i]) +", "+ containers[path][index][container]["modes"] +" )");
				
			}else{
					
					delete containers[path][index][container]["webIDs"][ containers[path][index][container]["webIDs"].indexOf(value) ];
					containers[path][index][container]["webIDs"] = clearArray(containers[path][index][container]["webIDs"]);
					
					if( containers[path][index][container]["modes"] != 0x00 )
						for(let i=0; i<containers[path][index][container]["webIDs"].length; i++)
								console.log("removeRule( "+ path_ +", "+ Hash.sha256(containers[path][index][container]["webIDs"][i]) +", "+ containers[path][index][container]["modes"] +" )");
				
			}
		}
		
		//#
		var outjson = JSON.stringify(containers);
		console.log("\njson = \n\n"+outjson+"\n");
		
		fs.writeFileSync("./containers.json", outjson);
		
	}catch(err){
		console.log(err);
	}
}

module.exports = { getName, getPath, formatRequest };

