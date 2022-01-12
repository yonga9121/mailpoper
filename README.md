# MAILPOPER

Hola, soy Jorge. Mailpoper es una app integrada con aweaber.com.
Cada que un usuario se registra, se envia un email de confirmacion automaticamente.

# Como usar mailpoper?

Debes enviar un POST request a la direccion con los datos de usuario. Mailpoper validara que los datos sean correctos y procedera a registrar al usuario. Luego de 1 minuto sera enviado un email para que el registro sea confirmado (revisa smap).

Aca esta como enviar el request usando curl 

```
curl -d '{"user": {"email": "tuemail@nose.com", "name": "Tu nombre", "phone": 1010101010, "send_info": true } }' \
-H "Content-Type: application/json" -X POST https://mailpoper.herokuapp.com/users/create
```

# Como funciona la integracion con aweaber?

Se contruyo un servicio `aweaber.rb` que contiene la logica para conectarse con el api de aweaber. 

La app guarda un registro de la cuenta de aweaber `AweaberAccount` y se encarga de refrescar los tokens cuando se vencen.

Hay un cron job en sidekiq que envia los emails de registro cada minuto

# Como correr mailpoper en local?

Mailpoper funciona con varios servicios gratuitos en la nube: mongodb, redis y aweaber. Solo necesitas las urls y llaves de estos servicios

Configura tu entorno con las variables

`REDIS_TLS_URL`, `MONGO_URL`, `AWEABER_CLIENT_ID`, `AWEABER_CLIENT_SECRET`

Debes ejecutar 3 procesos en tu computadora o entorno.

1. rails `rails server`
2. sidekiq `bundle exec sidekiq`
3. clockwork `bundle exec clockwork lib/clockwork`

Por que clockwork? Es lo que utilice para enviar los emails a traves de sidekiq cada minuto. Es bastante sencillo de configurar y de desplegar. Todo lo relacionado a clockwork esta en `clockwork.rb`

# Como esta desplegado ?

Esta desplegado en 2 servidores de heroku para un total de 3 dynos free,

En https://mailpoper.herokuapp.com/ esta rails server y sidekiq. En este heroku esta desplegado el branch `master`.

En https://mailpoperclock.herokuapp.com/ esta clockwork. En este heroku esta desplegado el branch `clock`.

Por que 2 herokus? por que el limite de dynos por heroku son 2 y necesitaba 3.

# Como usar otra cuenta Aweaber Api ?

Debes cambiar las variables `AWEABER_CLIENT_ID`, `AWEABER_CLIENT_SECRET` y `AWEABER_REDIRECT_URL`
por las tuyas y **borrar los datos del modelo AweaberAccount**.

Luego de eso debes entrar al root de la app, autorizar mailpoper para usar tu cuenta entrando a https://mailpoper.herokuapp.com. Te entregara una url a la que debes entrar para completar el proceso.

Una vez hayas autorizado mailpoper, puedes registrar los usuarios en tu cuenta.

