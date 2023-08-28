defmodule BrickScriptCollective.Lwp.Robot do
  alias BrickScriptCollective.Lwp.Robot.Port

  defstruct id: "",
            port_1: %Port{},
            port_2: %Port{},
            port_3: %Port{},
            port_4: %Port{},
            port_5: %Port{},
            port_6: %Port{}
end
