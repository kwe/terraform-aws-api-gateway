exports.handler = async (event) => {
  let response = {
    "isAuthorized": false,
    "context": {
      "stringKey": "stringValue",
      "numberKey": 1,
      "booleanKey": true,
      "arrayKey": [
        "stringValue",
        1,
      ]
    }
  }

  if (event.headers.authorization === "Bearer 1234") {
    response = {
      "isAuthorized": true,
      "context": {
        "stringKey": "stringValue",
        "numberKey": 1,
        "booleanKey": true,
        "arrayKey": [
          "stringValue",
          1,
        ]
      }
    };
  }
  return response;
}
