'use strict';

let ChildProcess = require('child_process');


/**
 * Initializes the terraform working directory
 * @param {String} dir The directory of the infrastructure code
 * @returns {Promise} Resolves to undefined for Rejects with an error
 */
exports.terraformInit = function (dir) {
  return runCommand('terraform', ['init'], 'infrastructure_'+dir.provider)
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
 * @param {String} dir The directory of the infrastructure code
 * @returns {Promise} Resolves to undefined for Rejects with an error
 */
exports.terraformPlan = function (dir) {
  // terraform plan  
  return runCommand('terraform', ['plan', '-var=blueprint_key='+dir.blueprint], 'infrastructure_'+dir.provider)
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
 * @param {String} dir The directory of the infrastructure code
 * @returns {Promise} Resolves to undefined for Rejects with an error
 */
exports.terraformApply = function (dir) {
  // terraform apply
  return runCommand('terraform', ['apply', '-var=blueprint_key='+dir.blueprint, '-auto-approve'], 'infrastructure_'+dir.provider)
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
 * @param {String} dir The directory of the infrastructure code
 * @returns {Promise} Resolves to undefined for Rejects with an error
 */
exports.terraformDestroy = function (dir) {
  // terraform apply
  return runCommand('terraform', ['destroy', '-var=blueprint_key='+dir.blueprint, '-auto-approve'], 'infrastructure_'+dir.provider)
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