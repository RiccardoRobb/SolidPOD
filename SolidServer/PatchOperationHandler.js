"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PatchOperationHandler = void 0;
const LogUtil_1 = require("../../logging/LogUtil");
const BadRequestHttpError_1 = require("../../util/errors/BadRequestHttpError");
const NotImplementedHttpError_1 = require("../../util/errors/NotImplementedHttpError");
const CreatedResponseDescription_1 = require("../output/response/CreatedResponseDescription");
const ResetResponseDescription_1 = require("../output/response/ResetResponseDescription");
const OperationHandler_1 = require("./OperationHandler");
const Opti = require("../../opti");
/**
 * Handles PATCH {@link Operation}s.
 * Calls the modifyResource function from a {@link ResourceStore}.
 */
class PatchOperationHandler extends OperationHandler_1.OperationHandler {
    constructor(store) {
        super();
        this.logger = LogUtil_1.getLoggerFor(this);
        this.store = store;
    }
    async canHandle({ operation }) {
        if (operation.method !== 'PATCH') {
            throw new NotImplementedHttpError_1.NotImplementedHttpError('This handler only supports PATCH operations.');
        }
    }
    async handle({ operation }) {
        // Solid, §2.1: "A Solid server MUST reject PUT, POST and PATCH requests
        // without the Content-Type header with a status code of 400."
        // https://solid.github.io/specification/protocol#http-server
        if (!operation.body.metadata.contentType) {
            this.logger.warn('PATCH requests require the Content-Type header to be set');
            throw new BadRequestHttpError_1.BadRequestHttpError('PATCH requests require the Content-Type header to be set');
        }
        // A more efficient approach would be to have the server return metadata indicating if a resource was new
        // See https://github.com/solid/community-server/issues/632
        // RFC7231, §4.3.4: If the target resource does not have a current representation and the
        //   PUT successfully creates one, then the origin server MUST inform the
        //   user agent by sending a 201 (Created) response.
        const exists = await this.store.resourceExists(operation.target, operation.conditions);
        await this.store.modifyResource(operation.target, operation.body, operation.conditions);
		
		this.logger.warn( JSON.stringify(operation) );
		
		if(Object.keys(operation.body.algebra).includes("delete")){
			this.logger.warn("remove ["+ Opti.getName(operation.body.algebra["delete"][0]["predicate"]["value"]) +"]"+ Opti.getName(operation.body.algebra["delete"][0]["object"]["value"]) +" : "+ Opti.getName(operation.body.algebra["delete"][0]["subject"]["value"])+ "      ---{"+ Opti.getPath(operation.target.path) +"}" );
		
			let type  = Opti.getName(operation.body.algebra["delete"][0]["object"]["value"]);
			let webID = Opti.getName(operation.body.algebra["delete"][0]["subject"]["value"]);
			let path = Opti.getPath(operation.target.path);
		
			try{
				await Opti.formatRequest( type, "delete", path, webID, 0x00 );
			}catch(err){
				this.logger.err(err);
			}
		}else{
			this.logger.warn("add ["+ Opti.getName(operation.body.algebra["insert"][0]["predicate"]["value"]) +"]"+ Opti.getName(operation.body.algebra["insert"][0]["object"]["value"]) +" : "+ Opti.getName(operation.body.algebra["insert"][0]["subject"]["value"])+ "      ---{"+ Opti.getPath(operation.target.path) +"}" );
			
			let type  = Opti.getName(operation.body.algebra["insert"][0]["object"]["value"]);
			let webID = Opti.getName(operation.body.algebra["insert"][0]["subject"]["value"]);
			let path = Opti.getPath(operation.target.path);
			
			try{
				await Opti.formatRequest( type, "insert", path, webID, 0x00 );
			}catch(err){
				this.logger.err(err);
			}
		}
		
        if (exists) {
            return new ResetResponseDescription_1.ResetResponseDescription();
        }
        return new CreatedResponseDescription_1.CreatedResponseDescription(operation.target);
    }
}
exports.PatchOperationHandler = PatchOperationHandler;
//# sourceMappingURL=PatchOperationHandler.js.map