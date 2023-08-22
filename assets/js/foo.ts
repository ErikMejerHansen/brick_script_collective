import { startScratch } from '../vendor/node_modules/brick-script-collective-scratch'

export const boo = (onWorkspaceChangeCallback, workspaceEventsChannel) => {

    startScratch(onWorkspaceChangeCallback, workspaceEventsChannel)
}