return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "2017.08.29",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 30,
  height = 8,
  tilewidth = 8,
  tileheight = 8,
  nextobjectid = 22,
  properties = {
    ["left"] = "test",
    ["right"] = "test"
  },
  tilesets = {
    {
      name = "sheet",
      firstgid = 1,
      filename = "../imgs/sheet.tsx",
      tilewidth = 8,
      tileheight = 8,
      spacing = 0,
      margin = 0,
      image = "../imgs/sheet.png",
      imagewidth = 128,
      imageheight = 128,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 8,
        height = 8
      },
      properties = {},
      terrains = {},
      tilecount = 256,
      tiles = {
        {
          id = 14,
          probability = 0.1
        },
        {
          id = 15,
          probability = 0.1
        },
        {
          id = 29,
          probability = 0.1
        },
        {
          id = 30,
          probability = 0.1
        },
        {
          id = 31,
          probability = 0.1
        }
      }
    },
    {
      name = "door",
      firstgid = 257,
      filename = "../imgs/door.tsx",
      tilewidth = 17,
      tileheight = 24,
      spacing = 0,
      margin = 0,
      image = "../imgs/door.png",
      imagewidth = 34,
      imageheight = 24,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 17,
        height = 24
      },
      properties = {},
      terrains = {},
      tilecount = 2,
      tiles = {}
    },
    {
      name = "lamp",
      firstgid = 259,
      filename = "../imgs/lamp.tsx",
      tilewidth = 8,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      image = "../imgs/lamp.png",
      imagewidth = 8,
      imageheight = 16,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 8,
        height = 16
      },
      properties = {},
      terrains = {},
      tilecount = 1,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "bg",
      x = 0,
      y = 0,
      width = 30,
      height = 8,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 13, 0, 0, 0, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 0, 0, 0, 13, 0, 0, 0, 0,
        0, 0, 0, 0, 13, 0, 0, 0, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 0, 0, 0, 13, 0, 0, 0, 0,
        0, 0, 0, 0, 13, 0, 0, 0, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 0, 0, 0, 13, 0, 0, 0, 0,
        0, 0, 0, 0, 13, 0, 0, 0, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 0, 0, 0, 13, 0, 0, 0, 0,
        0, 0, 0, 0, 13, 0, 0, 0, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 0, 0, 0, 13, 0, 0, 0, 0,
        0, 0, 0, 0, 13, 11, 11, 12, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 11, 11, 12, 13, 0, 0, 0, 0,
        0, 0, 0, 0, 13, 12, 11, 12, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 12, 11, 12, 13, 0, 0, 0, 0,
        0, 0, 0, 0, 13, 0, 0, 0, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 0, 0, 0, 13, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      name = "objects",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 8,
          name = "door",
          type = "door",
          shape = "rectangle",
          x = 112,
          y = 64,
          width = 17,
          height = 24,
          rotation = 0,
          gid = 257,
          visible = true,
          properties = {
            ["opened"] = false
          }
        },
        {
          id = 12,
          name = "lamp",
          type = "torch",
          shape = "rectangle",
          x = 32,
          y = 40,
          width = 8,
          height = 16,
          rotation = 0,
          gid = 259,
          visible = true,
          properties = {
            ["backlight"] = true,
            ["lit"] = true
          }
        },
        {
          id = 16,
          name = "lamp",
          type = "torch",
          shape = "rectangle",
          x = 64,
          y = 40,
          width = 8,
          height = 16,
          rotation = 0,
          gid = 259,
          visible = true,
          properties = {
            ["backlight"] = true,
            ["lit"] = true
          }
        },
        {
          id = 17,
          name = "lamp",
          type = "torch",
          shape = "rectangle",
          x = 168,
          y = 40,
          width = 8,
          height = 16,
          rotation = 0,
          gid = 259,
          visible = true,
          properties = {
            ["backlight"] = true,
            ["lit"] = true
          }
        },
        {
          id = 18,
          name = "lamp",
          type = "torch",
          shape = "rectangle",
          x = 200,
          y = 40,
          width = 8,
          height = 16,
          rotation = 0,
          gid = 259,
          visible = true,
          properties = {
            ["backlight"] = true,
            ["lit"] = true
          }
        },
        {
          id = 21,
          name = "stair",
          type = "stair",
          shape = "polyline",
          x = 168,
          y = 63,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polyline = {
            { x = 1, y = 0 },
            { x = 88, y = -87 }
          },
          properties = {}
        }
      }
    },
    {
      type = "tilelayer",
      name = "fg",
      x = 0,
      y = 0,
      width = 30,
      height = 8,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 26, 42, 43,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 26, 42, 43, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 26, 42, 43, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 26, 42, 43, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 26, 42, 43, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 26, 42, 43, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 26, 42, 43, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 41, 42, 43, 0, 0, 0, 0, 0, 0, 0
      }
    }
  }
}
