'use strict';

const fs 					= require('fs');
const ChildProcess 			= require('child_process');
const terraformStateFileDir	= "terraform_state_files";
const indexFile				= require('./index');


/**
* This function check for state file exists for resource or not
* @param providerInfo - having blueprint and provider details
*
*/
exports.resourceExists = function (providerInfo) {
	const path= "./infrastructure_"+providerInfo.name+'/'+terraformStateFileDir+'/'+providerInfo.env+'-'+providerInfo.appname;
	let resouceExists = false;
	return new Promise((resolve, reject) => {
		if (fs.existsSync(path)) {
			resouceExists = true
			resolve(indexFile.askingForConfirmation(resouceExists, providerInfo));
		} else {
			resouceExists = false
			resolve(indexFile.askingForConfirmation(resouceExists, providerInfo));
		}
	});
	
}
/**
* This function update the source path based on blueprint
* @param result - having blueprint and provider details
*
*/
exports.sourcePathUpdate = function (providerInfo) {
	let filePath = "./infrastructure_"+providerInfo.name+"/main.tf"
	let findText = "";
	let replaceWith = '\tsource = "./blueprint/'+providerInfo.blueprint+'"';
	let patten = /source/gi;
	
	return new Promise((resolve, reject) => {
		fs.readFile(filePath, 'utf8', function(err, data) {
			if (err) {
			  Promise.reject(new Error("Failed to update main.tf"))
			}
			 data = data.toString();
			 data.split('\n').forEach(function (line) {
				 if(line.match(patten)){				 
					 findText = line;
				 }
				 
			 });
			let replaceText = data.replace(findText,replaceWith);		
			fs.writeFile(filePath, replaceText, 'utf8', function(err) {
				if (err) {
				   Promise.reject(new Error("Failed to update main.tf"))
				};
			});
		});
	});
}

/**
 * Initializes the terraform working directory
 * @param {Object} provider information The directory of the infrastructure code
 * @returns {Promise} Resolves to undefined for Rejects with an error
 */
exports.terraformInit = function (providerInfo) {
  return runCommand('terraform', ['init'], "infrastructure_"+providerInfo.name)
    .catch(error => {
      if (error) {
        return Promise.reject(new Error("terraform init failed: " + error.message));
      } else {
        return Promise.reject(new Error("terraform init failed: unknown reason"));
      }
    });
};

/**
 * Runs plan command of terraform
 * @param {Object} provider information including directory of the infrastructure code
 * @returns {Promise} Resolves to undefined for Rejects with an error
 */
exports.terraformPlan = function (providerInfo) {
  const terraformStateFile = providerInfo.env+"-"+providerInfo.appname;
  const providerDir = "infrastructure_"+providerInfo.name;
  // terraform plan    
  return runCommand('terraform', ['plan', '-var=application='+providerInfo.appname, '-var=environment='+providerInfo.env, '-state='+terraformStateFileDir+'/'+terraformStateFile+'/'+terraformStateFile], providerDir)
    .catch(error => {
      if (error) {
        return Promise.reject(new Error("terraform plan failed: " + error.message));
      } else {
        return Promise.reject(new Error("terraform plan failed: unknown reason"));
      }
    });
};


/**
 * Runs apply command of terraform
 * @param {Object} provider information including directory of the infrastructure code
 * @returns {Promise} Resolves to undefined for Rejects with an error
 */
exports.terraformApply = function (providerInfo) {
  const terraformStateFile = providerInfo.env+"-"+providerInfo.appname;
  const providerDir = "infrastructure_"+providerInfo.name;
  // terraform apply
  return runCommand('terraform', ['apply', '-var=application='+providerInfo.appname, '-var=environment='+providerInfo.env, '-state='+terraformStateFileDir+'/'+terraformStateFile+'/'+terraformStateFile, '-auto-approve'], providerDir)
    .catch(error => {
      if (error) {
        return Promise.reject(new Error("terraform apply failed: " + error.message));
      } else {
        return Promise.reject(new Error("terraform apply failed: unknown reason"));
      }
    });
};

/**
 * Runs destroy command of terraform
 * @param {Object} providerInfo including directory of the infrastructure code
 * @returns {Promise} Resolves to undefined for Rejects with an error
 */
exports.terraformDestroy = function (providerInfo) {
  const terraformStateFile = providerInfo.env+"-"+providerInfo.appname;
  const providerDir = "infrastructure_"+providerInfo.name;	
  // terraform apply
  return runCommand('terraform', ['destroy', '-var=application='+providerInfo.appname, '-var=environment='+providerInfo.env, '-state='+terraformStateFileDir+'/'+terraformStateFile+'/'+terraformStateFile, '-auto-approve'], providerDir)
    .catch(error => {
      if (error) {
        return Promise.reject(new Error("terraform destroy failed: " + error.message));
      } else {
        return Promise.reject(new Error("terraform destroy failed: unknown reason"));
      }
    });
};


function runCommand(command, args, dir) {
  return new Promise((resolve, reject) => {
    const cmd = ChildProcess.spawn(command, args, {
      cwd: dir
    });
	
    cmd.stdout.on('data', data => {
      data = data.toString('utf8');      
	  console.log(data);
    });
    cmd.stderr.on('data', data => {
      console.log("Error::"+data);
	  
    });
	cmd.on('close', code => {		
      if (code == 0) {
        resolve();
      } else {       
        reject(new Error(command + " failed"));
      }
    });
  });
}