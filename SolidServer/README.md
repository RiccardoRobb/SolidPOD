
# Solid Server add-on
## Uses a different idea from the smart contract solution:
  Here we have to respect the **Containers vision**, in wich we have for every Container different modes and different WebIDs.

###### Every POD has different Containers, for example:
		TestPOD has 2 containers #Public and #Conf1 (Containers are associated to '.' [Root of the POD])
			#Public has modes = 0x01 (Read) for every agentClass = Agent (for everyone)
			#Conf1 has modes = 0x07  (Read, Write, Append) for agent = [#me, #agentOne, #agentTwo]

###### We can rappresent this informations as:
		{Deploy SC}                   when creating the POD;
		{call "addRule"/"removeRule"}  every time we add/remove a new webID/mode to the container, using as modes the actual modes of the container;

Composed by 2 files:
* `PatchOperationHandler.js` located in **community-server/dist/http/ldp/**
  * Allows Solid server to handle PATCH operations, used for modify acls.
  * Uses `opti.js` in order to manage Http calls and call oracles.
  
* `opti.js` located in **community-server/dist/**
  * Manipulates `containers.json` located in ~~**community-server/**~~ (to change in **community-server/PODDir/**).
  * Uses `containers.json` to keep track of Containers status.

<br></br><br></br>

# TO DO:
- [ ] Remove **<em>'changeRule'</em>** method from `Version_7` SmartContract.
- [ ] Implement **<em>'removePath'</em>** method to `Version_7` SmartContract.
- [ ] Auto-add #Public and #Owner Containers when creating a file/dir.
- [ ] Change creation path for `containers.json`.
- [ ] Implement Push Oracles.
