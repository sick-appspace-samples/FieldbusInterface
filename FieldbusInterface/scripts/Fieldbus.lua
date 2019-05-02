--[[----------------------------------------------------------------------------
  Application Name:
  FieldbusInterface

  Summary:
  Using the Fieldbus interface

  Description:
  This script is demonstrating the use of the Fieldbus interface for communication with
  a PLC. A Fieldbus handle is created and data received from a PLC is sent back.

  How to run:
  This sample can be tested using a PLC with SICK function blocks for Confirmed
  Messaging have been installed.
------------------------------------------------------------------------------]]
--Start of Global Scope---------------------------------------------------------

-- Creating an instance of the fieldbus interface
local fbHandle = FieldBus.create()

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------
----------------------------------------------------------------------
-- handleOnNewData
-- brief: Handles the event OnNewData from the component FieldBus.
--        The received data will be sent back to the PLC.
-- param[in] data the data received from the field bus
----------------------------------------------------------------------
local function handleOnNewData(data)
  print('>Data received from PLC: ' .. data)
  -- Tranmit the received data back to the PLC
  local result = FieldBus.transmit(fbHandle, data)
  if (result == 0) then
    -- Error handling...
    print('The data could not be transmitted: ' .. data)
  end
end
-- OnNewData will be triggered after data has been received from the fieldbus
-- over the Confirmed Messaging procotol
FieldBus.register(fbHandle, 'OnNewData', handleOnNewData)

----------------------------------------------------------------------
-- handleOnControlBitsOutChanged
-- brief: Handles the event OnControlBitsOutChanged from the component FieldBus.
--        The received data will be sent back to the PLC but whithin the ControlBitsIn.
-- param[in] data the updated value of the control bits
----------------------------------------------------------------------
local function handleOnControlBitsOutChanged(data)
  print('Control Bits Out (from PLC):' .. data)
  -- Tranmit the received data back to the PLC within the ControlBitsIn
  FieldBus.writeControlBitsIn(fbHandle, data, 0xFFFF)
end
-- OnControlBitsOutChanged will be triggered after the control bits on the PLC have been changed
FieldBus.register( fbHandle, 'OnControlBitsOutChanged', handleOnControlBitsOutChanged )

--End of Function and Event Scope------------------------------------------------
