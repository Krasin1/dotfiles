#!/usr/bin/env python3

import json
import os
import socket
import subprocess
import sys


def map_layout_name(layout_name):
    """Преобразует полные названия раскладок в короткие коды"""
    mapping = {
        'Russian': 'RU',
        'English (US)': 'EN'
    }
    return mapping.get(layout_name, layout_name)

def get_initial_layout():
    """Получает начальную раскладку через hyprctl"""
    # Выполняем команду hyprctl devices -j
    result = subprocess.run(
        ['hyprctl', 'devices', '-j'],
        capture_output=True,
        text=True,
        check=True
    )
    
    # Парсим JSON вывод
    devices = json.loads(result.stdout)
    
    # Ищем основную клавиатуру с active_keymap
    for keyboard in devices.get('keyboards', []):
        if keyboard.get('main') == True:
            active_keymap = keyboard.get('active_keymap')
            if active_keymap:
                return map_layout_name(active_keymap)
    
    return 'EN'  # Значение по умолчанию

def main():
    # Сначала получаем и выводим текущую раскладку
    initial_layout = get_initial_layout()
    print(initial_layout)
    sys.stdout.flush()
    
    # Затем подключаемся к сокету для получения обновлений
    xdg_runtime_dir = os.environ.get('XDG_RUNTIME_DIR')
    hyprland_instance = os.environ.get('HYPRLAND_INSTANCE_SIGNATURE')
    
    socket_path = f"{xdg_runtime_dir}/hypr/{hyprland_instance}/.socket2.sock"
    
    # Connect to the socket
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
        sock.connect(socket_path)
        
        buffer = ""
        while True:
            # Read data from socket
            data = sock.recv(1024).decode('utf-8')
            if not data:
                break
            
            buffer += data
            lines = buffer.split('\n')
            buffer = lines.pop()  # Keep incomplete line in buffer
            
            for line in lines:
                line = line.strip()
                if line.startswith('activelayout'):
                    parts = line.split(',')
                    if len(parts) >= 2:
                        layout_name = parts[1].strip()
                        short_name = map_layout_name(layout_name)
                        print(short_name)
                        sys.stdout.flush()  # Ensure immediate output

if __name__ == "__main__":
    main()
