let
  bobbbay = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOeUJ4JvoGogNOkmJ+dU83xNK28ccUZOrDe4PgQ71GOS";
in
{
  "ssh.age".publicKeys = [ bobbbay ];
}
