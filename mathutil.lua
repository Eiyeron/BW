return {
    lerp = function ( a,b,v )
        return a + (b-a)*v
    end,
    clamp = function(v, min, max)
        return math.max(math.min(v, max), min)
    end
}
