using Documenter
using DemoCards

theme = cardtheme()
simple_page = makedemos("demos/simplest_demopage")
complicate_page = makedemos("demos/complicate_page")

format = Documenter.HTML(edit_branch = "master",
                         assets=[theme])

makedocs(format = format,
         pages = [
            "Home" => "index.md",
            "SimplePage" => simple_page,
            "ComplicatePage" => complicate_page,
         ],
         sitename = "Demos")
