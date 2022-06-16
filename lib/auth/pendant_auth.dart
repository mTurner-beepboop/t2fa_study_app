import 'pointer_pair.dart';

///Contains the authentication logic for the pendant object
bool pendantAuth(List<PointerPair> points) {
  if (points.length == 3){
    return true;
  }
  return false;
}