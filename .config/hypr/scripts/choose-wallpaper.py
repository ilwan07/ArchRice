import wx
import subprocess

app = wx.App(False)
frame = wx.Frame(None, wx.ID_ANY, "File Picker")

with wx.FileDialog(frame, "Select wallpaper", wildcard="Image files (*.png;*.jpg;*.jpeg;*.webp)|*.png;*.jpg;*.jpeg;*.webp|All files (*.*)|*.*", style=wx.FD_OPEN, defaultDir="~") as filedialog:
    if filedialog.ShowModal() != wx.ID_CANCEL:
        path = filedialog.GetPath()

        choices = ["cover", "contain", "fill", "tile"]
        dialog = wx.SingleChoiceDialog(frame, "Select wallpaper mode:", "Wallpaper Mode", choices)

        if dialog.ShowModal() == wx.ID_OK:
            mode = dialog.GetStringSelection()
        else:
            mode = "cover"
        subprocess.run(f'hyprctl hyprpaper wallpaper ", {path}, {mode}"', shell=True)

        dialog.Destroy()
