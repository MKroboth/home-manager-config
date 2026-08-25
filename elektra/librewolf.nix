{ ... }:
{
  # Manage LibreWolf via home-manager so we can set enterprise policies.
  # ImportEnterpriseRoots makes it trust the OS trust store (which carries the
  # Kroboth Home Root CA, added in the NixOS config), so home.arpa TLS is valid.
  programs.librewolf = {
    enable = true;
    policies = {
      Certificates.ImportEnterpriseRoots = true;
      # Kerberos SPNEGO: auto-authenticate (Negotiate) to internal *.home.arpa
      # hosts using the workstation TGT — Authentik SSO (authentik.home.arpa) and
      # any Kerberos-protected service. Delegation lets the SSO'd session forward
      # the ticket onward. Locked so hardening can't silently disable it.
      Preferences = {
        "network.negotiate-auth.trusted-uris" = {
          Value = ".home.arpa";
          Status = "locked";
        };
        "network.negotiate-auth.delegation-uris" = {
          Value = ".home.arpa";
          Status = "locked";
        };
      };
    };
  };
}
