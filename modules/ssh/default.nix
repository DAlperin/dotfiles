{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.dov.ssh;
in
{
  options = {
    dov.ssh.authorizedKeys = mkOption {
      default = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDGoD7tPF9BhPFS2vY0IgLnQwJk4u/G/sVW85Oxzi2ftBz7Bwd1RM3JtzToET+GAlI3aREpo+63mqE+4fWWZ7DnH8IWnbhM4dC3SCUZp3uaAL6hE/MDDp8xrMj9rh3QrbNCCpgO0TdZLzwpRIGexsrVsWtrYkzLs/a757LbFnDjtal0cRUNhYAYouF2qFkhqcJWga0KYuv01ZCQYptv+SKiL9E9avEwep865e3z65MxiwaiZpIAU5Nq64qq8+uecxOsDGHupbuhknAAWGg+sy//T4kDv2qxjx5FEVUzCLb0ru9zamL3Lww8YjqEjNLqIUOzblzYDpJqysnuqElXGWBqBsNXPrgz984h8nFFYhxT4B4TjQ8wqrkWuMtVczR09SM1MYn6G4UVz5EX0G33otAupzgUPTmPAZ9GdbVKt87Sa/3xpwpY7ZNRXRstMVDkiLlecXRzr59GEf6h8bfAv7XLhN6XZ7Qg89zDw28F+QboqTAVVb+7ko9OGO7DJvzdVxE= dovalperin@DovDev" ];
    };
    dov.ssh.enable = mkEnableOption "ssh";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };

}
