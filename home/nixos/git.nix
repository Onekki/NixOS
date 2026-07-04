{ identity, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = identity.gitName;
        email = identity.gitEmail;
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      rebase.autoStash = true;
      rerere.enabled = true;
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;

    settings = {
      git_protocol = "https";
      prompt = "enabled";
    };
  };
}
