Написан bar для hyprland
Может запускаться на системах с несколькими мониторами
Проверял на 2k, fullhd и на ноутбуке с fullhd

Виджет с музыкой по идее можно настроить для любого источника,
не только mpd : убрать из команд playerctl вот это "-p mpd"

bar использует следующие утилиты:
    - brightness.yuck:
        brillo
        // ddcci - управление яркостью десктопныx мониторов

    - music.yuck:
        playerctl
        mpc
        mpd
        для обложек нужен mpris

    - volume.yuck:
        wpctl
        pactl
        pavucontrol

    - lang.yuck:
        hyprctl

    - memory.yuck:
        iostat
        qdirstat

    - gpu.yuck
        nvidia-smi

    - cpu.yuck
        // Тут приколы с захардкожеными сенсорами

    - battery.yuck
        upower

    - по мелочи
        sed 
        tr
        awk
        jq
