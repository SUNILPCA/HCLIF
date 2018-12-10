'use strict'

const prompt = require('prompt');
let hclif = require('./hclif');

function userInput() {
	var schema = {
		properties: {
			provider: {				
				type: 'string',				
				validator: /aws*|azure*|google*/,
				message: 'Please select provider [aws], [azure], [google]',
				required: true,
				warning: 'Must select aws or azure or google',
				default: 'azure',				
				before: function(value) { 
					if(value === 'aws' || value === 'azure' || value === 'google') {
						return value; 
					}
					else {
						return false;
					}
				}
			},
			blueprint: {				
				type: 'string',				
				validator: /webapplication*|serverless*|staticwebsite*/,
				message: 'Please select blueprint [webapplication], [serverless], [staticwebsite]',
				required: true,
				warning: 'Must select webapplication or serverless or staticwebsite',
				default: 'webapplication',
				before: function(value) { 
					if(value === 'webapplication' || value === 'serverless' || value === 'staticwebsite') {
						return value; 
					}
					else {
						return false;
					}
				}		
			},
			appname: {
				type: 'string',				
				message: 'Enter resource name want to destroy, example hcc-app/web-app/static-app',
				required: true,
				warning: 'Must select webapplication or serverless or staticwebsite',
				default: 'myapp'
			}
		}
	}
	  
	prompt.start();
	prompt.get(schema, function (err, result) {
		if(result.provider === false || result.blueprint === false){
			console.log("Please enter valide provider/blueprint");
			userInput();
		} else {
			destroyInfrastructure(result);
		}
		
	});	
}

/**
 * Runs `terraform destroy`` in the infrastructure directory
 * @returns {Promise} Resolves to result
 */
function destroyInfrastructure(result) {
  console.log('Destroy Infrastructure at '+result.provider+' Cloud!!!');
  return hclif.terraformDestroy(result)
    .catch(error => {
      console.log("Failed to destroy terraform in:", result.provider);
      console.log("Error:", error.message);
      return Promise.reject(new Error("Failed to destroy terraform"));
    });
}

function destroy () {
	userInput();	
}

/*When a file is run directly from Node.js, require.main is set to its module . That means that it is possible to determine whether a file has been run directly by testing require.main === module.*/ 
if(require.main === module) {
	destroy();
}