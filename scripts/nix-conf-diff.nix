let
  lib = (import <nixpkgs> { }).lib;
  # attrset representing current host nix settings
  global-nix-config = builtins.mapAttrs (_: value: value.value)
    (builtins.fromJSON (builtins.readFile ../.cache/.global-nix-conf));
  # list of config file lines
  config-lines = lib.lists.remove ""
    (lib.strings.splitString "\n" (builtins.readFile ./nix.conf));
  # list of tuples representing config lines
  config-kv-pairs = (builtins.map (x:
    lib.strings.splitString "=" (builtins.replaceStrings [ " = " ] [ "=" ] x))
    config-lines);
  # attrset with strigified nix config values (i.e. "a b" instead of [ "a", "b" ], "true" instead of true
  disruptor-config-strs = builtins.listToAttrs (builtins.map (x: {
    name = (builtins.elemAt x 0);
    value = (builtins.elemAt x 1);
  }) config-kv-pairs);

  # Convert disruptor config string values into correct types (except for numbers)
  from_str = x:
    (if x == "true" then
      true
    else if x == "false" then
      false
    else if (builtins.length (lib.strings.splitString " " x) == 1) then
      x
    else
      (lib.strings.splitString " " x));

  # Counteract the questionable translation of boolean values
  to_string = x:
    (if x == true then
      "true"
    else if x == false then
      "false"
    else
      builtins.toString x);

  # attrset representing disruptor required config
  disruptor-config =
    builtins.mapAttrs (_: v: (from_str v)) disruptor-config-strs;

  # attrset representing diff in configuration
  different_settings = lib.attrsets.filterAttrsRecursive (k: v:
    (let global-value = builtins.getAttr k global-nix-config;
    in if (builtins.isInt global-value) then
      (builtins.toString global-value) != v
    else
      global-value != v)) disruptor-config;
  output = lib.mapAttrs (k: v:
    "'${to_string v}' change to => '${
      to_string (builtins.getAttr k global-nix-config)
    }';") different_settings;
in output
