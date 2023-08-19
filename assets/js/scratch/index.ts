// Load scratch blocks
import * as ScratchBlocks from "scratch-blocks"; // Will default to Vertical scratch
// Load VM
import * as ScratchVM from "scratch-vm";

import { projectData } from "./project-data";
import ToolboxHelper from "./toolbox-helper";
import { MyExtension } from "./my-extension";

// Clear toolbox: If we don't clear the toolbox the default toolbox will show up.
const toolboxHelper = new ToolboxHelper(true);
ScratchBlocks.Blocks.defaultToolbox = toolboxHelper.buildToolbox();

// Setup workspace
const workspace = ScratchBlocks.inject("blocklyDiv", {
    media: "/static/media/", // WebPack copies the necessary files from node_modules/scratch-blocks/media
    readOnly: false,
    scrollbars: true,
    horizontalLayout: false,
    sounds: false,
    grid: { spacing: 16, length: 2, colour: "#EAEDED", snap: false },
    zoom: {
        controls: true,
        wheel: true,
        startScale: 1,
        maxScale: 4,
        minScale: 0.25,
        scaleSpeed: 1.1,
    },
    colours: {
        fieldShadow: "rgba(255, 255, 255, 0.3)",
        dragShadowOpacity: 0.6,
    },
});

// Hook up VM with blocks
const vm = new ScratchVM(); // Create a new Scratch vm.
// The Scratch-vm needs to know when changes are made to the block canvas.
// We do this by adding the vm to the workspace change listener
workspace.addChangeListener(vm.blockListener);

// Setup Extension listener
// Once we've added out extension we need to tell Scratch-blocks
// that we have some new blocks. So we subscribe to the "EXTENSION_ADDED" event and
// add out new blocks and menus
vm.addListener("EXTENSION_ADDED", (extensionInfo) => {
    console.log(extensionInfo);
    const array = [];
    extensionInfo.blocks.forEach((blockInfo) => {
        array.push(blockInfo.json);
    });
    extensionInfo.menus.forEach((menuInfo) => {
        array.push(menuInfo.json);
    });
    ScratchBlocks.defineBlocksWithJsonArray(array);

    // New blocks have been added, so its time to refresh the toolbox.
    toolboxHelper.addExtension(extensionInfo);
    const toolbox = toolboxHelper.buildToolbox();
    workspace.updateToolbox(toolbox);
});

// Load extension. Using _registerInternalExtension we avoid the sandboxing that
// otherwise happens to extensions.
const extension = new MyExtension();
vm.extensionManager._registerInternalExtension(extension);

// Load project and we're off
vm.loadProject(projectData()).then(() => {
    // Start VM :parryparrot:
    vm.start();
});