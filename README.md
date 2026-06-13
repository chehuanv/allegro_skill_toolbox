# allegro_skill_toolbox

Allegro PCB Editor SKILL 工具箱，基于 Cadence SPB 17.4 / 24.1 开发。

## 功能模块

- **Package**：封装编辑工具（原点切换、焊盘优化、禁布区、重命名、FLASH、导出等）
- **Layout**：布局工具（按页摆放、聚拢、对齐、等距、格点、镜像等）
- **Routing**：布线工具（切线截铜、过孔替换、线宽调整、差分、挖空、打孔等）
- **Text/Silk**：字符丝印工具（字体设置、REF 调整、中文、LOGO 等）
- **Manufacturing**：工艺制造工具（Gerber、PDF、DXF/3D、坐标、拼板、阻抗等）
- **Utilities**：辅助工具（单位换算、库路径、颜色、快捷键、刷色、换层等）

## 安装与加载

### 方法 1：通过 allegro.ilinit 自动加载

将 `allegro_skill_toolbox/allegro.ilinit` 的内容添加到你的 Allegro 启动目录下的 `allegro.ilinit` 中：

```skill
ASTB_INSTALL_DIR = "D:/Cadence/MFLXskill"
setSkillPath(cons(ASTB_INSTALL_DIR getSkillPath()))
load(strcat(ASTB_INSTALL_DIR "/allegro_skill_toolbox/main.il"))
```

### 方法 2：手动加载

在 Allegro SKILL 控制台执行：

```skill
load("D:/Cadence/MFLXskill/allegro_skill_toolbox/main.il")
```

## 使用

加载成功后，Allegro 菜单栏会出现 **allegro_skill_toolbox** 菜单。

常用系统命令：

- `ASTB_About`：显示工具箱信息
- `ASTB_Reload`：重新加载所有模块

## 项目结构

```
allegro_skill_toolbox/
├── allegro.ilinit          # 自动加载入口示例
├── main.il                 # 主框架：路径发现、加载、菜单注入
├── core/                   # 核心公共模块
│   ├── utils.il            # 通用工具函数
│   ├── trans.il            # 事务与错误处理
│   ├── loader.il           # 模块自动加载
│   ├── menu.il             # 菜单构建与注入
│   ├── config.il           # 配置管理
│   ├── form_utils.il       # UI/表单工具
│   └── version_adapter.il  # 版本适配
├── modules/                # 功能模块
│   ├── package/            # 封装模块
│   ├── placement/          # 布局模块
│   ├── routing/            # 布线模块
│   ├── text/               # 字符模块
│   ├── manufacturing/      # 工艺模块
│   ├── utilities/          # 辅助功能模块
│   └── _stubs.il           # 未实现功能的占位函数
├── config/                 # 用户配置文件
│   └── astb.cfg
├── forms/                  # 表单文件
├── docs/                   # 开发文档
│   └── coding_standard.md
└── icons/                  # 图标资源
```

## 开发规范

详见 [docs/coding_standard.md](docs/coding_standard.md)。

核心要求：

- 所有 `.il` 文件使用 **GBK/GB18030** 编码
- 数据库修改操作必须包裹事务
- 兼容 SPB 17.4 和 SPB 24.1

## 当前状态

Phase 0 基础设施已搭建完成，所有菜单命令均有占位实现。后续将按 Phase 1-6 逐步实现各业务功能。
