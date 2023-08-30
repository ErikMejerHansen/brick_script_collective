import { startScratch } from '../vendor/node_modules/brick-script-collective-scratch'

export const connectToScratch = (onWorkspaceChangeCallback, workspaceEventsChannel, sendVmCommand) => {
    startScratch(onWorkspaceChangeCallback, workspaceEventsChannel, sendVmCommand)
}