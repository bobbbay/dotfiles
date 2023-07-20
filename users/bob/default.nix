{hmUsers, ...}: {
  home-manager.users = {inherit (hmUsers) bob;};

  users.users.bob = {
    password = "bob";
    description = "Bobbbay's personal account.";
    isNormalUser = true;
    extraGroups = ["wheel" "audio"];
  };
}
