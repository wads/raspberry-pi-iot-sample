'use strict';
const awsIot = require('aws-iot-device-sdk');
const execSync = require('child_process').execSync;

const thingShadows = awsIot.thingShadow({
    keyPath: "./cert/private.key",
    certPath: "./cert/certificate.pem",
    caPath: "./cert/amazon_root_ca1.pem",
    host: "a36r82m37fyhh3-ats.iot.ap-northeast-1.amazonaws.com"
});

const thingName = execSync('/bin/bash ./get_cpu_serial.sh').toString().trim();

let value1 = null;
let value2 = null;

var clientTokenUpdate;

thingShadows.on('connect', function() {
    thingShadows.register( thingName, {}, function() {
	console.log('register thing shadows ' + thingName);
    });
});

thingShadows.on('status',
		function(thingName, stat, clientToken, stateObject) {
		    console.log('received '+stat+' on '+thingName+': '+
				JSON.stringify(stateObject));
		});

thingShadows.on('delta',
		function(thingName, stateObject) {
		    console.log('received delta on '+thingName+': '+
				JSON.stringify(stateObject));

		    updateShadowAttr(stateObject);
		    clientTokenUpdate = thingShadows.update(thingName, reportData());
		    if (clientTokenUpdate === null){
			console.log('update shadow failed, operation still in progress');
		    }
		});

thingShadows.on('timeout',
		function(thingName, clientToken) {
		    console.log('received timeout on '+thingName+
				' with token: '+ clientToken);
		});


function deltaData(stateObject) {
    return stateObject["state"];
}

function updateShadowAttr(stateObject) {
    const delta = deltaData(stateObject);
    if(delta["value1"]) {
	value1 = delta["value1"];
    }
    if(delta["value2"]) {
	value2 = delta["value2"];
    }
}

function reportData() {
    return {"state": {"desired": null, "reported": {"value1": value1, "value2": value2}}};
}
