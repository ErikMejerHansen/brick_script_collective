

import { Socket } from "phoenix"

// Connect to the socket
let socket = new Socket("/workspace_sync", { params: { token: window.userToken } })
socket.connect()

// Select your channel...
export let channel = socket.channel("workspace:42", {})

//... and join it
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket


export const workspace_update_callback = (update) => {
  channel.push("workspace_update", update)
}


