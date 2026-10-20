StateModule = {
    inputStates = {
        WheelAngle = 0,
        Speed = 0,
        Direction = 1,
        Trans = nil,
        Door = {},
    },
    StateNotifiers = {
        WheelAngle = {},
        Speed = {},
        Door = {},
    }
}

function StateModule:OnInit()
    self.inputStates.Trans = self.inputStates.Trans or Math_CreateMatrix()
end

function StateModule:OnBackup()
    StateBackup = self.inputStates
end

function StateModule:OnRestore()
    if StateBackup then
        for key, value in pairs(StateBackup) do
            if type(value) == "table" then
                for k, v in pairs(value) do
                    self:SetInputState(key, v, k)
                end
            else
                self:SetInputState(key, value)
            end
        end
        StateBackup = nil
    end
end

function StateModule:OnUpdateConfig()
    self:SetInputState("WheelAngle", 0.0)
end

function StateModule:AttachNotifier(stateName, notifier, notifierFunc)
    local notifierNode = {
        user = notifier,
        userFunction = notifierFunc,
    }
    self.StateNotifiers[stateName] = self.StateNotifiers[stateName] or {}
    self.StateNotifiers[stateName][notifier] = notifierFunc
end

function StateModule:DetachNotifier(stateName, notifier)
    self.StateNotifiers[stateName][notifier] = nil
end

function StateModule:SetInputState(stateName, stateValue, stateIndex)
    if stateIndex then
        self.inputStates[stateName] = self.inputStates[stateName] or {}
        self.inputStates[stateName][stateIndex] = stateValue
    else
        self.inputStates[stateName] = stateValue
    end
    if self.StateNotifiers[stateName] then
        for key, value in pairs(self.StateNotifiers[stateName]) do
            value(key, stateValue, stateIndex)
        end
    end
end

function StateModule:GetInputState(stateName, stateIndex)
    if stateIndex and self.inputStates[stateName] and self.inputStates[stateName][stateIndex] then
        return self.inputStates[stateName][stateIndex]
    else
        return self.inputStates[stateName]
    end
end

AllModules["State"] = StateModule

