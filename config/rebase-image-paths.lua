-- This script rebases all images paths to be relative to the output file

-- For example, if I have a markdown file "test.md" that links to "image.png",
-- then I convert "test.md" to an HTML "output/test.html", the output file will link to "../image.png"

-- modify package.path to include working directory
package.path = package.path .. ";./?.lua"

local path = require("lua-path.path")

local OUTPUT_DIR = pandoc.path.directory(PANDOC_STATE.output_file)

-- https://pandoc.org/lua-filters.html#type-image
function Image(img)
  -- skip if output is not HTML
  if FORMAT ~= "html" then
    return img
  end

  -- skip if image path is absolute
  if not pandoc.path.is_relative(img.src) then
    return img
  end

  -- skip if image path is contains a protocol like http://, file://
  if img.src:find("://") then
    return img
  end

  local rebased_src = path.relpath(img.src, OUTPUT_DIR)

  img.src = rebased_src

  return img
end
