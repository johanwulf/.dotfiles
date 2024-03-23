-- Only enable copilot if in work folder
local workPath = os.getenv 'WORK_PATH'
if workPath and vim.fn.getcwd():find(workPath) then
  return { 'github/copilot.vim' }
else
  return {}
end
