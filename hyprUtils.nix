rec {

  mkBind = key: action: ''
    bind=${key},${action}
    bind=${key},submap,reset'';
  execBind = key: action: mkBind key "exec,${action}";
}
