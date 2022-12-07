**на данный конфиг в разработке, не все данные могут быть верными.**

Данный конфиг верен для версии головы KARAS c экструдером BIQU H2 V2

в секцию `[stepper_z]` необходимо найти исправить следующие строки чтобы они выглядели так:

```gcode
#endstop_pin: !PC8 
endstop_pin: probe:z_virtual_endstop
#position_endstop: 0.5
```

Создаем новый раздел и вписываем это:

```gcode
[bltouch]

sensor_pin: ^PC4
control_pin: PA8
y_offset: -17.85
z_offset: 2.0
x_offset: 22.65
speed: 10.0
samples: 2
samples_result: median
sample_retract_dist: 3.0
samples_tolerance: 0.1
samples_tolerance_retries: 1


[safe_z_home]
home_xy_position: 105,121                                                       # CAUTION! Depends on probe X/Y offset
z_hop: 10
move_to_previous: True                                                       # Return back ~X0/Y0 after Z0 at center
z_hop_speed: 10
speed: 50
[gcode_macro G29]
gcode:
    BED_MESH_CLEAR
    G28
    BED_MESH_CALIBRATE
    BED_MESH_PROFILE SAVE=name
    SAVE_CONFIG
    BED_MESH_PROFILE LOAD=name

[bed_mesh]
speed: 40
horizontal_move_z: 5 # отступ во время проб по оси Z
mesh_min: 30,10 
mesh_max: 245,185 # стол с учетом сдвига на bltouch
probe_count: 6,4 # здесь мы ставим количество точек проб по икс и по игрек

[screws_tilt_adjust]
screw4: 10,25 
screw4_name: front left screw
screw1: 192,45
screw1_name: front right screw
screw2: 192,192 
screw2_name: back right screw
screw3: 25,192
screw3_name: back left screw
speed: 150
screw_thread: CW-M4
```

юстировка через klippersreen:

![](screen.jpg)

калибровка стола:

![](table.jpg)