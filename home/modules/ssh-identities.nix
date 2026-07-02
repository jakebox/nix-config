# Shared SSH host definitions.
# Each host uses the machine's mainSSHKey unless overridden.

{ mainSSHKey, ... }:

let
  key = "%d/.ssh/${mainSSHKey}";
in
{
  programs.ssh.matchBlocks = {
    "github github.com" = {
      hostname = "github.com";
      user = "git";
      identityFile = key;
    };
    "ixion" = {
      hostname = "5.161.250.109";
      user = "ixion";
      identityFile = key;
    };
  };
}
