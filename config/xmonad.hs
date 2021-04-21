import XMonad
import Data.Map    (fromList)
import Data.Monoid (mappend)

main = xmonad defaultConfig {
  terminal = "alacritty"
}
