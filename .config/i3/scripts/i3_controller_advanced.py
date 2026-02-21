#!/usr/bin/env python3
import subprocess
import os
import sys
import json
from pynput import keyboard, mouse
import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, Gdk

class i3ControllerGUI:
    def __init__(self):
        self.window = Gtk.Window()
        self.window.set_title("i3 Controller Mode")
        self.window.set_default_size(300, 200)
        self.window.set_decorated(False)
        self.window.set_keep_above(True)
        self.window.set_position(Gtk.WindowPosition.CENTER)
        
        # Полупрозрачный черный фон
        self.window.modify_bg(Gtk.StateType.NORMAL, Gdk.Color(0, 0, 0))
        self.window.set_opacity(0.9)
        
        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        
        # Заголовок
        label = Gtk.Label()
        label.set_markup("<span size='x-large' foreground='white'>🎮 i3 CONTROLLER MODE</span>")
        vbox.pack_start(label, True, True, 0)
        
        # Инструкции
        instructions = [
            "🖱️  Мышь: Перетаскивание окон",
            "⌨️  Навигация: HJKL / Стрелки",
            "🚀 Перемещение: Shift + HJKL",
            "📺 Полноэкранный: F",
            "❌ Закрыть: Shift+Q",
            "🔧 Изменить размер: R",
            "🚪 Выход: ESC"
        ]
        
        for text in instructions:
            lbl = Gtk.Label()
            lbl.set_markup(f"<span foreground='lightgray'>{text}</span>")
            vbox.pack_start(lbl, True, True, 0)
        
        self.window.add(vbox)
        self.window.show_all()
        
    def run(self):
        Gtk.main()

class Advancedi3Controller:
    def __init__(self):
        self.gui = i3ControllerGUI()
        self.modifiers = set()
        
    def on_key_press(self, key):
        try:
            # Модификаторы
            if key in [keyboard.Key.shift, keyboard.Key.ctrl, keyboard.Key.alt]:
                self.modifiers.add(key)
                return
            
            # Выход
            if key == keyboard.Key.esc:
                Gtk.main_quit()
                return False
            
            # Обработка команд
            self.handle_command(key)
            return False
            
        except Exception as e:
            print(f"Error: {e}")
            return True
    
    def handle_command(self, key):
        """Обработка команд с красивой анимацией"""
        cmd = None
        
        if hasattr(key, 'char'):
            char = key.char.lower() if key.char else None
            
            if keyboard.Key.shift in self.modifiers:
                # Команды с Shift
                if char == 'h': cmd = ('move left', '←')
                elif char == 'j': cmd = ('move down', '↓')
                elif char == 'k': cmd = ('move up', '↑')
                elif char == 'l': cmd = ('move right', '→')
                elif char == 'q': cmd = ('kill', '☠️')
                    
            else:
                # Обычные команды
                if char == 'h': cmd = ('focus left', '👈')
                elif char == 'j': cmd = ('focus down', '👇')
                elif char == 'k': cmd = ('focus up', '👆')
                elif char == 'l': cmd = ('focus right', '👉')
                elif char == 'f': cmd = ('fullscreen toggle', '📺')
                elif char == 'r': cmd = ('mode resize', '📏')
                elif char in '123456789':
                    cmd = (f'workspace {char}', f'🏠 {char}')
                elif char == 'd': 
                    subprocess.Popen(['rofi', '-show', 'run'])
                    return
        
        if cmd:
            # Показываем визуальную обратную связь
            subprocess.Popen(['notify-send', '-t', '500', 
                            f'i3: {cmd[1]}', 'Выполнено'])
            # Выполняем команду
            subprocess.run(['i3-msg', cmd[0]])
    
    def run(self):
        # Запускаем GUI в отдельном потоке
        import threading
        gui_thread = threading.Thread(target=self.gui.run)
        gui_thread.daemon = True
        gui_thread.start()
        
        # Запускаем слушатель клавиатуры
        with keyboard.Listener(
                on_press=self.on_key_press,
                on_release=lambda k: self.modifiers.discard(k) if k in self.modifiers else None,
                suppress=True):
            gui_thread.join()

if __name__ == "__main__":
    controller = Advancedi3Controller()
    controller.run()
