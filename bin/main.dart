import 'package:start/start.dart';

main(){
  start(port:3000).then((Server server){
    server.static('build/web', jail: false);
    
    
  });
}