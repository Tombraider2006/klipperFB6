**Conexión de una impresora a través de UART**

La confucion principal se genera en los usuarios con la asiganacion del numero UART, memoricemos una regla comun: en printer.cfg anotamos el numero UART en single board,al compilar el firmware en el menu config escribimos el numero UART de la plaqueta de la impresora.
Conectamos como esta señalado en la foto.

```bash
sudo armbian-config
```
Sector system subsector hardware - activamos UART3

![1](arm_conf.jpg)

Modificamos el firmware para conectar UART

```bash
cd ~/klipper
make clean
make menuconfig
```
Micro-Controller architecture -  STM32

Processor model - STM32F407

Bootloader offset - 48KiB bootloader

Comunication Interface - Serial (on USART1 PA10/PA9)

![1](menuconfig.jpg)

Presionamos Q guardando los cambios y compilamos el firmware.

```
make
```
El firmware esta compilado y se encuentra en la carpeta
 ~/klipper/out/klipper.bin lo retiramos y lo renombramos Robin_nano_4.bin, lo copiamos 
a la tarjeta de memoria y prendemos la imresora.La instalacion del firmware ocupa algo
de un minuto.Si el firmware se instalo correctamente en sutarjeta de memoria aparecera
 el arcivo Robin_nano_4.cur OrangePi 3 LTS para la coneccion UART utilice overlay UART3 y /dev/ttyS3.

En printer.cfg buscamos mcu y cambiamos por
```
[mcu]
serial: /dev/ttyS3
restart_method: command
```
abajo se muestran las fotos donde se colocan los cables.

![1](pin_orange.jpg)
![2](pin_mcu.jpg)

