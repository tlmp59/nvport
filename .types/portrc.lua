---@meta

---@class PortrcConfig
---@field sources? Source

---@class Source
---@field trs? string[]
---@field fmt? table<table, string[]>
---@field cmp? NvCmpConfig
---@field dap? NvDapConfig
---@field lnt? table<table, string[]>

---@class NvCmpConfig
---@field dependencies? table
---@field providers? table
---@field per_filetype? table

---@class NvDapConfig
