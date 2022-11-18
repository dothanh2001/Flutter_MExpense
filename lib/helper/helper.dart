bool isEmpty(var object) {
  if (object == false ||
      object == 'false' ||
      object == 'null' ||
      object == 'N/A' ||
      object == null ||
      object == {} ||
      object == '') {
    return true;
  }
  if (object is Iterable && object.length == 0) {
    return true;
  }
  return false;
}




