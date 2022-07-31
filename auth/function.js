exports.handler = async (event) => {
  let response = {
    isAuthorized: false,
    context: {
      stringKey: 'stringValue',
      numberKey: 1,
      booleanKey: true,
      arrayKey: ['stringValue', 1],
    },
  };
  console.log(event);

  if (event.headers.authorization === 'letmein') {
    response = {
      isAuthorized: true,
      context: {
        stringKey: 'stringValue',
        numberKey: 1,
        booleanKey: true,
        arrayKey: ['stringValue', 1],
      },
    };
  }
  return response;
};
