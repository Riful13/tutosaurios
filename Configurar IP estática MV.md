1. Para empezar desde windows encendemos el PowerShell y hacemos un 
```
ipconfig
```

De todos los resultados queremos este, y guardamos nuestra IP, en mi caso es así:

> [!NOTE]
> Adaptador de Ethernet Ethernet 3:
> 
>    Sufijo DNS específico para la conexión. . :
>    Vínculo: dirección IPv6 local. . . : fe80::4e2e:ec3d:f64b:1cdc%21
>    Dirección IPv4. . . . . . . . . . . . . . : 192.168.56.1
>    Máscara de subred . . . . . . . . . . . . : 255.255.255.0
>    Puerta de enlace predeterminada . . . . . :

2.  En VirtualBox vamos a las Opciones de nuestra MV, seleccionamos Red, y cambiamos el Adaptador 1 a "Adaptador sólo anfitrión"
3. Arrancamos la MV, y abrimos la terminal:
```
sudo nano /etc/network/interfaces
```
4. Debemos asignar una IP personalizada.

**IMPORTANTE**: Si tu IP base es `192.168.56.0` o similar, solo cambia el último número para evitar conflictos con otras IPs. En mi caso, asigné `192.168.56.2`. Asegúrate de que el último número sea diferente a cualquier otra IP en la red.


El fichero en su totalidad se debería parecer a lo siguiente:

> [!NOTE]
> source /etc/network/interfaces.d/*
> 
> (#) The loopback network interface
> auto lo
> iface lo inet loopback
> 
> auto enp0s3
> iface enp0s3 inet static
> address 192.168.56.2
> netmask 255.255.255.0

5. Podemos reiniciar la máquina o simplemente hacer:
```
sudo systemctl restart networking
```
