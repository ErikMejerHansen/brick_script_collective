import { Socket } from "phoenix"

let socket = new Socket("/robots_state", { params: { token: window.userToken } })

socket.connect()

// Now that you are connected, you can join channels with a topic.
// Let's assume you have a channel with a topic named `workspace` and the
// subtopic is its id - in this case 42:
export let robotsStateChannel = socket.channel("robots_state", {})
robotsStateChannel.join()
  .receive("ok", resp => { console.log("Joined robots_state successfully", resp) })
  .receive("error", resp => { console.log("Unable to join robots_state", resp) })


export default socket
