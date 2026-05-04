local M = {}

-- 这个文件只负责把 flash.nvim 包装成你想要的 f 跳转：
-- 1. 按 f 后进入 Flash 的灰色选择状态。
-- 2. 输入一个目标字符，比如 a。
-- 3. 当前 tab 所有可见窗口里相同的 a 都会显示标签。
-- 4. 输入标签后跳转到对应位置。
--
-- 这里不再自己扫描窗口和绘制灰色背景，因为 flash.nvim 已经把多窗口、
-- 可见范围、浮动窗口排除、backdrop 高亮等细节处理得更稳定。

local function format_label(opts)
  local label = opts.match.label1 or opts.match.label or ""
  local second = opts.match.label2 or ""

  if second == "" then
    return { { label, "FlashLabel" } }
  end

  -- 两字符标签时两个字符都显示出来；第一个字符用于缩小范围，第二个字符完成跳转。
  return {
    { label, "FlashMatch" },
    { second, "FlashLabel" },
  }
end

local function apply_default_jump(match, state)
  local jump = require("flash.jump")
  state:hide()
  jump.jump(match, state)
  jump.on_jump(state)
end

local function label_targets(matches, state)
  local labels = state:labels()
  if #labels == 0 then
    return
  end

  -- 候选点不多时直接使用单字符标签；候选点很多时升级成两字符标签。
  for index, match in ipairs(matches) do
    if #matches <= #labels then
      match.label1 = labels[index]
      match.label2 = ""
      match.label = match.label1
    else
      local first = math.floor((index - 1) / #labels) + 1
      local second = ((index - 1) % #labels) + 1
      if labels[first] and labels[second] then
        match.label1 = labels[first]
        match.label2 = labels[second]
        match.label = match.label1
      end
    end
  end
end

local function pick_second_label(first_match, first_state)
  local Flash = require("flash")

  first_state:hide()
  Flash.jump({
    search = {
      max_length = 0,
      multi_window = true,
    },
    highlight = {
      matches = false,
      backdrop = true,
    },
    label = {
      after = false,
      before = { 0, 0 },
      uppercase = false,
      format = format_label,
    },
    matcher = function(win)
      return vim.tbl_filter(function(match)
        return match.win == win and match.label1 == first_match.label1
      end, first_state.results)
    end,
    labeler = function(matches)
      for _, match in ipairs(matches) do
        match.label = match.label2
      end
    end,
  })
end

function M.visible()
  local Flash = require("flash")

  Flash.jump({
    pattern = "",
    search = {
      -- multi_window 只会使用当前 tab 的窗口；flash.nvim 内部会处理可见范围。
      multi_window = true,
      mode = "exact",
      max_length = 1,
      forward = true,
      wrap = true,
    },
    jump = {
      autojump = false,
    },
    label = {
      after = false,
      before = { 0, 0 },
      current = true,
      distance = false,
      uppercase = false,
      min_pattern_length = 1,
      format = format_label,
    },
    highlight = {
      backdrop = true,
      matches = true,
    },
    labeler = label_targets,
    action = function(match, state)
      if not match.label2 or match.label2 == "" then
        apply_default_jump(match, state)
        return
      end
      pick_second_label(match, state)
    end,
  })
end

return M
