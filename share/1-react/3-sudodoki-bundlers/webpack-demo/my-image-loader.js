const sizeOf = require('image-size');
const getPlaceholder = require('./create-image');
module.exports = function(content) {
  const dimensions = sizeOf(this.resourcePath);
  return getPlaceholder(dimensions.width, dimensions.height);
};
