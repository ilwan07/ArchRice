import wx
import sys
import subprocess
from pathlib import Path


# check args validity and save them
args = {"file": None, "mode": None}
argi = 1
nextcheck = None
while argi < len(sys.argv):
    arg = sys.argv[argi]
    if nextcheck is None:
        if arg not in ["-h", "--help", "-f", "--file", "-m", "--mode"]:
            sys.exit(f"Error: '{arg}' is not a valid argument")
        if arg in ["-f", "--file"]:
            nextcheck = "file"
        elif arg in ["-m", "--mode"]:
            nextcheck = "mode"
    else:
        if nextcheck == "file":
            if not Path(arg).exists():
                sys.exit(f"Error: invalid file path: {arg}")
            args["file"] = arg
        if nextcheck == "mode":
            if arg not in ["cover", "contain", "fill", "tile"]:
                sys.exit(f"Error: '{arg}' is not a valid mode, pick between cover, contain, fill or tile")
            args["mode"] = arg
        nextcheck = None
    argi += 1
if nextcheck is not None:
    sys.exit(f"Error: please specify a {nextcheck}")

# diplay help if requested
if "-h" in sys.argv or "--help" in sys.argv:
    print("""
Wallpaper selector help

Select a picture and a mode with a UI to set it as a Hyprpaper wallpaper

Args:
-h, --help    Show this help
-f, --file    File path to the picture
-m, --mode    Set the wallpaper mode, choose between cover, contain, fill or tile
""")
    exit()

# make the user select the remaining arguments
if args.get("file") is None or args.get("mode") is None:
    app = wx.App()
    frame = wx.Frame(None, wx.ID_ANY, "Selector")

if args.get("file") is None:
    with wx.FileDialog(frame, "Select wallpaper",
                    wildcard="Image files (.png, .jpg, .jpeg, .webp)|*.png;*.jpg;*.jpeg;*.webp|All files|*.*",
                    style=wx.FD_OPEN, defaultDir="~") as filedialog:
        if filedialog.ShowModal() == wx.ID_CANCEL:
            sys.exit("Cancelled operation")
        args["file"] = filedialog.GetPath()

if args.get("mode") is None:
    choices = ["cover", "contain", "fill", "tile"]
    dialog = wx.SingleChoiceDialog(frame, "Select wallpaper mode:", "Wallpaper Mode", choices)

    if dialog.ShowModal() == wx.ID_CANCEL:
        sys.exit("Cancelled operation")
    args["mode"] = dialog.GetStringSelection()
    dialog.Destroy()

# run command
subprocess.run(f'hyprctl hyprpaper wallpaper ", {args["file"]}, {args["mode"]}"', shell=True)
