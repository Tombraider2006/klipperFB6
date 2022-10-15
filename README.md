 <h2>klipper_config</h2>
в папке конфиг клиппера на flying bear ghost 6 
по этому конфигу каждый день работает принтер. так что 100% рабочий, но все мы люди и иногда бывают ошибки.  
стараюсь оперативно исправлять и дополнять по мере освоения
 <h2>adxl345_2_mcu</h2>
 в папке adxl345_2_mcu описан способ подключения акселерометра к плате принтера.
 
  <h2>drivers_uart</h2>
  в папке drivers_uart краткий мануал по распайке драйверов по юарт для платы MKS Robin Nano v4 3.1
  
 <h2>mcu_uart</h2>
 наглядно о подключении orange pi 3 lts к плате принтера. 
 
  <h2>bme280</h2>
  Подключение датчика температуры BME280
  
    <h2>clean_nozle</h2>
  монтаж щетки очистки сопла, модель, макрос.
  
 <h2>остальное</h2>
клипперскрин подключен по https://sergey1560.github.io/fb4s_howto/mks_ts35/ этому мануалу.

клипперскрин если у вас raspberry https://github.com/willngton/3DPrinterConfig/blob/main/mks_ts35/mks_ts35_guide_archived.md или https://github.com/evgs/FBG6-Klipper/blob/main/Klipperscreen-RPI.md

глюки spi при подключении акселерометра можно устранить по этому мануалу https://github.com/orangepi-xunlong/wiringOP (обычно глюк в 24 не работающем пине исправляется установкой этого git и командой  sudo gpio mode 15 ALT2  
добавил схему подключения акселерометра непосредственно к плате принтера смотри раздел adxl_2_mcu

Автоперезапуск сервиса klipper после включения принтера
https://mirv.top/2021/10/08/avtoperezapusk-servisa-klipper-posle-vklyucheniya-printera/

https://flyingbear.info/firmware/klipper/klipper_config - полезный ресурс от 5 мишки, там про то как настройть например вебкамеру.  и не только. многое подойдет на 6 мишку если не забывать что у нас разные платы)

https://github.com/makerbase-mks/MKS-Robin-Nano-V3.X/tree/main/hardware/MKS%20Robin%20Nano%20V3.1_001 распиновка платы - да она под сьемные драйвера в остальном сопадает с мишко6. использрвать когда надо узнать какой пин в клиппере написать.

https://klipper.wiki/ru/home/initial/peripheral хорошее wiki по клипперу. когда мне лень писать и я пишу что посмотрите сами, лезьте на этот ресурс вероятнее найдете подробную инструкцию 

https://t.me/fbg5_waiters телеграм чат где есть многое, если не всё для владельца flying bear ghost 6  он же просто мишка 6. 


