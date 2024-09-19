#!/bin/bash

# Directorio donde están tus archivos CSV
LOG_DIR="/home/catlegs/logs"
CONFIG_FILE="/etc/logstash/conf.d/temp_csv_to_es.conf"

# Recorre todos los archivos CSV en el directorio
for file in "$LOG_DIR"/*.csv; do
  echo "Procesando archivo: $file"

  # Crea un archivo de configuración temporal para Logstash
  cat > "$CONFIG_FILE" <<EOL
input {
  file {
    path => "$file"
    start_position => "beginning"
    sincedb_path => "/dev/null"
    codec => "plain"
  }
}

filter {
  throttle {
    after_count => 1
    period => 1
    key => "%{host}"
    add_tag => "throttled"
  }
  csv {
    separator => "|"
    columns => [
      "id", "left", "state", "severity", "priority", "category",
      "nodehints_dnsname", "control_external_id", "sistema",
      "aplicacion", "fec_crea", "asignada", "u_asignado",
      "grupo_asignado", "resuelto", "u_resuelto", "g_resuelto",
      "cerrado", "u_cerrado", "g_cerrado", "duplicate_count",
      "replace"
    ]
  }
}

output {
  elasticsearch {
    hosts => ["https://localhost:9200"]
    index => "alarmas_actual"
    ssl_verification_mode => "none"  # Actualizado aquí
    user => "elastic"
    password => "hola123"
  }
  stdout { codec => rubydebug }
}
EOL

  # Ejecuta Logstash con el archivo de configuración temporal
  sudo /usr/share/logstash/bin/logstash -f "$CONFIG_FILE"

  # Espera un tiempo antes de procesar el siguiente archivo para no sobrecargar
  sleep 30  # Aquí puedes ajustar el tiempo de espera en segundos
done