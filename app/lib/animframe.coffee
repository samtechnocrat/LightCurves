###
http://notes.jetienne.com/2011/05/18/cancelRequestAnimFrame-for-paul-irish-requestAnimFrame.html

https://gist.github.com/paulirish/1579671
###

do ->
    w = window
    for vendor in ['ms', 'moz', 'webkit', 'o']
        break if w.requestAnimationFrame
        w.requestAnimationFrame = w["#{vendor}RequestAnimationFrame"]
        w.cancelAnimationFrame = (w["#{vendor}CancelAnimationFrame"] or
                                  w["#{vendor}CancelRequestAnimationFrame"])

    # deal with the case where rAF is built in but cAF is not.
    if w.requestAnimationFrame
        return if w.cancelAnimationFrame
        browserRaf = w.requestAnimationFrame
        canceled = {}
        w.requestAnimationFrame = (callback) ->
            id = browserRaf (time) ->
                if id of canceled then delete canceled[id]
                else callback time
        w.cancelAnimationFrame = (id) -> canceled[id] = true

    # handle legacy browsers which don’t implement rAF
    else
        targetTime = 0
        w.requestAnimationFrame = (callback) ->
            targetTime = Math.max targetTime + 16, currentTime = +new Date
            w.setTimeout (-> callback +new Date), targetTime - currentTime

        w.cancelAnimationFrame = (id) -> clearTimeout id
