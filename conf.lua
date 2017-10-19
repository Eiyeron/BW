if love.filesystem then
    require 'rocks' ()
end

function love.conf(t)
    t.identity = "me.retroactive.bw"
    t.version = "0.10.2"
    t.window.width = 240 * 4 -- The window width (number)
    t.window.height = 128 * 4 -- The window height (number)
    t.dependencies = {
        "30log ~> 1.3",
        "sti == scm-1",
        "flux == scm-1",
        "hsluv ~> 0.1",
        "i18n ~> 0.9",
        "stacktraceplus ~> 0.1"
    }
end
