'use strict'

let hclif = require('./hclif');

/**
 * Deploys the infrastructure defined in terraform for the cloud environment
 * @returns {Promise} Promise that resolves
 */

function deployInfrastructure() {
  const origin = Promise.resolve();

  return origin
    .then(initializeTerraform)
    .then(planTerraform)
    .then(applyTerraform)
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
 * Runs `terraform init` in the infrastructure directory
 * @returns {Promise} Resolves to argv
 */
function initializeTerraform() {
  const infraDir = './infrastructure_aws';
  return hclif.terraformInit(infraDir)
    .catch(error => {
      console.log("Failed to initialize terraform in:", infraDir);
      console.log("Error:", error.message);
      return Promise.reject(new Error("Failed to initialize terraform"));
    });
}

/**
 * Runs `terraform plan` in the infrastructure directory
 * @returns {Promise} Resolves to argv
 */
function planTerraform() {
  const infraDir = './infrastructure_aws';
  return hclif.terraformPlan(infraDir)
    .catch(error => {
      console.log("Failed to plan terraform in:", infraDir);
      console.log("Error:", error.message);
      return Promise.reject(new Error("Failed to plan terraform"));
    });
}

/**
 * Runs `terraform apply` in the infrastructure directory
 * @returns {Promise} Resolves to argv
 */
function applyTerraform(argv) {
  const infraDir = './infrastructure_aws';
  return hclif.terraformApply(infraDir)
    .catch(error => {
      console.log("Failed to apply terraform in:", infraDir);
      console.log("Error:", error.message);
      return Promise.reject(new Error("Failed to apply terraform"));
    });
}

function main () {
	console.log('Deploying Infrastructure at Cloud');
	deployInfrastructure();
}

/*When a file is run directly from Node.js, require.main is set to its module . That means that it is possible to determine whether a file has been run directly by testing require.main === module.*/ 
if(require.main === module) {
	main();
}