схема подключения акселя
в printer.cfg добавить

[adxl345]

cs_pin: PC15

axes_map: x,y,z # тут возможно придется править под ваше расположение осей

spi_software_sclk_pin: PB13

spi_software_mosi_pin: PC3

spi_software_miso_pin: PC2
