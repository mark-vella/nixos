# Agent Guidelines for NixOS Configuration

## ⚠️ IMPORTANT: Command Execution

**NEVER run `sudo` commands directly** - they will fail due to password prompts.

**ALWAYS check if running as root first:**
```bash
# Check if running as root
if [ "$EUID" -eq 0 ]; then
  # Safe to run nixos-rebuild commands
  nixos-rebuild switch --flake .#nixos
else
  # Inform user to run command manually
  echo "Please run this command as root:"
  echo "sudo nixos-rebuild switch --flake .#nixos"
fi
```

**For nixos-rebuild operations:**
- Build only: `sudo nixos-rebuild build --flake .#nixos`
- Dry-run: `sudo nixos-rebuild dry-activate --flake .#nixos`
- Switch: `sudo nixos-rebuild switch --flake .#nixos`

**User must run these manually** with their own sudo privileges.

## Build and Validation Commands

### Core NixOS Commands
- `nixos-rebuild switch` - Apply configuration changes and switch to new generation
- `nixos-rebuild test` - Test configuration without persisting to boot menu
- `nixos-rebuild build` - Build configuration only, don't activate
- `nixos-rebuild dry-activate` - Preview changes without applying
- `nixos-rebuild build --keep-failed` - Keep failed build artifacts for debugging

### Flakes Commands (when using flakes)
- `nix flake check` - Validate flake inputs and evaluate correctness
- `nix flake update` - Update all flake inputs to latest versions
- `nix flake update <input>` - Update specific flake input
- `nix flake metadata` - Show flake metadata and input versions
- `nix flake lock --update-input <input>` - Lock specific input to new version
- `nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel` - Build specific configuration

### Formatting and Linting
- `nixpkgs-fmt .` - Format all Nix files (recommended formatter)
- `nixfmt .` - Alternative Nix formatter
- `nix-instantiate --eval configuration.nix` - Validate syntax and type correctness
- `nix flake show` - Show all packages and configurations provided by flake

### Testing
- No unit tests in NixOS config - use `nixos-rebuild test` for integration testing
- Use `nix-shell -p <package>` for quick package testing
- Test flakes with `nix flake check` before applying to system

## Code Style Guidelines

### File Structure
- Use `flake.nix` as entry point for flake-based configurations
- Keep `configuration.nix` as main system configuration
- Never modify `hardware-configuration.nix` - it's auto-generated
- Use subdirectories for modular configs: `modules/`, `packages/`, `services/`

### Formatting
- 2-space indentation (no tabs)
- Max line length: ~80-100 characters for readability
- Attribute sets: opening brace on same line, closing brace on new line
- Lists: opening bracket on same line, closing bracket on new line
- Use consistent spacing around operators and after commas

### Imports and Modules
- Destructure function arguments at top: `{ config, pkgs, lib, ... }:`
- Import modules via `./path/to/module.nix`
- Use `lib` for helper functions: `lib.mkDefault`, `lib.mkIf`, etc.
- In flake.nix, import modules from `./modules` directory

### Package Management
- Use `with pkgs; [ package1 package2 ]` for package lists
- Package versions from unstable channels: `pkgs.unstable.package-name`
- Pin packages in flake inputs when specific versions needed
- Check package availability: `nix search nixpkgs <package>`

### Naming Conventions
- Attribute paths: dot notation (e.g., `services.xserver.enable`)
- Module names: kebab-case for files (e.g., `custom-module.nix`)
- Custom options: descriptive names with dots (e.g., `myModule.customOption`)
- Hostname in flake: match `networking.hostName` from config

### Configuration Patterns
- Use `imports = [ ... ]` for modular configuration
- Group related settings: boot, networking, services, programs
- Use `config.*` for referencing other configuration values
- Use `mkIf` for conditional configuration blocks
- Use `mkDefault` for fallback values that can be overridden

### Error Handling and Validation
- Always run `nix flake check` before `nixos-rebuild switch`
- Use `--show-trace` flag for debugging: `nixos-rebuild switch --show-trace`
- Validate hardware changes with `nixos-generate-config` first
- Check option documentation: `man configuration.nix` or https://search.nixos.org/options

### Flakes Best Practices
- Use unstable channels via flake inputs: `inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"`
- Lock community flakes to specific revisions for reproducibility
- Use `nixpkgs.follows` to deduplicate shared inputs
- Include `description` in flake metadata
- Use `systems` framework for multi-system flakes when applicable

### Comments and Documentation
- Use inline `#` comments for configuration rationale
- Preserve generated file warnings in `hardware-configuration.nix`
- Document non-obvious package inclusions
- Comment flake input URLs with their purpose

### Git Workflow
- Commit after successful `nixos-rebuild switch`
- Test flake changes with `nix flake check` before committing
- Use `.gitignore` to exclude: `result*`, `*.drv`, `*.lock`, `hardware-configuration.nix`
- Tag important configurations for rollback: `git tag stable-config-<date>`

### Channel Management
- Prefer flakes over channels for reproducibility
- When using channels: `nix-channel --update` to refresh
- For bleeding-edge: use `nixos-unstable` or `nixos-unstable-small`
- Check channel status: `nix-channel --list`

### Common Patterns
```nix
# Module with options
{ config, lib, pkgs, ... }:
{
  options.myModule.enable = lib.mkEnableOption "My module";

  config = lib.mkIf config.myModule.enable {
    # configuration here
  };
}

# Conditional package installation
environment.systemPackages = with pkgs; [
  (lib.mkIf condition package)
];

# Custom flake input
{
  inputs.custom-flake.url = "github:user/repo/branch";
  outputs = { self, nixpkgs, custom-flake, ... }: {
    nixosConfigurations.hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix custom-flake.nixosModule ];
    };
  };
}
```

### Security Considerations
- Never commit secrets or passwords to git
- Use `sops-nix` or `agenix` for secrets management
- Regularly update system packages: `nix flake update && nixos-rebuild switch`
- Review `nixpkgs.config.allowUnfree` usage for compliance
- Keep `system.stateVersion` updated on major upgrades
