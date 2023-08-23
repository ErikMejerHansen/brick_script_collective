// import { startScratch } from '../vendor/main.js'
// import { startScratch } from '../vendor/node_modules/brick-script-collective-scratch'
import { startScratch } from '../vendor/node_modules/brick-script-collective-scratch'

export const connectToScratch = (onWorkspaceChangeCallback, workspaceEventsChannel) => {
    startScratch(onWorkspaceChangeCallback, workspaceEventsChannel)
}