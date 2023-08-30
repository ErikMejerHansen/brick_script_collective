import { lwpChannel, lwp_message_callback } from "../lwp_socket"
import { workspace_update_callback, channel } from "../workspace_socket.js"
import { sendVmCommand } from "../vm_commands_socket"
import { connectToScratch } from "../scratch_connection"

import { Queue } from "../queue"

const scratchHook = {
    mounted() {
        connectToScratch(workspace_update_callback, channel, sendVmCommand)
    }
}

const lwpToRobotQueue = new Queue()
const connectToRobot = async () => {

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
    console.log(characteristic)

    lwpChannel.on("to_robot", (message) => {
        console.log(message)
        lwpToRobotQueue.enqueue(() => characteristic.writeValueWithResponse(message))
    })
}

const bluetoothConnectHook = {
    mounted() {
        window.addEventListener("robot:connect", (_event) => {
            connectToRobot()
        })
    }
}

const Hooks = {
    ScratchHook: scratchHook,
    BluetoothHook: bluetoothConnectHook,
}

export default Hooks;