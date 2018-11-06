# BW (Love2D)
## Postmortem code upload

I decided to publish the sources of this project abandoned for a while now. It
might give some ideas to anyone who wants to tinker it. It should run on
[Love2D][love2d] 0.10, probably not higher due to API changes.

I don't even remember why I started this project. I had a Pico-8 version that
was well developped. In the end it helped me as a sandbox project for small
subprojects like the palette feature or th event sequence system, feel free to
browse in `sequence/` or `palette.lua`. I'd also suggest looking at the textbox
system, it was the cleanest and best developped iteration I had of such textbox
until I did my [Haxeflixel version][textbox].

There are a few garbage files here and there. I'll clean the repo later before
archiving it, along with adding a LICENCE file.

## Controls

- Arrow keys : move the character or their head
- space : advance the textbox
- F1 : screenshot
- F2 : reload shaders
- F3 : export the palette
- F4 : transition to another palette
- F5 : add debug text to the textbox to test the message queuing
- F6 : reset the sequence
- F12 : force a crash to test the custom error handler

## A few notes on the subsystems

There are a few features here and there that might be interest to pick from, be
it subsystems or features that could be used out of the project.

### Error handler

Using [stacktraceplus][stacktraceplus], I built a custom version of Love2D's
error screen to have a bit more information on the context of the error,
including local variables. The error handler is located in `errhandler**,
requiring it should automatically override the function.

**Beware**: it's based on 0.10's own error handler and might not fit for 11.x or
higher.

### Game states

I guess I did my own game state system. It uses an input handler for controlling
entities and dispatches love callbacks to the current state. Nothing really
fancy, I wanted to have an environment close to Haxeflixel. States are based on
layers that just are groups of drawables.

### Input handling

If my memory serves me right, I wanted to make something to decouple handling
input, actions and the target in a similar way than Rewired. I don't remember
how it works all but there are controllers that'd offer a list of bindables
actions over a designated entity and the handler would update the current used
controllers. The handler accepts a function and a callee to allow controllers to
be updated. It's quite blurry, so I can't remind the details.

### Room

A quick note on rooms: they're loaded level parts that'd link to other rooms
depending on certain conditions (such as moving past a screen side). They also
act as the object loaders and each of them own a few layers to store them and
display them on the proper position and depth.

### Sequencing

A sequence is a chain of nodes. Nodes can be Actions or Conditions (or
"gates/barriers/etc.."). Actions are coroutine that are called until they're
done where conditions are just making the sequence stop until a specific
condition or sub sequences are done. It would allow updating multiple entities
at the same time. It could be a good start to make cinematics or simultaneous
orchestrated entity manipulation. In the `gamestate.lua file, I made an example
where the player would move by itself while the textbox would be updatable.

Alas, such system is pretty complex as you can see. To make "simple" actions I
had to make the `sequence/simple.lua` file for actions that were actually a bt
more complicated (specially the input handling that'd cause conflicts). I still
might have a few notes about them elsewhere.

### Shader reloading

To make a quick live-reload setting to test the palette transition or the wave
effect, I wrote a small class helper to allow me to reload on a keypress.
Nothing fancy that'd require platform-specific libraries to listen on file
events, alas.

### Textbox

Sorry, but it's been too long I haven't delved in its code. If my memory doesn't
fail me, it's just a simple character-per-character without effects textbox. The
really simple model. I didn't need something more complex than this when I
ported most of the Pico-8 version to this. Special mention to past me for the
coroutine bit.

### Palette export

Ah, `utils/palette_export.lua`. I did a small program out of it to quickly
generate palettes. Nothing really fancy, it just helped me getting a small
auto-updating palette monitor while the color transitions would happen (and
eventually save them too).

[love2d]: https://love2d.org/
[textbox]: https://github.com/Eiyeron/Textbox
[stacktraceplus]: https://github.com/ignacio/StackTracePlus
