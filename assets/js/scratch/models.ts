type ExtensionInfo = {
    id: string;
    name: string;
    color1: string;
    color2: string;
    blocks: [{ xml: string }]; //Adding just enough type information
};

type ExtensionDefinition = {
    id: string;
    name: string;
    color1: string;
    color2: string;
    color3: string;
    blockIconURI: string;
    blocks: BlockDefinition[];
    menus?: { text: string; value: unknown }[]; // TODO: Fix this typing
};

type BlockDefinition = {
    arguments: object;
    blockType: BlockTypes;
    opcode: string;
    text: string;
};

/* Enum adapted from https://github.com/LLK/scratch-vm/blob/develop/src/extension-support/block-type.js
 * Be aware not all block types defined in block-type.js can be used from an extension.
 * The enum has been filtered to those that can be used.
 */
enum BlockTypes {
    Boolean = "Boolean",
    Command = "command",
    Hat = "hat",
    Reporter = "reporter",
}

export { ExtensionInfo, ExtensionDefinition, BlockTypes, BlockDefinition };