local overseer = require("overseer")

overseer.register_template({
    name = "Get Content",
    builder = function()
        return {
            cmd = "tmux-exec-nw 'Get Content' 'rm -R ./content/*.md && cp -R ~/Notes/Blog/ ./content/' 2",
        }
    end,
})

overseer.register_template({
    name = "Serve",
    builder = function()
        return {
            cmd = "tmux-exec-nw 'Prepare Release' 'gozer serve' 1",
        }
    end,
})

overseer.register_template({
    name = "Build",
    builder = function()
        return {
            cmd = "tmux-exec-nw 'Build' 'gozer build && rm -R ./docs && cp -R ./build ./docs' 2",
        }
    end,
})
