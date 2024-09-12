Para usar Kibana, lo instalaremos en nuestro ordenador principal y no en la máquina virtual, pero antes de hacer eso debemos crear un usuario específico de Kibana en Elasticsearch.
Esto se debe a que no podemos usar el superusuario "elastic" como hemos estado haciendo previamente.

## 1. Creamos usuario

1. Accedemos a Elasticsearch en nuestra MV.
```
docker exec -it elasticsearch /bin/bash
```
2. Creamos el usuario:
Reemplaza `<elastic_password>` con la contraseña del usuario `elastic` y `<kibana_user_password>` con la contraseña que deseas asignar al nuevo usuario `kibana_user`.
```
curl -X POST "https://localhost:9200/_security/user/kibana_user" -H "Content-Type: application/json" -u elastic:<elastic_password> -d'
{
  "password": "<kibana_user_password>",
  "roles": ["kibana_system"],
  "full_name": "Kibana User",
  "email": "kibana_user@example.com"
}' --insecure
```

## 2. Configuramos el pull de Kibana

1. Desde nuestro Docker desktop, fuera de la MV, descargamos la última imagen de Kibana.

2. Una vez descargada, ejecutamos este comando desde la consola de Docker desktop:
```
docker run --name kibana -p 5601:5601 -e ELASTICSEARCH_HOSTS="https://10.228.64.170:9200" -e ELASTICSEARCH_USERNAME="kibana_user" -e ELASTICSEARCH_PASSWORD="<kibana_user_password>" -e ELASTICSEARCH_SSL_VERIFICATIONMODE=none -d docker.elastic.co/kibana/kibana:8.10.2

```
	Asegurate de cambiar los parametros apropiadamente.

3. Vamos a nuestro navegador a http://localhost:5601 y miramos si funciona.
4. En caso de no funcionar, podemos revisar los logs desde Docker desktop directamente (categoría "Logs") al clicar nuestro contenedor.