# BrickScriptCollective

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix


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
    - [ ] Add block callback?
    - [ ] Delete block callback?
    - [ ] Move block callback
    - [ ] Strategies:
      - [ ] Load project - Loading a project will cause the workspace change listener to fire. This can cause an infinite loop
      - [ ] Grab workspace changes and share them across nodes.
    - [ ] Full state sync? What happens if someone joins late?
- [ ] Leader selection
- [ ] Robot connections
- [ ] LWP Parser
- [ ] LWP Message Builder
- [ ] Handle PortAttachIO Flow
- [ ] Logo
- [ ] Icons
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
