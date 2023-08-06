let
  bobbbay = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOeUJ4JvoGogNOkmJ+dU83xNK28ccUZOrDe4PgQ71GOS";

  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJ3cWdmn7DBaDiGZeswWXApAzk1jQe03j7LSZKqm7iU";
in {
  "fonts/pragmata-pro-mono-liga.age".publicKeys = [bobbbay];
}
