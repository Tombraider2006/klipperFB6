*<h2>Макросы в одном месте.</h2>*

Конечно можно пихать все макросы в основноф файл `printer.cfg` но через какое то время вы там совсем потеряетесь. Поэтому лучше добавить строчку `[include имя_файла.cfg]` в любом месте вашего `printer.cfg` где всегда можно отключить или включить его. можно создать папку с макросами и сделать изящнее `[include macros/*.cfg]` и все файлы оттуда будут добавляться в вашу конфигурацию как бы вы их не назвали.

**Ahtung! Attention! Внимание!**
если есть имена например подсветки в макросе, то они должны совпадать с вашими именами в конфигурационном файле. Читайте документацию!

**Смена Филамента**

Чтобы делать полосатенькие модели например так:

![](filament_change.jpg)

Нам  нужен [этот](filament.cfg) макрос *!Настроен под голову стоковую для 6 мишки.*

Составной макрос смены филамента. Ставит на паузу PAUSE, вызывает макрос FILAMENT_UNLOAD для выгрузки филамента, подаёт звуковой сигнал BEEP, COUNTDOWN ждёт 5 минут, пока вы заправите новый филамент в фидер, снова подаёт звуковой сигнал и FILAMENT_LOAD загружает филамент, RESUME запустит печать дальше, если макрос был вызван в процессе печати, например из G-code.

**Чистка сопла** 

Этот макрос подьезжает к определенному месту и водит туда сюда по латунной щетке, [подробнее тут](../clean_nozle/readme.md) Быстро скачать [тут](clean.cfg)

![](../clean_nozle/assembl.jpg)

**Макросы для RGB подсветки**

подробнее [тут](../led_rgb/readme.md)

Скачать одним файлом можно [тут](led.cfg)


![](../led_rgb/party.gif) 

