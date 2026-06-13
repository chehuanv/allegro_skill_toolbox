# Allegro SKILL Toolbox - 编码规范

## 1. 文件编码与格式

- **所有 `.il` 源码文件**：必须使用 **GBK / GB18030** 编码保存
- **所有 `.form` 表单文件**：必须使用 **GBK / GB18030** 编码保存
- **配置文件**：使用 GBK 编码
- **Markdown 文档**：可使用 UTF-8（本文档除外）
- 换行符：CRLF (Windows)
- 缩进：2 个空格

## 2. 命名规范

| 类型 | 命名规则 | 示例 |
|------|----------|------|
| 命令注册名 | `cXxxYyy` 或 `ASTB_xxx` | `ASTB_Util_UnitConvert` |
| 公共过程函数 | `PascalCase`，前缀 `ASTB_` | `ASTB_BBoxCenter` |
| 局部变量 | `lCamelCase`，前缀 `l` | `lSelected` |
| 全局变量 | `gCamelCase`，前缀 `g` 或使用 `defvar` | `ASTB_GLOBAL` |
| 常量 | 全大写 | `ASTB_VERSION` |
| 文件命名 | 小写下划线 | `util_unit.il` |

## 3. 文件头模板

```skill
;; ============================================================
;; File: modules/utilities/util_unit.il
;; Purpose: 单位换算工具
;; Encoding: GBK (Simplified Chinese)
;; Note: Save this file in GBK encoding, do NOT use UTF-8
;; ============================================================
```

## 4. 注释规范

- 函数前必须包含注释说明：功能、参数、返回值
- 复杂逻辑必须加行注释
- 中文注释使用 GBK 编码

```skill
;;=========================================================================
;; 功能：计算两个边界框的中心点
;; 参数：bBox - 边界框，格式 ((x1 y1) (x2 y2))
;; 返回：(x y) 中心点坐标
;;=========================================================================
procedure( ASTB_BBoxCenter(bBox)
  ...
)
```

## 5. 错误处理与事务

所有修改 Allegro 数据库的操作必须满足：

1. **使用事务包裹**：
```skill
procedure( MyCommand()
  prog((txId)
    txId = axlDBTransactionStart("ASTB")
    errset(
      ;; 数据库操作
      t
    )
    if( errset
    then
      axlDBTransactionRollback(txId)
      ASTB_MsgError("操作失败")
      return(nil)
    else
      axlDBTransactionCommit(txId)
      return(t)
    )
  )
)
```

2. **优先使用核心封装**：
```skill
ASTB_DBTransaction('MyCommand_Impl nil)
```

3. **给用户清晰的错误提示**，不要吞掉异常。

## 6. 版本兼容性

- 使用 `ASTB_GetVersion()` / `ASTB_IsVersion174()` / `ASTB_IsVersion241()` 做版本判断
- 不同版本的 API 差异封装在 `core/version_adapter.il`
- 避免使用仅在单版本可用的函数

## 7. 用户交互

- 简单功能：命令行提示即可
- 需要多参数：使用 `.form` 表单
- 危险操作：必须提供预览或确认对话框
- 长时间操作：显示进度提示

## 8. 配置管理

- 用户参数保存到 `config/astb.cfg`
- 使用 `ASTB_GetConfig(key default)` 读取
- 使用 `ASTB_SetConfig(key value)` 写入

## 9. 模块开发流程

1. 在 `modules/<模块>/` 下创建 `.il` 文件
2. 文件加载时自动注册命令（调用 `ASTB_RegisterCommand`）
3. 实现函数体，确保有错误处理
4. 更新菜单（如需要新增菜单项，修改 `core/menu.il`）
5. 在 Allegro 中执行 `ASTB_Reload` 测试

## 10. 禁止事项

- 严禁在 `.il` 文件中使用 UTF-8 编码保存中文
- 严禁无事务保护直接修改数据库
- 严禁使用全局变量保存临时状态（使用局部变量或 config）
- 严禁在代码中硬编码绝对路径（使用配置项）
