import Parser, { type SyntaxNode } from "tree-sitter";
import Nix from "tree-sitter-nix";
import { type SentinelDocstring, SentinelParser } from "./sentinel-parser.ts";

export class NixParser extends SentinelParser {
  constructor() {
    const parser = new Parser();
    parser.setLanguage(Nix);
    super(parser);
  }

  protected override extractDocString(node: SyntaxNode): string | null {
    const prev = node.previousSibling;
    return prev && prev.type === "comment" ? prev.text : null;
  }

  protected override cleanDocstring(docstring: string): string {
    return docstring
      .replace(/<docsync>.*?<\/docsync>/g, "") // remove <docsync> tags
      .replace(/^\/\*/, "") // remove leading "/*"
      .replace(/\*\/$/, "") // remove trailing "*/"
      .replace(/^#\s?/gm, "") // remove line comment prefix
      .replace(/\s+/g, " ")
      .trim();
  }
}
