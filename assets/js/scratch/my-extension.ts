import { ExtensionDefinition, BlockTypes } from "./models";
/*
 * Simple example extension.
 * You can find more information here: https://github.com/LLK/scratch-vm/blob/develop/docs/extensions.md
 */
class MyExtension {
    public getInfo(): ExtensionDefinition {
        return {
            id: "MyExtension",
            name: "My Sample Extension",
            color1: "#CE59FF",
            color2: "#8B46E8",
            color3: "#684DFF",
            menus: null,
            blockIconURI: null,
            blocks: [
                {
                    blockType: BlockTypes.Hat,
                    arguments: {},
                    opcode: "always",
                    text: "Will always run",
                },
                {
                    blockType: BlockTypes.Command,
                    arguments: {},
                    opcode: "print",
                    text: "Console printer",
                },
            ],
        };
    }
    public always(_args, _blockUtils): boolean {
        return true;
    }

    public print(args, blockUtils): void {
        console.log("Print block activated");
        console.log("Args:", args);
        console.log("blockUtils:", blockUtils);
    }
}

export { MyExtension };