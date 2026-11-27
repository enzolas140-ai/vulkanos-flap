import importlib.util
import tempfile
import unittest
from pathlib import Path

SCRIPT=Path(__file__).resolve().parents[1]/"config/includes.chroot/usr/local/bin/vulkanos-game-runtime"
SPEC=importlib.util.spec_from_file_location("vulkanos_game_runtime",SCRIPT)
runtime=importlib.util.module_from_spec(SPEC); SPEC.loader.exec_module(runtime)

class GameRuntimeTests(unittest.TestCase):
    def test_first_wave_systems(self):
        self.assertEqual(len(runtime.SYSTEMS),6)
        expected={"nes":"demo.nes","snes":"demo.sfc","gb":"demo.gb","gbc":"demo.gbc","gba":"demo.gba","megadrive":"demo.gen"}
        for system,filename in expected.items(): self.assertEqual(runtime.system_from_path(runtime.ROM_ROOT/system/filename),system)
    def test_system_aliases(self):
        self.assertEqual(runtime.normalize_system("Mega Drive"),"megadrive")
        self.assertEqual(runtime.normalize_system("Game Boy Advance"),"gba")
    def test_unknown_extension_is_not_guessed(self):
        self.assertIsNone(runtime.system_from_path(Path("/tmp/game.rom")))
    def test_scan_ignores_non_rom_files(self):
        with tempfile.TemporaryDirectory() as folder:
            root=Path(folder); (root/"nes").mkdir()
            (root/"nes"/"demo.nes").write_bytes(b"rom")
            (root/"nes"/"notes.txt").write_text("not a game")
            items=runtime.scan_roms(root)
            self.assertEqual([item["name"] for item in items],["demo"])

if __name__=="__main__": unittest.main()
