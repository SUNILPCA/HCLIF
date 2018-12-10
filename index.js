'use strict'

const prompt = require('prompt');
const colors = require("colors/safe");
const hclif = require('./hclif');

function userInput() {
	var schema = {
		properties: {
			name: {				
				type: 'string',				
				validator: /aws*|azure*|google*/,
				message: colors.magenta('Please select provider [aws], [azure], [google]'),
				required: true,
				warning: colors.red('Must select aws or azure or google'),
				default: 'aws',				
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
				message: colors.blue('\n webapplication - Web Application Hosting infrastructure \n serverless -  Serverl less application with API Gateway and dynamoDB infrastructure \n staticwebsite - S3 bucket with static web site enable infrastructure\n')+colors.magenta('Please select blueprint [webapplication], [serverless], [staticwebsite]'),
				required: true,
				warning: colors.red('Must select webapplication or serverless or staticwebsite'),
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
			env: {
				type: 'string',				
				message: colors.magenta('Enter environment name as per your convenience, example dev/stage/prod'),
				required: true,
				warning: colors.red('Must select webapplication or serverless or staticwebsite'),
				default: 'dev'
			},
			appname: {
				type: 'string',				
				message: colors.magenta('Enter application name as per your convenience, example hccapp/webapp/staticapp'),
				required: true,
				warning: colors.red('Must select webapplication or serverless or staticwebsite'),
				default: 'myapp'
			}
		}
	}
	  
	prompt.start();
	prompt.get(schema, function (err, providerInfo) {		
		if(providerInfo.name === false || providerInfo.blueprint === false){
			console.log("Please enter valide provider/blueprint");
			userInput();
		} else {
			validateResouces(providerInfo);
		}
		
	});	
}

exports.askingForConfirmation = function (resouceExists, providerInfo) {
	var schema = {
		properties: {
			destroyFlag: {				
				type: 'string',				
				validator: /Y[es]|No/,
				message: resouceExists?colors.magenta('Resources are available for '+providerInfo.name+' provider and '+providerInfo.blueprint+' blueprint, want to destroy (Yes/No)?'):colors.magenta('\n No resouces are exist for '+providerInfo.name+' provider and bluepring for' +providerInfo.blueprint+' still continue to destroy'),
				required: true,
				warning: colors.red('user selection not correct enter Yes/No'),
				default: 'No',				
				before: function(value) { 
					if(value === 'Yes') {
						return true; 
					}
					else {
						return false;
					}
				}
			}
		}
	}
	  
	prompt.start();
	prompt.get(schema, function (err, result) {		
		if(result.destroyFlag === true){
			destroyInfrastructure(providerInfo)
		} else {			
			deployInfrastructure(providerInfo);
		}
		
	});	
};
  
/**
 * Runs `terraform destroy`` in the infrastructure directory
 * @returns {Promise} Resolves to result
 */
function destroyInfrastructure(providerInfo) {
  console.log('Destroy Infrastructure at '+providerInfo.provider+' Cloud!!!');
  return hclif.terraformDestroy(providerInfo)
    .catch(error => {
      console.log("Failed to destroy terraform in:", providerInfo.provider);
      console.log("Error:", error.message);
      return Promise.reject(new Error("Failed to destroy terraform"));
    });
}

function validateResouces(providerInfo) {  
  const origin = Promise.resolve(providerInfo);
  console.log('Validating Infrastructure at ' + providerInfo.name + 'Cloud \nAnd blueprint as '+providerInfo.blueprint);  
  return origin
	.then(resourceIsExists)
	.then(sourcePathUpdate)
    .then(() => providerInfo)
    .catch(error => {
      console.log('catch block');
      if (error) {
        console.log(error);
      } else {
        console.log("Error: Unexplaind error, something just failed.");
      }
      return Promise.reject(new Error("Failed to validate infrastructure"));
    });
}

/**
* This function check for state file exists for resource or not
* @param providerInfo - having blueprint and provider details
*
*/
function resourceIsExists (providerInfo) {
	return hclif.resourceExists(providerInfo).then(() => providerInfo)
	 .catch(error => {
		 console.log("unable to find resource location");
		 return Promise.reject(new Error("Failed to locate resources"));
	 });
}

/**
* This function update the source path based on blueprint
* @param providerInfo - having blueprint and provider details
*
*/
function sourcePathUpdate (providerInfo) {
	return hclif.sourcePathUpdate(providerInfo).then(() => providerInfo)
    .catch(error => {
		console.log("Fail to update main.tf file with source folder");
		return Promise.reject(new Error("Failed to update main.tf"));
    });
}

/**
 * Deploys the infrastructure defined in terraform for the cloud environment
 * @returns {Promise} Promise that resolves
 */
function deployInfrastructure(providerInfo) {  
  const origin = Promise.resolve(providerInfo);
  console.log('Deploying Infrastructure at ' + providerInfo.name + 'Cloud \nAnd blueprint as '+providerInfo.blueprint);  
  return origin
	.then(initializeTerraform)
    .then(planTerraform)
    .then(applyTerraform)
	.then(() => providerInfo)
    .catch(error => {
      console.log('catch block');
      if (error) {
        console.log(error);
      } else {
        console.log("Error: Unexplaind error.");
      }
      return Promise.reject(new Error("Failed to deploy infrastructure"));
    });
}

/**
 * Runs `terraform init` at infrastructure
 * @returns {Promise} Resolves to argv
 */
function initializeTerraform(providerInfo) {
  return hclif.terraformInit(providerInfo).then(() => providerInfo)
    .catch(error => {
      console.log("Failed to initialize terraform in:", providerInfo.name);
      console.log("Error:", error.message);
      return Promise.reject(new Error("Failed to initialize terraform"));
    });
}

/**
 * Runs `terraform plan` at infrastructure
 * @returns {Promise} Resolves to argv
 */
function planTerraform(providerInfo) {	
  return hclif.terraformPlan(providerInfo).then(() => providerInfo)
    .catch(error => {
      console.log("Failed to plan terraform in:", providerInfo.name);
      console.log("Error:", error.message);
      return Promise.reject(new Error("Failed to plan terraform"));
    });
}

/**
 * Runs `terraform apply` at infrastructure
 * @returns {Promise} Resolves to argv
 */
function applyTerraform(providerInfo) {
  return hclif.terraformApply(providerInfo).then(() => providerInfo)
    .catch(error => {
      console.log("Failed to apply terraform in:", providerInfo.blueprint);
      console.log("Error:", error.message);
      return Promise.reject(new Error("Failed to apply terraform"));
    });
}

function main () {
	userInput();	
}

/*When a file is run directly from Node.js, require.main is set to its module . That means that it is possible to determine whether a file has been run directly by testing require.main === module.*/ 
if(require.main === module) {
	main();
}