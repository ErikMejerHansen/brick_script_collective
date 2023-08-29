defmodule BrickScriptCollective.Lwp.Robot do
  alias BrickScriptCollective.Lwp.Robot.Port

  defstruct id: "",
            ports: [
              %Port{id: 0},
              %Port{id: 1},
              %Port{id: 2},
              %Port{id: 3},
              %Port{id: 4},
              %Port{id: 5}
            ]
end
