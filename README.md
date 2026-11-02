# Panther37 Tap

## How do I install these formulae and casks?

### Installing FreshenMac (Cask)

```bash
brew install --cask panther37/tap/freshenmac
```

Or tap first:
```bash
brew tap panther37/tap
brew install --cask freshenmac
```

> [!NOTE]
> **Tap Trust:** Modern Homebrew (6.0+) prompts to trust third-party taps (`Do you want to trust formulae, casks, and commands from this tap? [y/N]`). Press `y` when prompted, or run `brew trust panther37/tap` (or `brew trust --cask panther37/tap/freshenmac`).

Or in a `brew bundle` `Brewfile`:
```ruby
tap "panther37/tap"
cask "freshenmac"
```

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
