-- Link handler
-- Recognizes [Text](__URL__) and outputs a proper inline link for HTML and PDF
local meta = {}

-- local function table_length(t)
--     local count = 0
--     for _ in pairs(t) do
--       count = count + 1
--     end
--     return count
--   end

-- Extract the metadata from the document
function Meta(m)
  for k, v in pairs(m) do
    local t = pandoc.utils.type(v)
    if type(v) == "table" and t == "Inlines" then
      -- print("Key:", k, "Value:", pandoc.utils.stringify(v))
      meta[k] = pandoc.utils.stringify(v)
    end
  end
  -- print("Meta Table Length:", table_length(meta))
end

-- Replace the __var name__ with its value
function Link(el)
  local url = el.target
  local key = url:match("^__([%w_]+)__$") -- not "^%%([%w_]+)%%$" to avoid latex escaping

  if FORMAT == "latex" then
    print('Latex - meta URL:', meta[key])
  end

  if FORMAT == "html" then
    print('HTML - meta URL:', meta[key])
  end

  if key and meta[key] then
    el.target = meta[key]
    print("Resolved URL:", el.target)
    return el
  end
  return nil
end

-- Return two filter tables: Meta first, then Link
return {
    { Meta = Meta },
    { Link = Link }
  }