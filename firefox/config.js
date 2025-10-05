// config.js
"use strict";
(() => {
  try {
    const { Services } = globalThis;

    function attach(win) {
      if (!win || win.__ac_keyhandler_installed) return;
      win.__ac_keyhandler_installed = true;

      let buf = "";

      win.addEventListener("keydown", e => {
        const active = win.document.activeElement;

        // --- normal mode: фокус НЕ в input/textarea/contenteditable
        const isNormalMode = !(active &&
          (active.tagName === "INPUT" ||
           active.tagName === "TEXTAREA" ||
           active.isContentEditable)
        );

        // Alt+Shift+N — работает всегда
        if (e.altKey && e.shiftKey && (e.key === "N" || e.key === "n")) {
          const tb = win.gBrowser;
          if (tb && tb.tabs.length > 9) tb.selectedTab = tb.tabs[9];
          e.preventDefault();
          return;
        }

        // --- только в normal mode ---
        if (!isNormalMode) return;

        // если цифра — добавляем в буфер, но не preventDefault,
        // чтобы числа можно было печатать на странице
        if (/^[0-9]$/.test(e.key)) {
          buf += e.key;
          return;
        }

        // g — если есть буфер, прыгаем на вкладку
        if ((e.key === "g" || e.key === "G") && buf.length) {
          const idx = parseInt(buf, 10) - 1;
          buf = ""; // сброс буфера
          const tb = win.gBrowser;
          if (tb && tb.tabs[idx]) tb.selectedTab = tb.tabs[idx];
          // PreventDefault только для g, чтобы не печаталось
          e.preventDefault();
          return;
        }

        // Esc — очистка буфера
        if (e.key === "Escape") {
          buf = "";
          return;
        }

        // Любые другие клавиши — сбрасываем буфер
        if (buf.length) buf = "";
      }, true);
    }

    // Для всех уже открытых окон
    const enumWins = Services.wm.getEnumerator("navigator:browser");
    while (enumWins.hasMoreElements()) attach(enumWins.getNext());

    // Для новых окон
    Services.wm.addListener({
      onOpenWindow(xulWin) {
        const domWin = xulWin.docShell.domWindow;
        domWin.addEventListener("load", function listener() {
          domWin.removeEventListener("load", listener, false);
          attach(domWin);
        });
      },
      onCloseWindow() {},
      onWindowTitleChange() {}
    });
  } catch (ex) {}
})();

