'use strict'

const yargs = require('yargs');
let hclif = require('./hclif');

/**
 * Runs `terraform destroy`` in the infrastructure directory
 * @returns {Promise} Resolves to argv
 */
function destroyInfrastructure(argv) {
  const infraDir = './infrastructure_aws';
  return hclif.terraformDestroy(infraDir)
    .catch(error => {
      console.log("Failed to destroy terraform in:", infraDir);
      console.log("Error:", error.message);
      return Promise.reject(new Error("Failed to destroy terraform"));
    });
}

function destroy () {
	console.log('Destroy Infrastructure at Cloud!!!');
	destroyInfrastructure();
}

/*When a file is run directly from Node.js, require.main is set to its module . That means that it is possible to determine whether a file has been run directly by testing require.main === module.*/ 
if(require.main === module) {
	destroy();
}