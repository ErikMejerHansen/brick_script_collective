import { lwpChannel, lwp_message_callback } from "../lwp_socket"
import { workspace_update_callback, channel } from "../workspace_socket.js"
import { connectToScratch } from "../scratch_connection"

const scratchHook = {
    mounted() {
        connectToScratch(workspace_update_callback, channel)
    }
}

const connectToRobot = async (connectedCallback) => {

    const primaryServiceUuid = "00001623-1212-efde-1623-785feabcd123"
    const primaryCharacteristic = "00001624-1212-efde-1623-785feabcd123"
    let device, characteristic;
    device = await navigator.bluetooth.requestDevice({
        filters: [{
            services: [primaryServiceUuid]
        }]
    });



    const server = await device.gatt.connect();
    lwpChannel.push("robot_connected", { robot_id: device.id })

    const service =
        await server.getPrimaryService(primaryServiceUuid);

    characteristic =
        await service.getCharacteristic(primaryCharacteristic);

    characteristic.oncharacteristicvaluechanged = event => {
        lwp_message_callback(event.target.value.buffer)
    }

    characteristic.startNotifications()

    lwpChannel.on("to_robot", (message) => {
        // TODO: Has to wait for promise to resolve before writing the next one
        characteristic.writeValueWithResponse(message)
    })

}

const bluetoothHook = {
    mounted() {
        const robotConnectedCallback = (id) => {
            // this.pushEvent("robot-connected", id)
        }

        window.addEventListener("robot:connect", (_event) => {
            connectToRobot(robotConnectedCallback)
        })
    }
}

const Hooks = {
    ScratchHook: scratchHook,
    BluetoothHook: bluetoothHook,
}

export default Hooks;