схема подключения акселерометра
в printer.cfg добавить

[adxl345]

cs_pin: PC15

axes_map: x,y,z # тут возможно придется править под ваше расположение осей

spi_software_sclk_pin: PB13

spi_software_mosi_pin: PC3

spi_software_miso_pin: PC2

[resonance_tester]

accel_chip: adxl345

probe_points:
  100, 100, 20


![adxl345](adxl345.jpg)
