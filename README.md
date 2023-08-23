# BrickScriptCollective

I like BlockRobotsCollective as a new name!

## Release flow
This is dumb....

copy `main.js` from `assets/vendor/node_modules/brick_script_collective/dist/main.js` to `assets/vendor/`
update the import in `assets/js/foo.ts` to point to `main.js` (Just switch the commented lines)

run `flyctl deploy`

## Pallete

https://coolors.co/abe188-f7ef99-f1bb87-f78e69-5d675b

## ToDos
[] Setup ScratchVM and ScratchBlocks
  - [x] Dependencies added
  - [x] VM running
  - [ ] Blocks
    - [ ] any - triggers when true for any robot/sensor
    - [ ] all - triggers when true for all robots/sensors
    - [ ] most - triggers when true for most robots/sensors
[x] Typescript integration 
  - Should just work? Throw stuff into /assets/js/
  - It _does_ just work!
- [ ] State sync-ing
  - [ ] Canvas state
    - [ ] Strategies:
      - [ ] Load project - Loading a project will cause the workspace change listener to fire. This can cause an infinite loop
      - [ ] Grab workspace changes and share them across nodes.
      - [ ] Just sending the raw events from blockly does not seem viable as they are JS classes and don't serialize well.
      - [ ] Towards CRDT (y.js)
        - [ ] Listen to workspace events and broadcast them
          - [ ] The create event will need extra serialization because the .xml field contains a DOM element
          - [ ] scratch-vm expects to be able to parse a HTML/XML string, modify it so that it can _also_ work with a serialized XML string (Do I need to keep the old functionality alive?)
            - [ ] Might be an option to use htmlparser2 to serialize the event xml?
          - [ ] This should now be functional but won't be conflict free and have no way of sharing full state
          - [ ] CRDT:
            - [ ] Each browser creates a yjs Doc. 
              - [ ] The block structure is a list of lists. 
                - [ ] Blocks are, type, coordinate, inputs
              - [ ] workspace event is turned into yjs Doc change
              - [ ] doc changes are broadcast
              - [ ] Need to be able to convert list of changes to workspace events
              - [ ] Need to be able to take full yjs doc state into VM (or perhaps just replay allllll the changes). Needed for new joiners. 
    - [ ] Full state sync? What happens if someone joins late?
- [ ] Leader selection
- [ ] Robot connections
- [ ] LWP Parser
- [ ] LWP Message Builder
- [ ] Handle PortAttachIO Flow
- [ ] Logo
- [ ] Icons
- [ ] Deploy on fly.io
  - [ ] brick_script_collective should install deps from github
- [ ] Attach Robot/(Creature?)
- [ ] Show users online (Phoenix Presence)
  - [ ] And if they have connected a robot
    - [ ] Show robot capabilities: Eye for color, ruler for distance sensor, gear for motor


# Design notes

- Scratch VM runs in one browser window (the selected leader)
- Sensor state is synced from between all browsers
- Added blocks that could only work with full shared state
- VM sends {robot_command:[:turn_motor, 90]} to backend (basically [ OP_Code:, params: [] ] format)
  - This is then sent out to all browsers that send it to connected robot
- Can Phoenix Presence be used for that?
  - Use a channel
