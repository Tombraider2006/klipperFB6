перед началом печати можно немножко почистить сопло от вытекающего филамента.

![shetka_3d](./assets/images/clean_nozle/shetka_3d.jpg)

распечатываем 

[держатель щетки](./assets/stl/clean_nozle/shetka_3d.STL)

монтируем:

![монтаж](./assets/images/clean_nozle/assembl.jpg)



В ```printer.cfg``` добавляем:


 ```bash
 [gcode_macro Clean_nozle]
gcode:
    G1 X1 Y20 F10000 
    G1 X1 Y130 F10000
    G1 X1 Y70 F10000
    G1 X1 Y130 F10000
    G1 X1 Y70 F10000
    G1 X1 Y130 F10000
    G1 X1 Y20 F10000
 ```
 
 
Теперь в начальный код слайсера можно просто вписать Clean_nozle 
  
Саму щетку брал [тут](http://alii.pub/6hz9dc) обрезал оставив самое важное. 
