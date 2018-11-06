'use strict'

const prompt = require('prompt');
let hclif = require('./hclif');
let fs = require('fs');

function userInput() {
	var schema = {
		properties: {
			provider: {				
				type: 'string',				
				validator: /aws*|azure*|google*/,
				message: 'Please select provider [aws], [azure], [google]',
				required: true,
				warning: 'Must select aws or azure or google',
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
				validator: /webserver*|serverless*|staticwebsite*/,
				message: 'Please select blueprint [webserver], [serverless], [staticwebsite]',
				required: true,
				warning: 'Must select webserver or serverless or staticwebsite',
				default: 'webserver',
				before: function(value) { 
					if(value === 'webserver' || value === 'serverless' || value === 'staticwebsite') {
						return value; 
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
		if(result.provider === false || result.blueprint === false){
			console.log("Please enter valide provider/blueprint");
			userInput();
		} else {
			sourcePathUpdate(result)
			deployInfrastructure(result);
		}
		
	});	
}

  
/**
 * Deploys the infrastructure defined in terraform for the cloud environment
 * @returns {Promise} Promise that resolves
 */
function deployInfrastructure(result) {  
  const origin = Promise.resolve(result);
  console.log('Deploying Infrastructure at' + result.provider + 'Cloud \nAnd blueprint as '+result.blueprint);  
  return origin
    .then(initializeTerraform)
    .then(planTerraform)
    .then(applyTerraform)
	.then(() => result)
    .catch(error => {
      console.log('catch block');
      if (error) {
        console.log(error);
      } else {
        console.log("Error: Unexplaind error, something just failed. Lucky you.");
      }
      return Promise.reject(new Error("Failed to deploy infrastructure"));
    });
}

/**
*
*
*
*/
function sourcePathUpdate (result) {
	let filePath = "./infrastructure_"+result.provider+"/main.tf"
	let findText = "";
	let replaceWith = '\tsource = "./blueprint/'+result.blueprint+'"';
	let patten = /source/gi;	
	
	fs.readFile(filePath, 'utf8', function(err, data) {
		if (err) {
		  return console.log(err);
		}
		 data = data.toString();
		 data.split('\n').forEach(function (line) {
			 if(line.match(patten)){
				 console.log("line::::::::::"+line);
				 findText = line;
			 }
			 
		 });
		let replaceText = data.replace(findText,replaceWith);
		console.log("replaceText:::::::::::"+replaceText);
		fs.writeFile(filePath, replaceText, 'utf8', function(err) {
			if (err) {
			   return console.log(err);
			};
		});
	});
}
/**
 * Runs `terraform init` in the infrastructure directory
 * @returns {Promise} Resolves to argv
 */
function initializeTerraform(result) {
  return hclif.terraformInit(result).then(() => result)
    .catch(error => {
      console.log("Failed to initialize terraform in:", result.provider);
      console.log("Error:", error.message);
      return Promise.reject(new Error("Failed to initialize terraform"));
    });
}

/**
 * Runs `terraform plan` in the infrastructure directory
 * @returns {Promise} Resolves to argv
 */
function planTerraform(result) {
  return hclif.terraformPlan(result).then(() => result)
    .catch(error => {
      console.log("Failed to plan terraform in:", result.provider);
      console.log("Error:", error.message);
      return Promise.reject(new Error("Failed to plan terraform"));
    });
}

/**
 * Runs `terraform apply` in the infrastructure directory
 * @returns {Promise} Resolves to argv
 */
function applyTerraform(result) {
  /*return hclif.terraformApply(result).then(() => result)
    .catch(error => {
      console.log("Failed to apply terraform in:", result.blueprint);
      console.log("Error:", error.message);
      return Promise.reject(new Error("Failed to apply terraform"));
    });*/
}

function main () {
	userInput();	
}

/*When a file is run directly from Node.js, require.main is set to its module . That means that it is possible to determine whether a file has been run directly by testing require.main === module.*/ 
if(require.main === module) {
	main();
}