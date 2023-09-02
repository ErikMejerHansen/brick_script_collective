// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

import Hooks from "./hooks/hooks"
import { robotsStateChannel } from "./robot_state_socket"



let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, { params: { _csrf_token: csrfToken }, hooks: Hooks })

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

window.liveSocket = liveSocket


window.robots = new Map()
const getAttachedMotors = () => {
    const connectedPorts = Array.from(window.robots.values()).flatMap(it => it.ports)
    console.log(connectedPorts)
    const attachedMotors = connectedPorts.map(it => it.attachment).filter(it => it.type === 'small_motor')

    return attachedMotors
}

robotsStateChannel.on("robots_state_update", (message) => {
    const robotId = Object.keys(message.payload).filter(it => it !== 'event')[0]
    const robot = message.payload[robotId]
    window.robots.set(robotId, robot)

    running_motors = getAttachedMotors().filter(motor => motor.running)
    console.log("Running motors", running_motors)
    console.log("Motor promise resolver", window.motorPromiseResolver)

    if (running_motors.length === 0 && window.motorPromiseResolver !== undefined && window.motorPromiseResolver !== null) {
        console.log("Resolving motors")
        window.motorPromiseResolver()
    } else {
        console.log("Not resolving")
    }
})