'use strict';

console.log('Loading function');

const doc = require('dynamodb-doc');

const dynamo = new doc.DynamoDB();

exports.handler = (event, context, callback) => {

    console.log(event);

    const done = (err, res) => callback(null, {
        statusCode: err ? '400' : '200',
        body: err ? err.message : JSON.stringify(res),
        headers: {
            'Content-Type': 'application/json',
        },
    });

    dynamo.putItem({
        TableName: "terraform-poc-Table",
        Item: event
    }, done);
};