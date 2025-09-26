#!/usr/bin/env python3
import subprocess
import json
import socket
import os

def run_hyprctl(cmd):
    """Запускает hyprctl и возвращает JSON"""
    result = subprocess.run(
        ["hyprctl", cmd, "-j"],
        capture_output=True,
        text=True,
        check=True
    )
    return json.loads(result.stdout)

def get_workspaces_with_monitors():
    """Возвращает список {workspace_id, monitor_name, active}"""
    monitors = run_hyprctl("monitors")
    workspaces = run_hyprctl("workspaces")

    # Карта monitor_name → monitor_name (просто для согласованности)
    monitor_names = {mon["name"]: mon["name"] for mon in monitors}
    active_map = {mon["name"]: mon["activeWorkspace"]["id"] for mon in monitors}

    result = []
    for ws in workspaces:
        result.append({
            "workspace_id": ws["id"],
            "monitor_name": monitor_names.get(ws["monitor"], None),
            "active": active_map.get(ws["monitor"], None) == ws["id"]
        })

    # Сортировка по workspace_id
    return sorted(result, key=lambda x: x["workspace_id"])

def print_workspaces():
    print(json.dumps(get_workspaces_with_monitors(), ensure_ascii=False), flush=True)

def main():
    xdg_runtime_dir = os.environ.get('XDG_RUNTIME_DIR')
    hyprland_instance = os.environ.get('HYPRLAND_INSTANCE_SIGNATURE')

    if not xdg_runtime_dir or not hyprland_instance:
        print("Не установлены переменные XDG_RUNTIME_DIR или HYPRLAND_INSTANCE_SIGNATURE")
        return

    socket_path = f"{xdg_runtime_dir}/hypr/{hyprland_instance}/.socket2.sock"

    # Подключаемся к UNIX-сокету
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    sock.connect(socket_path)

    # Отслеживаем последний активный workspace по мониторам
    last_active_map = {}

    # Сразу выводим текущее состояние
    print_workspaces()
    for ws in get_workspaces_with_monitors():
        if ws["active"]:
            last_active_map[ws["monitor_name"]] = ws["workspace_id"]

    buf = b""
    while True:
        data = sock.recv(4096)
        if not data:
            break
        buf += data
        while b"\n" in buf:
            line, buf = buf.split(b"\n", 1)
            line = line.decode("utf-8", errors="ignore")

            # События, которые могут изменить активный workspace
            if line.startswith(("workspace", "createworkspace", "destroyworkspace", "focusedmon")):
                updated = False
                workspaces = get_workspaces_with_monitors()
                for ws in workspaces:
                    if ws["active"]:
                        if last_active_map.get(ws["monitor_name"]) != ws["workspace_id"]:
                            last_active_map[ws["monitor_name"]] = ws["workspace_id"]
                            updated = True
                if updated:
                    print(json.dumps(workspaces, ensure_ascii=False), flush=True)

if __name__ == "__main__":
    main()
