import 'package:start/start.dart';

main(){
  start(port:8080).then((Server server){
    server.static('build/web', jail: false);
    
    
  });
}