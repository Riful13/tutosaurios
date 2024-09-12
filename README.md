### 1. **Instalar Docker en Debian (si no lo tienes instalado)**


## Hacer que tu usuario sea sudo

` sudo usermod -aG sudo abd`

Si Docker ya está instalado, puedes saltarte este paso. Si no, sigue estos pasos para instalar Docker:

`sudo apt update`
`sudo apt install docker.io`
`sudo systemctl start docker`
`sudo systemctl enable docker`
`sudo usermod -aG docker $USER`

Cerrar sesión e iniciarla de nuevo.

### 2. **Descargar y arrancar elasticsearch en Docker**

`docker pull docker.elastic.co/elasticsearch/elasticsearch:8.10.2`

Y ejecutamos:

```
docker run -d --name elasticsearch -p 9200:9200 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:8.10.2
```
`
Si la página localhost:9200 no funciona, o curl -X GET "localhost:9200/"
no da respuesta, usaremos el protocolo seguro:

https://localhost:9200/

curl -XGET "https://localhost:9200/" --insecure

==La contraseña es algo parecido a esto:== 
oD-1_yGwLgETidDHXrY-
### 2.1 **En caso de no saber la contraseña**

1.  Accederemos al contenedor de Elasticsearch (Debe estar en ejecución)
```
docker exec -it elasticsearch /bin/bash
```

```
bin/elasticsearch-reset-password -u elastic
```

Ahora podemos acceder desde el navegador con el usuario **elastic** y la contraseña generada automáticamente.

También podemos cambiar la contraseña por la que queramos con lo siguiente:

1. Entramos al contenedor Docker de elastic search:

```docker exec -it elasticsearch /bin/bash
```

2. Ejecutamos lo siguiente, cambiando los campos "current_password" y "your_new_password"
```curl -X POST "https://localhost:9200/_security/user/elastic/_password" -u elastic:current_password --insecure -H 'Content-Type: application/json' -d'
{
  "password": "your_new_password"
}'
```
También podemos usar:

`curl -u elastic:<password> -X GET "https://localhost:9200/" --insecure`

### 2.2 **En caso de querer enviar el archivo a la maquina mediante SSH**.

`scp /ruta/al/archivo.xls usuario@ip_de_la_vm:/ruta/destino`

## Sergi estupid error que no m'ha dit:

Si ho fas desde wsl la ruta es diferent que la de windowss
```
scp /mnt/c/Users/albert.burgos.ext/Documents/alarmas.csv  abd@10.228.64.167:/home/abd/Downloads
```
### 3. ***Instalar y configurar Logstash***

1.  Agregamos las keys y repositorio de Logstash
```
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo sh -c 'echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" > /etc/apt/sources.list.d/elastic-8.x.list'
```

2. Instalamos
```
sudo apt update
sudo apt install logstash
```

3.  Configuramos
```
sudo nano /etc/logstash/conf.d/csv_to_es.conf

```
4. Agregamos los datos:
==Hay datos que teneis que cambiar porque es depende de tu maquina y tal== 
```
input {
  file {
    path => "/home/abd/Downloads/alarmas.csv"  # Ajusta la ruta según corresponda
    start_position => "beginning"
    sincedb_path => "/dev/null"  # Para que el archivo se lea desde el principio cada vez que se ejecute Logstash
    codec => "plain"
  }
}

filter {
  csv {
    separator => ","
    columns => ["id", "left", "state", "severity", "priority", "category", "nodehints_dnsname", "control_external_id", "system_name"]  # Corregí la lista y el nombre de la última columna
  }
}

output {
  elasticsearch {
    hosts => "http://localhost:9200"
    index => "alarmas_test"
    user => "elastic"   
    password => "oD-1_yGwLgETidDHXrY-"  # Asegúrate de no compartir contraseñas en público
  }
  stdout { codec => rubydebug }
}

```
6. Ejecutamos logstash:
```
sudo logstash -f /etc/logstash/conf.d/csv_to_es.conf
```

Si no encuentra el comando, probar:

```
sudo /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/csv_to_es.conf

```


## Para ejecutar elastic en caso de que lo hayamos cerrado o algo

``docker start elasticsearch

### 4. Verificar datos en Elasticsearch
1.  **Acceder a Elasticsearch desde el navegador**: Navega a `https://localhost:9200/_cat/indices?v` para ver los índices disponibles y verificar que el índice se haya creado.

2. **Buscar los datos en el índice**: Utiliza el siguiente comando `curl` para buscar datos en el índice:
```
curl -X GET "https://localhost:9200/nombre_del_indice/_search?pretty" --insecure
```
