import type { ExtensionAPI } from "@mariozechner/pi-coding-agent"
import mermaidToolsExtension from "./tools/mermaid_tools.ts"
import svgToolsExtension from "./tools/svg_tools.ts"

export default function visualToolsExtension(pi: ExtensionAPI) {
  mermaidToolsExtension(pi)
  svgToolsExtension(pi)
}
