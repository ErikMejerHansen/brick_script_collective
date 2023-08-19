import { ExtensionInfo } from "./models";

class ToolboxHelper {
    private extensions = new Array<ExtensionInfo>();
    private addControlBlocks: boolean;
    private categorySeparator = '<sep gap="36"/>';
    private blockSeparator = '<sep gap="36"/>'; // At default scale, about 28px

    constructor(addControlBlocks: boolean) {
        this.addControlBlocks = addControlBlocks;
    }

    public addExtension(extension: ExtensionInfo): void {
        this.extensions.push(extension);
    }

    public buildToolbox(): string {
        const categoryTags = this.addControlBlocks
            ? this.categoryTags() + this.controlCategoryTag()
            : this.categoryTags();

        return `<xml id="toolbox-categories" style="display: none">${categoryTags}</xml>`;
    }

    private categoryTags(): string {
        /* If no extensions have been added then add placeholder category
         * If scratch-blocks is initialized is initialized with a toolbox without categories then categories
         * cannot be added later. To get around this problem we add a placeholder category which will be left out
         * when we have extensions added.
         */
        return this.extensions.length === 0
            ? '<category name="Placeholder">'
            : this.extensions.reduce(
                (acc, extension) => acc + this.categoryTag(extension),
                ""
            );
    }

    private categoryTag(extension: ExtensionInfo): string {
        const blocksXml = extension.blocks.reduce(
            (acc, curr) => acc + curr.xml,
            ""
        );
        // iconURI ??
        return `<category name="${extension.name}" 
                      id="${extension.id}" 
                      colour="${extension.color1}" 
                      secondaryColour="${extension.color2}">${blocksXml}
                      ${this.categorySeparator}
            </category>`;
    }

    private controlCategoryTag(): string {
        // Take a look at https://github.com/LLK/scratch-gui/blob/develop/src/lib/make-toolbox-xml.js for more of the built in blocks
        return `
        <category name="%{BKY_CATEGORY_CONTROL}" id="control" colour="#FFAB19" secondaryColour="#CF8B17">
            <block type="control_wait">
                <value name="DURATION">
                    <shadow type="math_positive_number">
                        <field name="NUM">1</field>
                    </shadow>
                </value>
            </block>
            ${this.blockSeparator}
            <block type="control_repeat">
                <value name="TIMES">
                    <shadow type="math_whole_number">
                        <field name="NUM">10</field>
                    </shadow>
                </value>
            </block>
            <block id="forever" type="control_forever"/>
            ${this.blockSeparator}
            <block type="control_if"/>
            <block type="control_if_else"/>
            <block id="wait_until" type="control_wait_until"/>
            <block id="repeat_until" type="control_repeat_until"/>
            ${this.blockSeparator}
            <block type="control_stop"/>
            ${this.categorySeparator}
        </category>
        `;
    }
}
export default ToolboxHelper;