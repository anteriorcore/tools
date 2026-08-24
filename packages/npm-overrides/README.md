# NPM overrides

## Treesitter

Cursed patch for the prebuilt arm64 binaries from NPM.  The versions of the NPM packages we use for tree-sitter-typescript and tree-sitter-python have a prebuilt arm64 library that isn’t arm64 but just x64.  It’s now (Aug 2026) fixed in [tree-sitter/workflows](https://github.com/tree-sitter/workflows/commit/a7e9bc7e70aae68e8f770d984cf6a6284fb17a69), and a new tree-sitter-python package has been released with this fix, but not tree-sitter-typescript yet.

I manually rebuilt the arm64 libraries using a Docker container (from `node:22` to ensure a node.js installation configured with static linking) by following the steps of the tree-sitter publish github action.  Binaries committed to git here, and directly pasted over any tree-sitter dependency package.

Cursed in many ways.  The easiest fix is to just wait for tree-sitter-typescript to publish a new version and update the package.json to point to that new version.
