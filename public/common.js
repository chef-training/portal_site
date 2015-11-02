function performOperation(operationName) {
  console.log("Requesting server execute command @ /" + operationName);
  $.ajax({ url: operationName, data: {}, dataType: "json" });
}
