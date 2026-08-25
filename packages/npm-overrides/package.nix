{ }:

final: prev: {
  "node_modules/tree-sitter-python" = prev."node_modules/tree-sitter-python".overrideAttrs {
    patchPhase = ''
      cp -f ${./tree-sitter-prebuilds/linux-arm64/tree-sitter-python.node} ./prebuilds/linux-arm64/tree-sitter-python.node
    '';
  };
  "node_modules/tree-sitter-typescript" = prev."node_modules/tree-sitter-typescript".overrideAttrs {
    patchPhase = ''
      cp -f ${./tree-sitter-prebuilds/linux-arm64/tree-sitter-typescript.node} ./prebuilds/linux-arm64/tree-sitter-typescript.node
    '';
  };
}
