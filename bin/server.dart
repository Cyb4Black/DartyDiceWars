import 'package:start/start.dart';

main(){
  start(port:8888).then((Server server){
    server.static('build/web', jail: false);
    
    
  });
}