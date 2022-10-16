подключение драйверов по юарт 

лучше всего обратитесь к профессионалам!(я вас предупреждал)

необходимо выпаять резисторы(устарело, можно резисторы не выпаивать) и припаять провода как указано на фото

в ```printer.cfg``` добавляем строчку ```[include tmc.cfg]```
копируем файл [tmc.cfg](tmc.cfg) в папку  клиппера рядом с ```printer.cfg``` 

необходимо исправить microstep в разделах принтера и поправить шаги экструдера.
на данный момент часть моего printer.cfg выглядит так:

```cfg
[stepper_x]
step_pin: PE3
dir_pin: !PE2
enable_pin: !PE4
microsteps: 16
rotation_distance: 40
endstop_pin: !PA15
position_endstop: 1
position_max: 255
homing_speed: 40

[stepper_y]
step_pin: PE0
dir_pin: !PB9
enable_pin: !PE1
microsteps: 16
rotation_distance: 40
endstop_pin: !PD2
position_endstop: 1
position_max: 220
homing_speed: 40


[extruder]
step_pin: PD6
dir_pin: PD3
enable_pin: !PB3
microsteps: 16
rotation_distance: 7.839
max_extrude_only_distance: 1400.0
nozzle_diameter: 0.400
filament_diameter: 1.750
heater_pin: PE5
sensor_type: Generic 3950
sensor_pin: PC1
#control: pid
#pid_Kp: 14.669
#pid_Ki: 0.572
#pid_Kd: 94.068
min_temp: 0
max_temp: 320
pressure_advance = 0.022
```
так как у меня еще подключена ось Z по UART но это в 99.9% случаях не надо, его конфиг здесь не приведен чтобы вас не путать. свой конфиг по Z оставляем как в основной части.
обратите внимание что цифры на ваших принтерах могут отличаться, коофициент pressure_advance это примерная настройка ничего не значащая для вас, настраивайте сами!
![1](1.jpg)
![2](2.jpg)
![3](3.jpg)
![4](4.jpg)

если все сделать правильно,получится как то так:

![5](itog.jpg)
