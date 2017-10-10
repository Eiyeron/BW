local TextBoxState = {
    -- Should be invisible
    DISABLED = "disabled",
    -- Should be appearing, probably empty
    APPEARING = "appearing",
    -- Drawign text and stuff
    ACTIVE = "active",
    -- Should progressively disappear
    DISAPPEARING = "disappearing"
}

local TextBoxSubState = {
    PRINTING = "printing",
    FULL = "full",
    END_OF_LINE = "end_of_line",
    DONE = "done"
}

return {TextBoxState, TextBoxSubState}
