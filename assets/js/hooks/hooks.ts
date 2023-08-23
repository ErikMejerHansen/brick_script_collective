
import { workspace_update_callback, default as channel_socket, channel } from "../workspace_socket.js"
import { connectToScratch } from "../scratch_connection"

const scratchHook = {
    mounted() {
        connectToScratch(workspace_update_callback, channel)
    }
}

const Hooks = {
    ScratchHook: scratchHook
}

export default Hooks;