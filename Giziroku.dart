#import ('GizirokuServer.dart');

void main() {
  GizirokuServer gsv = new GizirokuServer('127.0.0.1', 8000);
  gsv.start();
}
