# Orange Pi 3 LTS — фикс SPI1/CS (короткая инструкция)

Цель: включить аппаратный CS (ALT2) для SPI1, получить стабильный `/dev/spidev1.0` и корректную работу с устройствами (например, ADXL345).

## 1) Включить один spidev-оверлей
1. Открой `armbianEnv.txt`:
```bash
sudo nano /boot/armbianEnv.txt
```
2. Оставь только один SPI spidev-оверлей и одну CS:
```
overlays=spi-spidev1
param_spidev_spi_bus=0
param_spidev_spi_cs=0
```
3. Перезагрузка:
```bash
sudo reboot
```

Проверка:
```bash
ls /dev/spi*
gpio readall
```
- Должен появиться `/dev/spidev1.0`.
- Для MOSI.1/MISO.1/SCLK.1/CE.1 режим — ALT2 (не OFF).

## 2) Если CS всё ещё OFF — правка базового DTB
1. Бэкап и декомпиляция:
```bash
sudo cp /boot/dtb/allwinner/sun50i-h6-orangepi-3-lts.dtb /boot/dtb/allwinner/sun50i-h6-orangepi-3-lts.dtb.bak
sudo dtc -I dtb -O dts -o /boot/dtb/allwinner/sun50i-h6-orangepi-3-lts.dts /boot/dtb/allwinner/sun50i-h6-orangepi-3-lts.dtb
sudo nano /boot/dtb/allwinner/sun50i-h6-orangepi-3-lts.dts
```
2. В узле `spi@5011000`:
- `status = "okay";`
- корректный `pinctrl-0` на пины SPI1 + CS
- добавить `spidev@0` (или `spidev@1`, если используешь CS1):
```dts
spi@5011000 {
    compatible = "allwinner,sun50i-h6-spi","allwinner,sun8i-h3-spi";
    status = "okay";
    pinctrl-names = "default";
    pinctrl-0 = <0x31 0x32>; // phandle для spi1_pins и spi1_cs (могут отличаться в твоём DTS)
    #address-cells = <1>;
    #size-cells = <0>;

    spidev@0 {
        compatible = "armbian,spi-dev";
        reg = <0>;
        spi-max-frequency = <1000000>;
    };
};
```
3. Компиляция обратно и перезагрузка:
```bash
sudo dtc -I dts -O dtb /boot/dtb/allwinner/sun50i-h6-orangepi-3-lts.dts -o /boot/dtb/allwinner/sun50i-h6-orangepi-3-lts.dtb
sudo sed -i '/^overlays=.*spi/d' /boot/armbianEnv.txt   # убрать старые SPI-оверлеи
sudo reboot
```

## 3) Финальная проверка
```bash
ls /dev/spi*
gpio readall
```
- `/dev/spidev1.0` присутствует.
- MOSI/MISO/SCLK/CS — в ALT2.
- Тест-петля MISO↔MOSI даёт устойчивое эхо; реальное устройство отвечает без сбоев CS.

## Источник
- Форум Armbian (Orange Pi 3 LTS, SPI/CS, с примерами DTS/DTB):
  - https://forum.armbian.com/topic/28425-spi-problem-with-orange-pi-3-lts/#comment-181851
