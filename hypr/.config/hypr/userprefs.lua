-- █░█ █▀ █▀▀ █▀█   █▀█ █▀█ █▀▀ █▀▀ █▀
-- █▄█ ▄█ ██▄ █▀▄   █▀▀ █▀▄ ██▄ █▀░ ▄█
--
-- Set your personal hyprland configuration here.
-- This file is loaded last, so anything set here overrides the defaults above.

-- HDR: не переключать монитор в HDR автоматически, когда приложение
-- (mpv, браузер и т.п.) в фуллскрине заявляет HDR-контент.
-- Из-за этого экран становился тёмным. Вернуть: 1 (cm,hdr) или 2 (cm,hdredid).
hl.config({
    render = {
        cm_auto_hdr = 0,
    },
})
