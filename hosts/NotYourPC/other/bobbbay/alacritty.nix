{
  font = {
    normal = {
      family = "Iosevka";
      style = "Regular";
    };
    bold = {
      family = "Iosevka";
      style = "Bold";
    };
    italic = {
      family = "Iosevka";
      style = "Italic";
    };
    size = 10;
  };

  padding = {
    x = 2;
    y = 2;
  };

  scrolling = {
    history = 100000;
    multiplier = 1;
  };

# Here, we declare us some colors. This is my slightly modified Base 16
# Gruvbox Dark theme. It looks sexy, period. Under that is a WIP light
# theme, based on Base 16 yet again.

# Colors (Base16 Default Dark)
#colors:
#  # Default colors
#  primary:
#    background: '#181818'
#    foreground: '#d8d8d8'

#  # Colors the cursor will use if `custom_cursor_colors` is true
#  cursor:
#    text: '#d8d8d8'
#    cursor: '#d8d8d8'

#  # Normal colors
#  normal:
#    black:   '#181818'
#    red:     '#ab4642'
#    green:   '#a1b56c'
#    yellow:  '#f7ca88'
#    blue:    '#7cafc2'
#    magenta: '#ba8baf'
#    cyan:    '#86c1b9'
#    white:   '#d8d8d8'

#  # Bright colors
#  bright:
#    black:   '#585858'
#    red:     '#ab4642'
#    green:   '#a1b56c'
#    yellow:  '#f7ca88'
#    blue:    '#7cafc2'
#    magenta: '#ba8baf'
#    cyan:    '#86c1b9'
#    white:   '#f8f8f8'

##colors:
##  primary:
##    background: '#fbf1c7'
##    foreground: '#181818'

#  normal:
#    black: "#fbf1c7"
#    red: "#af3a03"
#    orange: "#b57614"
#    yellow: "#79740e"
#    green: "#427b58"
#    cyan: "#076678"
#    magenta: "#8f3f71"
#    blue: "#076678"
#    white: "#ffffff"

# Here we can declare keybindings. I generally don't need these - but
# just for the idea, I've added a Ctrl+N binding. I personally admire how
# well these are managed by alacritty.
#key_bindings:
# - { key: N,             mods: Control,         action: SpawnNewInstance     }

# Here, we declare the cursor style - in this case, The Beam. It looks
# clean and gets the job done well. The cursor, by default, will become
# a hollow square when the window is unfocused.
  cursor.style = "Beam";

# Debugging isn't really something you'd see in most setups -
# but I thought I'd give it a try. This small, and final, section
# declares persistent logging. This way, alacritty won't delete its
# log files when quitting.
  debug.persistent_logging = true;
}
