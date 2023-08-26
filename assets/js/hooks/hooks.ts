import { lwp_message_callback } from "../lwp_socket"
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

    console.log("Connecting", device)
    const server = await device.gatt.connect();
    connectedCallback(device.id)
    console.log("Server", server)
    const service =
        await server.getPrimaryService(primaryServiceUuid);

    console.log("Service", service)
    characteristic =
        await service.getCharacteristic(primaryCharacteristic);

    console.log("characteristic", characteristic)
    characteristic.oncharacteristicvaluechanged = event => {
        const array = new Uint8Array(event.target.value.buffer)
        lwp_message_callback(array)
    }

    console.log("starting notifications")
    characteristic.startNotifications()
    console.log(characteristic)

}
const bluetoothHook = {
    mounted() {
        const robotConnectedCallback = (id) => {
            this.pushEvent("robot-connected", id)
        }
        window.addEventListener("robot:connect", (event) => {
            console.log("connect!", event)
            connectToRobot(robotConnectedCallback).then(() => { console.log("Connected?") })
        })
    }
}

const Hooks = {
    ScratchHook: scratchHook,
    BluetoothHook: bluetoothHook,
}

export default Hooks;