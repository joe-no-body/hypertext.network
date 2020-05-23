# via https://stackoverflow.com/a/49396058
function Link(el)
    if el.target:find("/") == 1 or el.target:find(".") == 1 then
        el.target = string.gsub(el.target, "%.md", ".html")
    end
    return el
end
