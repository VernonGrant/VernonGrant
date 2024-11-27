local overseer = require("overseer")

overseer.register_template({
    name = "Get Content",
    builder = function()
        return {
            cmd = "rm -R ./content/*.md && cp -R ~/Notes/Blog/ ./content/",
        }
    end,
})

overseer.register_template({
    name = "Serve",
    builder = function()
        return {
            cmd = "tmux-exec-nw 'Prepare Release' 'gozer serve' 2",
        }
    end,
})

overseer.register_template({
    name = "Build",
    builder = function()
        return {
            cmd = "gozer build && rm -R ./docs && cp -R ./build ./docs",
        }
    end,
})
