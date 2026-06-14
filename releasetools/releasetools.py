import common

def FullOTA_PostValidate(info):
    info.script.AppendExtra('ui_print("  ");')
    info.script.AppendExtra('ui_print("==========================================");')
    info.script.AppendExtra('ui_print("  keepQASSA for Santoni (Unofficial)");')
    info.script.AppendExtra('ui_print("  Maintainer: ziachi");')
    info.script.AppendExtra('ui_print("  GitHub: github.com/ziachi");')
    info.script.AppendExtra('ui_print("  Telegram: t.me/kalomakan");')
    info.script.AppendExtra('ui_print("==========================================");')
    info.script.AppendExtra('ui_print("  ");')

def FullOTA_Assertions(info):
    info.script.AppendExtra('ui_print("  ");')
    info.script.AppendExtra('ui_print("==========================================");')
    info.script.AppendExtra('ui_print("  keepQASSA for Xiaomi Redmi 4X (santoni)");')
    info.script.AppendExtra('ui_print("  Build by ziachi - UNOFFICIAL");')
    info.script.AppendExtra('ui_print("==========================================");')
    info.script.AppendExtra('ui_print("  ");')
