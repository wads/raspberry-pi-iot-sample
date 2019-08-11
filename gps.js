'use strict';

const execSync = require('child_process').execSync;
const SerialPort = require('serialport');
const nmea = require('node-nmea');
const http = require('http');

const API_HOST = 'example.com';
const API_GPS_POINT_PATH = '/path/to/endpoint';

const thingName = execSync('/bin/bash ./get_cpu_serial.sh').toString().trim();

const parsers = SerialPort.parsers;
const parser = new parsers.Readline({
    delimiter: '\r\n'
});

const port = new SerialPort('/dev/serial0', {
    baudRate: 9600
});
port.pipe(parser);
port.on('open', () => console.log('Port open'));

parser.on('data', (raw) => {
    const data = nmea.parse(raw);

    prettyGpsDataPrint(data);
    if (data.valid && data.type === 'GGA') {
        const post_data = {
            ThingSerialNo: thingName,
            Latitude: data.loc['geojson']['coordinates'][1].toString(),
            Longitude: data.loc['geojson']['coordinates'][0].toString(),
            PositioningDatetime: data.datetime
        };
        const post_data_str = JSON.stringify(post_data);
        let options = {
            host: API_HOST,
            path: API_GPS_POINT_PATH,
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Content-Length': post_data_str.length
            }
        };
        let req = http.request(options, (res) => {
            res.setEncoding('utf8');
            res.on('data', (chunk) => {
                console.log('BODY: ' + chunk);
            });
        });
        req.on('error', (e) => {
            console.log('problem with request: ' + e.message);
        });
        req.write(post_data_str);
        req.end();
    }
});

function prettyGpsDataPrint(data) {
    console.log('----------');
    console.log('raw: ' + data.raw);
    console.log('valid: ' + data.valid);
    console.log('type: ' + data.type);
    console.log('gps: ' + data.gps);
    console.log('datetime: ' + data.datetime);
    console.log('loc: ');
    console.log(data.loc);
    console.log('speed: ' + data.speed);
    console.log('track: ' + data.track);
    console.log('magneticVariation: ' + data.magneticVariation);
    console.log('mode: ' + data.mode);
}
