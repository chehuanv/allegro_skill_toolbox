# Cadence Allegro Skill 详细代码规范

本文档基于 Cadence Allegro Skill 官方示例代码（17.4和24.1版本）编写，提供了详细的代码规范和实践指南。

---

## 目录

1. [文件结构规范](#1-文件结构规范)
2. [代码格式规范](#2-代码格式规范)
3. [命名规范](#3-命名规范)
4. [注释规范](#4-注释规范)
5. [函数定义规范](#5-函数定义规范)
6. [变量和作用域规范](#6-变量和作用域规范)
7. [错误处理规范](#7-错误处理规范)
8. [表单编程规范](#8-表单编程规范)
9. [数据库操作规范](#9-数据库操作规范)
10. [UI和菜单规范](#10-ui和菜单规范)
11. [选择和操作规范](#11-选择和操作规范)
12. [调试和日志规范](#12-调试和日志规范)
13. [性能优化规范](#13-性能优化规范)
14. [代码组织规范](#14-代码组织规范)
15. [最佳实践](#15-最佳实践)
16. [完整示例模板](#16-完整示例模板)

---

## 1. 文件结构规范

### 1.1 标准文件头格式

每个Skill文件应以详细的文件头开始，包含完整的元数据信息：

```skill
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; filename.il --
;
; Author --
;    您的名字 (Cadence Design Systems - 示例代码)
;
; Function --
;    简要描述文件的功能和用途
;    可以包含多行描述
;
; Copyright, 2024, 公司名称
; No part of this file may be reproduced, stored in a retrieval system,
; or transmitted in any form or by any means --- electronic, mechanical,
; photocopying, recording, or otherwise --- without prior written permission
; of 公司名称.
;
; WARRANTY:
; NONE. NONE. NONE.
; Use all material in this code at your own risk.
;
; RESTRICTIONS:
; 详细说明使用限制和权限
;
; Version History:
; 2024-01-01 - 初始版本
; 2024-02-01 - 添加新功能
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
```

**关键点：**
- 使用分号开头的注释块
- 包含版权和 warranty 声明（参考官方示例）
- 添加版本历史记录
- 文件头长度通常为20-30行

### 1.2 文件命名规范

**命名规则：**
- 使用小写字母和下划线组合：`my_function.il`
- 文件名应具有描述性，反映文件内容
- 扩展名使用 `.il` (Skill代码) 或 `.form` (表单定义)
- 测试文件可以使用 `te_` 或 `test_` 前缀

**示例：**
```skill
; 好的命名
dbcreate.il          ; 数据库创建功能
form_test.il         ; 表单测试代码
show_element.il      ; 显示元素功能

; 避免的命名
abc.il               ; 无意义
myFile.il            ; 混合大小写
db cr8.il            ; 使用数字和空格
```

### 1.3 文件组织顺序

推荐的文件内容组织顺序：

```skill
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 文件头注释
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;----------------------------------------------------------------
; 1. 配置和初始化代码
;----------------------------------------------------------------
unless(boundp('g_globalVar) g_globalVar = nil)

;----------------------------------------------------------------
; 2. 别名定义（可选）
;----------------------------------------------------------------
alias(fset axlFormSetField)
alias(fget axlFormGetField)

;----------------------------------------------------------------
; 3. 辅助函数（私有函数）
;----------------------------------------------------------------
defun(_helperFunction()
    ; 辅助函数以_开头
)

;----------------------------------------------------------------
; 4. 主要函数（公开函数）
;----------------------------------------------------------------
defun(mainFunction()
    ; 主要逻辑
)

;----------------------------------------------------------------
; 5. 测试函数
;----------------------------------------------------------------
defun(test_mainFunction()
    ; 测试代码
)

;----------------------------------------------------------------
; 6. 命令注册（可选）
;----------------------------------------------------------------
axlCmdRegister("mycmd" 'mainFunction)
```

---

## 2. 代码格式规范

### 2.1 缩进与对齐

**标准缩进规则：**

```skill
; 好的示例 - 使用4个空格缩进
procedure( myFunction( param1 param2 )
    let( (localVar1 localVar2)
        localVar1 = param1 + param2
        when( localVar1 > 0
            printf("Value: %d\n" localVar1)
            if( localVar1 > 100
                printf("Large value\n")
                printf("Small value\n")
            )
        )
    )
)

; 避免的格式 - 不一致的缩进
procedure( myFunction( param1 param2 )
let( (localVar1 localVar2)
localVar1 = param1 + param2
when( localVar1 > 0
printf("Value: %d\n" localVar1)
)
)
)
```

**括号对齐风格：**

```skill
; 风格1：K&R风格（推荐）
procedure( myFunction( param )
    let( (result)
        result = param * 2
        result
    )
)

; 风格2：ANSI风格
procedure( myFunction( param )
           let( (result)
                result = param * 2
                result
              )
         )

; 避免：不一致的括号位置
procedure( myFunction( param )
    let( (result)
        result = param * 2
        result))
```

### 2.2 空格使用规则

**操作符空格：**

```skill
; 好的示例
a = b + c           ; 赋值和操作符前后加空格
x = (a + b) * c     ; 括号内不加空格
result = func(a, b) ; 逗号后加空格，函数名后不加

; 避免的示例
a=b+c               ; 缺少空格
x=(a+b)*c           ; 括号内紧凑
result=func (a,b)   ; 函数名后多余空格
```

**特殊空格规则：**

```skill
; 逗号后必须加空格
list("item1", "item2", "item3")

; 冒号前后不加空格（坐标表示）
location = 0.7:6.3

; 引号内字符串保持原样
string = "Hello World"
```

### 2.3 换行规则

**长表达式换行：**

```skill
; 好的示例 - 在操作符前换行
result = axlDBCreatePath(
    axlPathStart(list(0:0, 10:0, 20:0), 0.2),
    "ETCH/TOP",
    "net1"
)

; 避免的示例 - 随意换行
result = axlDBCreatePath(axlPathStart(list(0:0, 
10:0, 20:0), 0.2), "ETCH/TOP", "net1")
```

**函数调用换行：**

```skill
; 当参数较多时，每个参数一行
axlFormSetField(fw, 
    "fieldName", 
    value1, 
    value2, 
    value3
)

; 或者对齐参数
axlFormSetField(fw, "field1", value1)
axlFormSetField(fw, "field2", value2)
axlFormSetField(fw, "field3", value3)
```

---

## 3. 命名规范

### 3.1 函数命名

**自定义函数命名规则：**

```skill
; 使用小写字母和下划线（推荐）
defun( calculate_trace_width()
defun( create_component_symbol()
procedure( validate_design_rules()

; 或者使用驼峰命名（较少使用）
defun( calculateTraceWidth()
defun( createComponentSymbol()

; 测试函数使用 test_ 或 te_ 前缀
defun( test_create_symbol()
defun( te_args_validation()

; 回调函数使用 _callback 或 CB 结尾
procedure( _afCallback(fw)
defun( myFormCallback(theForm)
```

**Cadence官方API函数命名：**

```skill
; 以 axl 前缀开头
axlDBCreateSymbol()
axlMsgPut()
axlFormCreate()
axlGetSelSet()

; 特定功能前缀
axlDB*       ; 数据库操作
axlForm*     ; 表单操作
axlUI*       ; UI操作
axlCmd*      ; 命令操作
axlSet*      ; 设置操作
axlGet*      ; 获取操作
```

### 3.2 变量命名

**局部变量命名：**

```skill
; 使用驼峰命名或小写加下划线
let( (myVariable localCount indexValue)
    myVariable = 10
    localCount = 0
    indexValue = nil
)

; 单字符变量用于循环
foreach( x myList
    printf("Item: %L\n" x)
)

for( i 1 10
    printf("Index: %d\n" i)
)
```

**全局变量命名：**

```skill
; 使用描述性名称，可以添加 g_ 前缀
g_formHandle = nil       ; 表单句柄
g_selectedObjects = nil  ; 选中的对象
g_myGlobalVar = nil      ; 通用全局变量

; 避免使用过于简短的名称
globalVar = nil          ; 避免
temp = nil               ; 避免
```

**特殊变量命名：**

```skill
; 表单相关变量
fw = nil        ; form handle (常用缩写)
theForm = nil   ; form handle (描述性)
f1s = nil       ; form handle with suffix

; 弹出菜单变量
myPopup = nil
mypopup = nil   ; 官方示例中使用小写

; 迭代变量
cnt = 0         ; counter
idx = 0         ; index
item = nil      ; current item
```

### 3.3 常量命名

```skill
; 使用大写字母和下划线
define( MAX_WIDTH 100 )
define( DEFAULT_LAYER "ETCH/TOP" )
define( PI 3.1415926 )

; 或者使用 defvar（如果需要）
defvar( *MAX_WIDTH* 100 )
defvar( *DEFAULT_LAYER* "ETCH/TOP" )
```

---

## 4. 注释规范

### 4.1 注释风格

**单行注释：**

```skill
; 这是单行注释
axlMsgPut("Hello")  ; 行尾注释（谨慎使用）

; TODO: 需要添加错误处理
; FIXME: 此函数在边界情况下可能失败
; HACK: 临时解决方案
```

**函数说明注释：**

```skill
;;
;; myFunction - 函数功能描述
;;   参数：
;;     param1: 参数1说明
;;     param2: 参数2说明
;;   返回值：
;;     返回结果的说明
;;   示例：
;;     myFunction(1, 2)
;;
defun( myFunction( param1 param2 )
    ; 函数体
)
```

**分隔线注释：**

```skill
;----------------------------------------------------------------
; 主要部分标题
;----------------------------------------------------------------

;--------------------------------------------------------------------------
; 另一个部分
;--------------------------------------------------------------------------

;--------------------------------------------------------------
; 子部分
;--------------------------------------------------------------
```

**块注释：**

```skill
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 这是一个块注释
; 可以包含多行说明
; 通常用于文件头或重要部分
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
```

### 4.2 注释内容规范

**函数注释应包含：**

```skill
;;
;; calculateTraceWidth - 计算走线宽度
;;
;; 参数：
;;   current: 电流值（安培）
;;   layer: 层名称（如 "ETCH/TOP"）
;;
;; 返回值：
;;   返回计算出的走线宽度（密耳）
;;
;; 示例：
;;   width = calculateTraceWidth(2.5, "ETCH/TOP")
;;
defun( calculateTraceWidth( current layer )
    ; 实现
)
```

**复杂逻辑注释：**

```skill
; 计算信号上升时间
; 公式：tr = 0.35 / fmax
; 其中 fmax 为最大频率
riseTime = 0.35 / maxFreq

; 检查设计规则
; DRC检查包括：
; 1. 线宽检查
; 2. 间距检查
; 3. 过孔检查
when( checkDesignRules()
    ; 处理DRC错误
)
```

**临时代码标记：**

```skill
; TODO: 需要添加错误处理
; FIXME: 此函数在边界情况下可能失败
; HACK: 临时解决方案，需要重构
; XXX: 有疑问的代码
; NOTE: 重要说明
```

---

## 5. 函数定义规范

### 5.1 使用 `defun` 或 `procedure`

**defun - 定义全局函数（推荐）：**

```skill
; 基本语法
defun( functionName( param1 param2 )
    ; 函数体
    ; 最后一个表达式的值为返回值
)

; 示例
defun( myGlobalFunc( param1 param2 )
    let( (result)
        result = param1 + param2
        result  ; 返回值
    )
)
```

**procedure - 定义函数，支持词法作用域：**

```skill
; 基本语法
procedure( functionName( param1 )
    ; 函数体
)

; 示例
procedure( myFunc( param )
    let( (localVar)
        localVar = param * 2
        localVar
    )
)
```

**选择建议：**
- 使用 `defun` 定义全局可访问的函数
- 使用 `procedure` 当需要词法作用域时
- 官方示例中使用 `defun` 较多

### 5.2 函数参数处理

**参数验证：**

```skill
defun( myFunction( param1 param2 )
    ; 参数数量检查
    unless( param1 && param2
        error("Invalid parameters")
        return(nil)
    )
    
    ; 参数类型检查
    unless( numberp(param1)
        error("param1 must be a number")
        return(nil)
    )
    
    ; 参数范围检查
    when( param1 < 0
        axlMsgPut("**Warning: param1 is negative")
    )
    
    ; 主要逻辑
)
```

**可选参数处理：**

```skill
defun( myFunction( param1 @optional param2 param3 )
    ; 设置默认值
    unless( param2
        param2 = "default"
    )
    unless( param3
        param3 = 0
    )
    
    ; 主要逻辑
)
```

**关键字参数：**

```skill
; 使用 ?key 形式（如果支持）
; 或者传递关联列表
defun( myFunction( options )
    let( (width height layer)
        ; 从options中提取参数
        width = getSkillVar(options 'width 10)
        height = getSkillVar(options 'height 20)
        layer = getSkillVar(options 'layer "ETCH/TOP")
    )
)
```

### 5.3 函数体结构

**使用 let 绑定局部变量：**

```skill
defun( myFunction( param )
    let( (localVar1 localVar2 result)
        ; 初始化
        localVar1 = param * 2
        localVar2 = 10
        
        ; 计算
        result = localVar1 + localVar2
        
        ; 返回值
        result
    )
)
```

**使用 prog 进行程序块控制：**

```skill
defun( myFunction( param )
    prog( (result)
        ; 可能需要提前返回
        when( param == nil
            return(nil)
        )
        
        ; 主要逻辑
        result = param * 2
        
        ; 返回值
        result
    )
)
```

**选择建议：**
- 使用 `let` 进行简单的局部变量绑定
- 使用 `prog` 当需要提前返回或复杂控制流时

### 5.4 返回值处理

**隐式返回（推荐）：**

```skill
defun( calculate( a b )
    let( (result)
        result = a + b
        result  ; 最后一个表达式的值为返回值
    )
)
```

**显式返回：**

```skill
defun( checkValue( x )
    when( x < 0
        return(nil)  ; 提前返回
    )
    
    when( x > 100
        return(t)    ; 提前返回
    )
    
    x * 2  ; 正常返回值
)
```

**多返回值（使用列表）：**

```skill
defun( getWidthAndHeight()
    let( (width height)
        width = 10
        height = 20
        list(width, height)  ; 返回列表
    )
)

; 调用
result = getWidthAndHeight()
width = car(result)
height = cadr(result)
```

---

## 6. 变量和作用域规范

### 6.1 全局变量管理

**避免重复初始化：**

```skill
; 好的示例 - 使用 unless(boundp(...))
unless( boundp('g_myGlobalVar)
    g_myGlobalVar = nil
    g_myGlobalVar2 = t
)

; 避免的示例 - 每次加载都重新初始化
g_myGlobalVar = nil
g_myGlobalVar2 = t
```

**全局变量声明：**

```skill
; 在文件开头声明全局变量
unless( boundp('g_formHandle) g_formHandle = nil )
unless( boundp('g_selectedNet) g_selectedNet = nil )

; 或者使用 defvar（如果支持）
defvar( '*g_debug_mode* nil )
```

### 6.2 局部变量管理

**使用 let 绑定局部变量：**

```skill
let( (var1 var2 var3)
    var1 = 10
    var2 = "hello"
    var3 = nil
    
    ; 使用变量
    printf("var1=%d, var2=%s\n" var1 var2)
)
```

**变量初始化：**

```skill
; 好的示例 - 显式初始化
let( (count result list)
    count = 0
    result = nil
    list = nil
)

; 避免的示例 - 依赖默认值
let( (count result list)
    ; count, result, list 默认为 nil
)
```

### 6.3 变量作用域规则

**全局变量访问：**

```skill
; 在函数内部访问全局变量
defun( myFunc()
    ; 可以直接访问
    g_formHandle = axlFormCreate(...)
    
    ; 或者通过全局符号访问
    set( 'g_myVar 10 )
    value = get( 'g_myVar )
)
```

**局部变量遮蔽：**

```skill
g_globalVar = 100

defun( testScope()
    let( (g_globalVar)  ; 局部变量遮蔽全局变量
        g_globalVar = 200
        printf("Local: %d\n" g_globalVar)  ; 输出 200
    )
    
    printf("Global: %d\n" g_globalVar)  ; 输出 100
)
```

---

## 7. 错误处理规范

### 7.1 使用 `errset` 包裹可能出错的代码

```skill
; 基本用法
errset(
    result = axlDBCreatePath(path, layer, net)
)

; 检查执行结果
when( errset( result = axlDBCreatePath(path, layer, net) )
    printf("Success: %L\n" result)
    ; 继续处理
)

; 忽略错误（不推荐）
errset( 
    axlDBCreateSymbol("R1" 0:0)
    t  ; 第二个参数为 t 时忽略错误
)
```

### 7.2 使用 `when` 和 `unless` 进行条件判断

**when - 当条件为真时执行：**

```skill
; 好的示例
when( fileHandle
    close(fileHandle)
)

when( validData
    processData(validData)
    return(t)
)

; 多个条件
when( param1 && numberp(param1) && param1 > 0
    processParam(param1)
)
```

**unless - 当条件为假时执行：**

```skill
; 好的示例
unless( validData
    error("Invalid data")
    return(nil)
)

unless( boundp('g_initialized)
    initGlobalVars()
)
```

**避免深层嵌套：**

```skill
; 好的示例 - 使用 when/unless 提前返回
defun( processData( data )
    unless( data
        error("No data provided")
        return(nil)
    )
    
    unless( listp(data)
        error("Data must be a list")
        return(nil)
    )
    
    ; 主要逻辑
    foreach( item data
        processItem(item)
    )
    
    t
)

; 避免的示例 - 深层嵌套
defun( processData( data )
    if( data != nil then
        if( listp(data) then
            foreach( item data
                processItem(item)
            )
            t
        else
            error("Data must be a list")
            nil
        )
    else
        error("No data provided")
        nil
    )
)
```

### 7.3 使用 `error` 和 `warn` 报告错误

```skill
; 报告错误
error("Invalid parameter: %L" param)

; 报告警告
warn("Deprecated function called")

; 在消息区显示信息
axlMsgPut("**Error: Invalid parameter")
axlMsgPut("**Warning: Value out of range")
```

---

## 8. 表单编程规范

### 8.1 表单创建流程

**标准表单创建模板：**

```skill
;----------------------------------------------------------------
; 全局表单句柄
;----------------------------------------------------------------
unless( boundp('f1s) f1s = nil )

;----------------------------------------------------------------
; 公开测试函数
;----------------------------------------------------------------
procedure( formtest() 
    f1s = IFormTest(f1s)
)

;----------------------------------------------------------------
; 表单创建函数
;----------------------------------------------------------------
procedure( IFormTest(fw)
    prog( (position)
        
        ; 好实践：如果表单已打开，暴露它并返回
        when( fw 
            axlUIWExpose(fw)
            return(fw)
        )
        
        ; 设置表单位置
        position = '("NE")  ; 东北角
        
        ; 创建表单
        fw = axlFormCreate('f1s           ; 全局句柄符号
                          "myform.form"  ; 表单文件名
                          position        ; 位置
                          '_myCallback    ; 回调函数
                          t              ; 异步模式
                          nil)           ; 保留参数
        
        ; 设置表单标题
        axlFormTitle(fw "我的表单标题")
        
        ; 初始化表单字段
        IFormRefresh(fw)
        
        ; 显示表单
        axlFormDisplay(fw)
        
        return(fw)  ; 返回表单句柄
    )
)
```

### 8.2 回调函数结构

**标准回调函数模板：**

```skill
defun( _myFormCallback( fw )
    prog( (field value)
        
        ; 1. 处理鼠标活动帮助（可选）
        when( fw->mouseActive 
            axlFormSetField(fw "active_help" 
                          sprintf(nil "Help for %s" fw->curField))
            return(t)
        )
        
        ; 2. 打印调试信息（开发阶段）
        printf("Field: %L = %L\n" fw->curField fw->curValue)
        printf("doneState: %L\n" fw->doneState)
        
        ; 3. 根据字段名处理事件
        case( fw->curField
            
            ; 选项卡切换
            ("tab"
                ; 保存当前选项卡
                putprop(fw fw->curValue 'lastTab)
            )
            
            ; 按钮处理
            ("button_ok"
                ; 保存数据
                saveData(fw)
                ; 关闭表单
                axlFormClose(fw)
            )
            
            ("button_cancel"
                ; 取消操作
                axlFormClose(fw)
            )
            
            ("button_apply"
                ; 应用更改但不关闭
                applyChanges(fw)
            )
            
            ; 列表字段事件
            ("listfield"
                ; 更新相关字段
                axlFormSetField(fw "listtext" fw->curValue)
                ; 检查双击
                when( fw->doubleClick 
                    printf("Double Click listfield!\n")
                )
            )
            
            ; 复选框处理
            ("checkbox"
                ; curValue 为 t 或 nil
                when( fw->curValue
                    enableRelatedFields(fw)
                )
            )
            
            ; 单选按钮处理
            ("radio1"
                ; 处理单选按钮选择
                handleRadioSelection(fw)
            )
            
            ; 枚举字段处理
            ("enum"
                ; 根据选择更新其他字段
                updateDependentFields(fw)
            )
        )
        
        ; 4. 检查是否完成
        when( fw->doneState
            axlFormClose(fw)
        )
        
        return()  ; 回调函数通常返回 nil 或 t
    )
)
```

### 8.3 表单字段操作

**设置字段值：**

```skill
; 设置文本字段
axlFormSetField(fw, "string_field", "hello")

; 设置数值字段
axlFormSetField(fw, "int_field", 50)
axlFormSetField(fw, "float_field", 20.1006)

; 设置枚举字段
axlFormSetField(fw, "enum_field", "1")       ; 通过索引
axlFormSetField(fw, "enum_field", "item1")   ; 通过名称

; 设置复选框
axlFormSetField(fw, "checkbox", t)    ; 选中
axlFormSetField(fw, "checkbox", nil)  ; 未选中

; 设置单选按钮
axlFormSetField(fw, "radio1", t)      ; 选中第一个
axlFormSetField(fw, "radio2", t)      ; 选中第二个

; 设置列表字段（单次调用，推荐）
axlFormSetField(fw, "listfield", 
    '("item1" "item2" "item3" "item4"))

; 设置多行文本
axlFormSetField(fw, "mline", 
    "Show multi-line\nLine 2\nLine 3\nLine 4")

; 设置进度条
axlFormSetField(fw, "progress", '(5 100 15))
```

**获取字段值：**

```skill
; 获取字段值
value = axlFormGetField(fw, "fieldName")

; 或者通过点号访问
value = fw->curValue
fieldName = fw->curField
```

**字段属性操作：**

```skill
; 设置字段可编辑性
axlFormSetFieldEditable(fw, "fieldName", t)    ; 可编辑
axlFormSetFieldEditable(fw, "fieldName", nil)  ; 只读

; 设置字段可见性
axlFormSetFieldVisible(fw, "fieldName", t)     ; 可见
axlFormSetFieldVisible(fw, "fieldName", nil)   ; 隐藏

; 设置字段信息（提示文本）
axlFormSetInfo(fw, "fieldName", "This is a hint")
```

**列表字段操作：**

```skill
; 删除所有列表项
axlFormListDeleteAll(fw, "listfield")

; 添加列表项（单个）
axlFormListAddItem(fw, "listfield", "new item", -1)  ; 添加到末尾

; 添加列表项（批量，推荐）
axlFormSetField(fw, "listfield", 
    '("item1" "item2" "item3"))

; 选择列表项
axlFormListSelect(fw, "listfield", "item2")

; 删除列表项
axlFormListDeleteItem(fw, "listfield", 2)  ; 删除索引2的项

; 获取选中项
selectedItem = axlFormListGetSelItems(fw, "listfield")
selectedCount = axlFormListGetSelCount(fw, "listfield")
```

### 8.4 动态构建弹出菜单

```skill
; 方法1：使用关联列表
axlFormBuildPopup(fw, "enum_field", 
    '(("item1" "1") ("item2" "2") ("item3" "3")))

; 方法2：使用简单列表
axlFormBuildPopup(fw, "enum_field", 
    '("item1" "item2" "item3"))

; 方法3：带颜色和字体的弹出菜单
axlFormBuildPopup(fw, "enumcolor", 
    '(("green" 1 green) 
      ("yellow" 2 yellow bold) 
      ("red" 3 red underline)))
```

### 8.5 表单颜色操作

```skill
; 设置字段背景色
axlFormColorize(fw, "fieldName", 'background, 'red)

; 设置字段文本色
axlFormColorize(fw, "fieldName", 'text, 'blue)

; 清除颜色
axlFormColorize(fw, "fieldName", 'background, nil)
axlFormColorize(fw, "fieldName", 'text, nil)
```

---

## 9. 数据库操作规范

### 9.1 创建数据库对象

**创建Symbol：**

```skill
; 简单refdes
axlDBCreateSymbol("R1" 0.7:6.3)

; 带格式的symbol
axlDBCreateSymbol(list("target" "format") 1.5:7.0)

; 机械symbol
axlDBCreateSymbol(list("mtg156" "Mechanical") 3.0:7.0)

; Package symbol（带旋转和镜像）
axlDBCreateSymbol(list("DIP14_3" "package") 2.8:6.1, nil, 340)
axlDBCreateSymbol(list("DIP14_3" "package") 3:4.7, t, 350)  ; t=mirror
```

**创建Path：**

```skill
; 创建简单路径
path = axlPathStart(list(0:0, 10:0, 20:10), 0.2)
axlDBCreatePath(path, "ETCH/TOP", "net1")

; 创建复杂路径
points = list(0:0, 100:0, 100:100, 200:100)
path = axlPathStart(points, 10)  ; 10密耳线宽
axlDBCreatePath(path, "ETCH/TOP", "VCC")
```

**创建Pad：**

```skill
; 创建焊盘
axlDBCreatePad("PAD100" 0:0 "ROUND" 100)
```

**创建Via：**

```skill
; 创建过孔
axlDBCreateVia("VIA10" 0:0 "VIA" 10)
```

### 9.2 查询数据库

**获取选中对象：**

```skill
; 获取当前选中的对象
objects = axlGetSelSet()

; 遍历对象
foreach( obj objects
    printf("Object: %L\n" obj)
    printf("Type: %L\n" typeof(obj))
)
```

**按条件查询：**

```skill
; 获取所有网络
nets = axlDBGetDesign()->nets

; 获取所有器件
components = axlDBGetDesign()->components

; 获取所有引脚
pins = axlDBGetDesign()->pins

; 按名称查找
net = axlDBFindNet("VCC")
component = axlDBFindComp("U1")
```

**获取对象属性：**

```skill
; 获取对象属性
when( obj->objType == "net"
    printf("Net name: %s\n" obj->name)
    printf("Net length: %f\n" obj->length)
)

; 获取引脚属性
when( pin = axlDBGetPin("U1" "1")
    printf("Pin number: %s\n" pin->pinNumber)
    printf("Pin name: %s\n" pin->pinName)
)
```

### 9.3 修改数据库对象

**修改对象属性：**

```skill
; 修改线宽
when( path = axlDBGetPath("net1")
    path->width = 20  ; 修改线宽为20密耳
)

; 移动对象
axlDBMoveObject(symbol, 10:10)  ; 移动到新位置

; 删除对象
axlDBDeleteObject(object)
```

**批量操作：**

```skill
; 批量修改网络属性
foreach( net axlDBGetDesign()->nets
    when( net->name == "GND"
        ; 对GND网络特殊处理
        net->color = "blue"
    )
)
```

---

## 10. UI和菜单规范

### 10.1 命令注册

**基本命令注册：**

```skill
; 注册交互式命令
axlCmdRegister("mycmd" 'MyCommand ?cmdType "interactive")

; 注册非交互式命令
axlCmdRegister("mycmd" 'MyCommand ?cmdType "noninteractive")

; 带帮助信息的命令注册
axlCmdRegister("mycmd" 'MyCommand 
    ?cmdType "interactive"
    ?help "This command does...")
```

### 10.2 弹出菜单定义

**基本弹出菜单：**

```skill
defun( MyCommand()
    ; 定义弹出菜单
    myPopup = axlUIPopupDefine(nil, 
        list(
            list("Done" 'axlFinishEnterFun)
            list("Cancel" 'axlCancelEnterFun)
            list(separator)  ; 分隔线
            list("Info" 'showInfoCallback)
        ))
    
    ; 设置弹出菜单
    axlUIPopupSet(myPopup)
    
    ; 开始交互式选择
    while(axlSelect(), 
        processSelection(axlGetSelSet())
    )
)
```

**复杂弹出菜单：**

```skill
defun( MyAdvancedCommand()
    myPopup = axlUIPopupDefine(nil, 
        list(
            list("Done" 'axlFinishEnterFun)
            list("Cancel" 'axlCancelEnterFun)
            list(separator)
            list("Select" 'selectCallback)
            list("Filter" 
                list("By Name" 'filterByName)
                list("By Type" 'filterByType)
                list("By Net" 'filterByNet)
            )
            list(separator)
            list("Options" 'optionsCallback)
        ))
    
    axlUIPopupSet(myPopup)
    
    ; 设置查找过滤器
    axlSetFindFilter(?enabled, '("NOALL", "ALLTYPES", "NAMEFORM")
                     ?onButtons "ALLTYPES")
    
    ; 开始选择
    while(axlSelect(), 
        axlShowObject(axlGetSelSet())
    )
)
```

### 10.3 菜单编辑

**查找菜单项：**

```skill
; 查找菜单项
q = axlUIMenuFind(nil "add rect")     ; 按名称查找
q = axlUIMenuFind(nil 3 'bottom)      ; 按索引查找（从0开始）
q = axlUIMenuFind(nil -1 'top)        ; 查找最后一个菜单项
q = axlUIMenuFind(nil -1)             ; 查找菜单栏末尾
```

**插入菜单项：**

```skill
; 插入分隔线
q = axlUIMenuFind(nil "add rect")
z = axlUIMenuInsert(q 'separator)

; 插入命令
q = axlUIMenuFind(nil 3 'bottom)
z = axlUIMenuInsert(q "add hello" "echo hello add")

; 插入网页链接
q = axlUIMenuFind(nil -1 'top)
z = axlUIMenuInsert(q "Google" "http \"http://google.com\"")

; 插入子菜单（列表方法）
q = axlUIMenuFind(nil -1)
l = '((popup "Drop1") 
      ("hello1" "echo hello1") 
      ("hello2" "echo hello2"))
z = axlUIMenuInsert(q l)

; 插入子菜单（逐个调用）
q = axlUIMenuFind(nil -1)
z = axlUIMenuInsert(q 'popup "Drop2")
z = axlUIMenuInsert(nil "hello3" "echo hello 3")
z = axlUIMenuInsert(nil "hello4" "echo hello 4")
z = axlUIMenuInsert(nil 'end)  ; 结束子菜单
```

**修改菜单项：**

```skill
; 禁用菜单项并添加复选框
q = axlUIMenuFind(nil "about")
axlUIMenuChange(q 'enable nil 'check t)

; 启用菜单项
axlUIMenuChange(q 'enable t)
```

**删除菜单项：**

```skill
; 删除菜单项
q = axlUIMenuFind(nil 3 'top)
axlUIMenuDelete(q)

; 删除整个菜单
q = axlUIMenuFind(nil 1)  ; 删除第2个菜单（索引从0开始）
axlUIMenuDelete(q)
```

### 10.4 菜单触发器

**使用 axlUIMenuRegister：**

```skill
; 创建菜单列表
menuList = '(
    (popup "MenuBar")
    ("hello" "echo hello")
    (popup "Pull") 
       ("hello1" "echo hello1") 
       ("hello2" "echo hello2")
    (end)
    (separator)
    ("hello4" "echo hello4")
)

; 注册菜单（在启动时被调用）
procedure( menuTrig1()
    ; 添加到工具菜单底部
    res = axlUIMenuRegister("reports" menuList 'bottom)
    
    ; 在帮助菜单前添加新菜单
    res = axlUIMenuRegister(-1 ml2)
)

; 在初始化时调用
menuTrig1()
```

**使用 axlTriggerSet：**

```skill
; 使用触发器函数
procedure( menuTrig2(t_menufile)
    let( (q)
        printf("MENU FILE= %s\n" t_menufile)
        q = axlUIMenuFind(nil -1)
        res = axlUIMenuInsert(q menuList)
    )
)

; 设置触发器
axlTriggerSet('menu 'menuTrig2)
```

---

## 11. 选择和操作规范

### 11.1 基本选择操作

**交互式选择：**

```skill
defun( SelectObjects()
    ; 定义弹出菜单
    myPopup = axlUIPopupDefine(nil, 
        list(list("Done" 'axlFinishEnterFun)
             list("Cancel" 'axlCancelEnterFun)))
    
    axlUIPopupSet(myPopup)
    
    ; 设置查找过滤器
    axlSetFindFilter(?enabled, '("NOALL", "ALLTYPES")
                     ?onButtons "ALLTYPES")
    
    ; 开始选择循环
    while(axlSelect(), 
        objects = axlGetSelSet()
        foreach( obj objects
            axlShowObject(obj)
        )
    )
)
```

**程序化选择：**

```skill
; 选择所有网络
axlClearSelSet()
axlAddSelectBox(nil "ALL_NETS")

; 按名称选择
axlClearSelSet()
axlAddSelectNet("VCC")
axlAddSelectNet("GND")

; 选择所有器件
axlClearSelSet()
axlSetFindFilter(?onButtons "COMPONENT")
axlSelectAll()
```

### 11.2 查找过滤器设置

```skill
; 启用所有类型
axlSetFindFilter(?enabled, '("NOALL", "ALLTYPES"))

; 启用特定类型
axlSetFindFilter(?enabled, '("NOALL", "COMPONENT", "PIN", "NET"))

; 启用名称表单
axlSetFindFilter(?enabled, '("NOALL", "ALLTYPES", "NAMEFORM")
                 ?onButtons "ALLTYPES")

; 常用的查找过滤器选项：
; "NOALL"       - 禁用ALL
; "ALLTYPES"    - 所有类型
; "COMPONENT"   - 器件
; "PIN"         - 引脚
; "NET"         - 网络
; "PATH"        - 走线
; "VIA"         - 过孔
; "SHAPE"       - 形状
; "TEXT"        - 文本
; "NAMEFORM"    - 名称表单
```

### 11.3 选择集操作

```skill
; 获取当前选择集
objects = axlGetSelSet()

; 清空选择集
axlClearSelSet()

; 添加到选择集
axlAddToSelSet(object)

; 从选择集移除
axlRemoveFromSelSet(object)

; 检查选择集是否为空
when( axlGetSelSet()
    printf("Has selection\n")
)
```

---

## 12. 调试和日志规范

### 12.1 使用 printf 和 println

**基本调试输出：**

```skill
; 使用 printf（格式化输出）
printf("Debug: value = %L\n" myVar)
printf("Test: %s = %d\n" name, value)
printf("List: %L\n" myList)

; 使用 println（简单输出）
println("Reached this point")
println(myVar)

; 格式化说明符：
; %L - 任意类型（推荐）
; %s - 字符串
; %d - 整数
; %f - 浮点数
; %c - 字符
```

**条件调试输出：**

```skill
; 使用全局调试标志
unless( boundp('g_debugMode) g_debugMode = nil )

defun( myFunc()
    when( g_debugMode
        printf("DEBUG: Entering myFunc\n")
    )
    
    ; 主要逻辑
    
    when( g_debugMode
        printf("DEBUG: Exiting myFunc\n")
    )
)
```

### 12.2 使用 axlMsgPut

**在消息区显示信息：**

```skill
; 显示普通信息
axlMsgPut("操作完成")

; 显示警告（以**开头）
axlMsgPut("**警告：参数超出范围")

; 显示错误（以**开头）
axlMsgPut("**错误：无效的参数")

; 显示进度
axlMsgPut("正在处理...")
axlMsgPut("已完成 50%")
```

### 12.3 使用 pprint

**打印复杂数据结构：**

```skill
; 打印列表
pprint(myList)

; 打印关联列表
pprint(myAlist)

; 打印表单字段
pprint(axlFormGetField(fw, "fieldName"))

; 打印对象属性
pprint(object)
```

### 12.4 使用 axlShell 进行性能测试

```skill
; 重置秒表
axlShell("stopwatch reset")

; 执行测试代码
foreach( mapc x many
    axlFormSetField(f1s, "listfield", x)
)

; 停止秒表并显示时间
axlShell("stopwatch stop")
```

### 12.5 调试技巧

**使用 axlUIYesNo 进行交互调试：**

```skill
; 在关键位置添加确认对话框
axlUIYesNo("继续运行？")

; 显示变量值
sprintf(msg, "value = %L" myVar)
axlUIYesNo(msg)
```

**使用 axlUIWPrint 输出到表单：**

```skill
; 输出到表单的信息字段
axlUIWPrint(fw, "info_field", "Debug information")
```

---

## 13. 性能优化规范

### 13.1 列表操作优化

**批量操作优于逐个操作：**

```skill
; 好的方式：一次性设置列表（推荐）
axlFormSetField(fw, "listfield", largeList)

; 避免的方式：多次调用
foreach( item largeList
    axlFormSetField(fw, "listfield", item)  ; 非常慢
)

; 测试性能（来自官方示例）
(defun plisttest ()
    (let (many)
        many = listMany()  ; 生成1000个字符串的列表
        
        ; 测试1 - 逐个SetField（慢）
        println("Test 1 -- new list -- individual SetFields")
        axlFormListDeleteAll(f1s, "listfield")
        axlShell("stopwatch reset")
        foreach( mapc x many
            axlFormSetField(f1s, "listfield", x)
        )
        axlShell("stopwatch stop")
        
        ; 测试2 - 一次性设置（快）
        println("Test 2 -- new list -- One call")
        axlFormListDeleteAll(f1s, "listfield")
        axlShell("stopwatch reset")
        axlFormSetField(f1s, "listfield", many)
        axlShell("stopwatch stop")
    )
)
```

**使用 tconc 构建列表：**

```skill
; 高效构建列表
(defun listMany ()
    (let (manyStrings)
        manyStrings = tconc(nil "0")
        for(cnt 1 1000
            tconc(manyStrings, sprintf(nil, "%d", cnt))
        )
        manyStrings = car(manyStrings)  ; 获取实际列表
    )
)
```

### 13.2 避免重复计算

**缓存重复使用的计算结果：**

```skill
; 好的方式
layer = "ETCH/TOP"
axlDBCreatePath(path1, layer, net)
axlDBCreatePath(path2, layer, net)

; 避免的方式
axlDBCreatePath(path1, "ETCH/TOP", net)
axlDBCreatePath(path2, "ETCH/TOP", net)
```

**使用局部变量存储重复访问的属性：**

```skill
; 好的方式
defun( processObjects( objects )
    foreach( obj objects
        objType = obj->objType  ; 缓存属性
        when( objType == "net"
            processNet(obj)
        )
        when( objType == "pin"
            processPin(obj)
        )
    )
)

; 避免的方式
defun( processObjects( objects )
    foreach( obj objects
        when( obj->objType == "net"  ; 重复访问属性
            processNet(obj)
        )
    )
)
```

### 13.3 数据库操作优化

**批量查询优于逐个查询：**

```skill
; 好的方式 - 一次获取所有网络
nets = axlDBGetDesign()->nets
foreach( net nets
    when( net->name == targetName
        foundNet = net
        break
    )
)

; 避免的方式 - 逐个查找
foundNet = nil
foreach( name netNames
    net = axlDBFindNet(name)  ; 多次查询数据库
    when( net
        foundNet = net
        break
    )
)
```

---

## 14. 代码组织规范

### 14.1 文件组织

**推荐的文件结构：**

```skill
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; filename.il -- 文件描述
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;----------------------------------------------------------------
; 1. 版权和版本信息
;----------------------------------------------------------------

;----------------------------------------------------------------
; 2. 配置和初始化
;----------------------------------------------------------------
unless( boundp('g_var1) g_var1 = nil )
unless( boundp('g_var2) g_var2 = t )

;----------------------------------------------------------------
; 3. 别名定义（可选）
;----------------------------------------------------------------
alias(fset axlFormSetField)
alias(fget axlFormGetField)

;----------------------------------------------------------------
; 4. 常量定义
;----------------------------------------------------------------
define( MAX_ITEMS 100 )
define( DEFAULT_LAYER "ETCH/TOP" )

;----------------------------------------------------------------
; 5. 结构体定义（如果需要）
;----------------------------------------------------------------
(defstruct MyData name value type)

;----------------------------------------------------------------
; 6. 辅助函数（私有）
;----------------------------------------------------------------
defun( _helper1() ... )
defun( _helper2() ... )

;----------------------------------------------------------------
; 7. 主要函数（公开）
;----------------------------------------------------------------
defun( mainFunction1() ... )
defun( mainFunction2() ... )

;----------------------------------------------------------------
; 8. 回调函数
;----------------------------------------------------------------
defun( _callback1() ... )
defun( _callback2() ... )

;----------------------------------------------------------------
; 9. 测试函数
;----------------------------------------------------------------
defun( test_mainFunction1() ... )

;----------------------------------------------------------------
; 10. 命令注册
;----------------------------------------------------------------
axlCmdRegister("cmd1" 'mainFunction1)
```

### 14.2 使用分隔线

**分隔不同功能的代码块：**

```skill
;----------------------------------------------------------------
; 数据库操作函数
;----------------------------------------------------------------

;----------------------------------------------------------------
; 表单操作函数
;----------------------------------------------------------------

;----------------------------------------------------------------
; UI操作函数
;----------------------------------------------------------------

;----------------------------------------------------------------
; 测试函数
;----------------------------------------------------------------
```

**更细致的分隔：**

```skill
;--------------------------------------------------------------
;--------------------------------------------------------------
;--------------------------------------------------------------
; 主要部分
;--------------------------------------------------------------
;--------------------------------------------------------------
;--------------------------------------------------------------

;----------------------------------------------------------------
; 子部分
;----------------------------------------------------------------
```

### 14.3 公开和私有函数

**命名约定：**

```skill
; 公开函数（不带下划线）
defun( createSymbol() ... )
defun( deleteNet() ... )

; 私有函数（带下划线前缀）
defun( _validateInput() ... )
defun( _processData() ... )

; 回调函数（带Callback或CB后缀）
defun( _formCallback() ... )
defun( _popupCB() ... )
```

---

## 15. 最佳实践

### 15.1 代码一致性

**保持一致的编码风格：**

```skill
; 好的示例 - 一致的风格
defun( func1( a b )
    let( (result)
        result = a + b
        result
    )
)

defun( func2( x y )
    let( (result)
        result = x * y
        result
    )
)

; 避免的示例 - 不一致的风格
defun( func1( a b )
let( (result)
result = a + b
result
))

defun( func2( x y )
    let( (result)
        result = x * y;
return result;
    ))
```

### 15.2 代码可读性

**使用有意义的名称：**

```skill
; 好的示例
defun( calculateTraceWidth( current thickness ) ... )
let( (traceWidth layerName netName)
    ...
)

; 避免的示例
defun( calc( a b ) ... )
let( (a b c)
    ...
)
```

**添加适当的注释：**

```skill
; 好的示例
;; 计算走线宽度 based on IPC-2221 standard
;; 公式: W = (I / (k * (T^0.44))) ^ (1/0.725)
defun( calculateTraceWidth( current )
    let( (width)
        width = (current / (0.048 * (10^0.44))) ^ (1/0.725)
        width
    )
)

; 避免的示例
defun( calc( i )  ; 不清楚的公式
    let( (w)
        w = (i / (0.048 * (10^0.44))) ^ (1/0.725)
        w
    )
)
```

### 15.3 模块化设计

**将复杂功能分解为小函数：**

```skill
; 好的示例 - 模块化
defun( processDesign()
    let( (result)
        ; 步骤1：验证设计
        unless( validateDesign()
            return(nil)
        )
        
        ; 步骤2：处理网络
        processNets()
        
        ; 步骤3：处理器件
        processComponents()
        
        ; 步骤4：生成报告
        generateReport()
        
        t
    )
)

defun( validateDesign() ... )
defun( processNets() ... )
defun( processComponents() ... )
defun( generateReport() ... )

; 避免的示例 - 单一大函数
defun( processDesign()
    ; 500行代码...
)
```

### 15.4 错误处理

**适当处理可能的错误情况：**

```skill
defun( safeCreateSymbol( refdes location )
    prog( (result)
        ; 参数验证
        unless( refdes && stringp(refdes)
            axlMsgPut("**Error: Invalid refdes")
            return(nil)
        )
        
        unless( location && pairp(location)
            axlMsgPut("**Error: Invalid location")
            return(nil)
        )
        
        ; 执行操作
        errset(
            result = axlDBCreateSymbol(refdes, location)
        )
        
        ; 检查结果
        unless( result
            axlMsgPut("**Error: Failed to create symbol")
            return(nil)
        )
        
        ; 成功
        axlMsgPut("Symbol created successfully")
        result
    )
)
```

### 15.5 测试

**为关键功能编写测试函数：**

```skill
defun( test_calculateTraceWidth()
    printf("Testing calculateTraceWidth...\n")
    
    ; 测试用例1：正常情况
    result1 = calculateTraceWidth(2.5)
    printf("Test 1 (2.5A): %f mils\n" result1)
    
    ; 测试用例2：边界情况
    result2 = calculateTraceWidth(0)
    printf("Test 2 (0A): %f mils\n" result2)
    
    ; 测试用例3：异常情况
    result3 = calculateTraceWidth(-1)
    printf("Test 3 (-1A): %L\n" result3)
    
    ; 验证结果
    unless( result1 > 0
        axlMsgPut("**Error: Test 1 failed")
    )
)

; 运行测试
test_calculateTraceWidth()
```

---

## 16. 完整示例模板

### 16.1 完整函数模板

```skill
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; my_function.il --
;
; Author -- 您的名字
; Function -- 简要描述功能
; Date -- 2024-01-01
; Version -- 1.0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; myFunction - 详细功能描述
;;   参数：
;;     param1: 参数1说明
;;     param2: 参数2说明（可选）
;;   返回值：
;;     返回结果的说明
;;   示例：
;;     result = myFunction(1, 2)
;;
defun( myFunction( param1 param2 )
    let( (localVar1 localVar2 result)
        
        ;----------------------------------------------------------------
        ; 1. 参数验证
        ;----------------------------------------------------------------
        unless( param1
            error("param1 is required")
            return(nil)
        )
        
        unless( numberp(param1)
            error("param1 must be a number")
            return(nil)
        )
        
        ; 设置默认值
        unless( param2
            param2 = 10
        )
        
        ;----------------------------------------------------------------
        ; 2. 主要逻辑
        ;----------------------------------------------------------------
        localVar1 = param1 * 2
        localVar2 = param2 + 10
        
        ; 计算结果
        result = localVar1 + localVar2
        
        ;----------------------------------------------------------------
        ; 3. 返回结果
        ;----------------------------------------------------------------
        result
    )
)

;;
;; 测试函数
;;
defun( test_myFunction()
    printf("Testing myFunction...\n")
    
    ; 测试用例1
    result1 = myFunction(1, 2)
    printf("Test 1 result: %L\n" result1)
    
    ; 测试用例2
    result2 = myFunction(5, 10)
    printf("Test 2 result: %L\n" result2)
    
    ; 测试用例3：使用默认值
    result3 = myFunction(3)
    printf("Test 3 result (default): %L\n" result3)
)

;; 运行测试
; test_myFunction()
```

### 16.2 完整表单程序模板

```skill
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; my_form.il --
;
; Author -- 您的名字
; Function -- 表单程序示例
; Date -- 2024-01-01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;----------------------------------------------------------------
; 全局变量
;----------------------------------------------------------------
unless( boundp('g_myForm) g_myForm = nil )

;----------------------------------------------------------------
; 公开函数
;----------------------------------------------------------------
procedure( MyForm()
    g_myForm = IMyForm(g_myForm)
)

;----------------------------------------------------------------
; 表单创建函数
;----------------------------------------------------------------
procedure( IMyForm(fw)
    prog( (position)
        
        ; 好实践：如果表单已打开，暴露它并返回
        when( fw 
            axlUIWExpose(fw)
            return(fw)
        )
        
        ; 创建表单
        fw = axlFormCreate('g_myForm 
                          "myform.form" 
                          '("NE")
                          '_myFormCallback 
                          t 
                          nil)
        
        ; 设置表单标题
        axlFormTitle(fw "我的表单")
        
        ; 初始化表单字段
        IMyFormRefresh(fw)
        
        ; 显示表单
        axlFormDisplay(fw)
        
        return(fw)
    )
)

;----------------------------------------------------------------
; 表单刷新函数
;----------------------------------------------------------------
procedure( IMyFormRefresh(fw)
    let( ( )
        
        ; 设置默认值
        axlFormSetField(fw, "string_field", "default")
        axlFormSetField(fw, "int_field", 50)
        axlFormSetField(fw, "enum_field", "1")
        axlFormSetField(fw, "checkbox", t)
        
        ; 初始化列表
        axlFormSetField(fw, "listfield", 
            '("item1" "item2" "item3"))
    )
)

;----------------------------------------------------------------
; 表单回调函数
;----------------------------------------------------------------
defun( _myFormCallback(fw)
    prog( ( )
        
        ; 打印调试信息
        printf("Field: %L = %L\n" fw->curField fw->curValue)
        
        ; 根据字段名处理
        case( fw->curField
            
            ("button_ok"
                ; 保存数据
                IMyFormSave(fw)
                ; 关闭表单
                axlFormClose(fw)
            )
            
            ("button_cancel"
                ; 关闭表单
                axlFormClose(fw)
            )
            
            ("button_apply"
                ; 应用更改
                IMyFormSave(fw)
            )
        )
        
        ; 检查是否完成
        when( fw->doneState
            axlFormClose(fw)
        )
        
        return()
    )
)

;----------------------------------------------------------------
; 保存数据函数
;----------------------------------------------------------------
defun( IMyFormSave(fw)
    let( (stringVal intVal enumVal)
        
        ; 获取字段值
        stringVal = axlFormGetField(fw, "string_field")
        intVal = axlFormGetField(fw, "int_field")
        enumVal = axlFormGetField(fw, "enum_field")
        
        ; 验证数据
        unless( stringVal && intVal > 0
            axlMsgPut("**Error: Invalid data")
            return(nil)
        )
        
        ; 保存数据（示例）
        printf("Saving: %s, %d, %s\n" 
               stringVal intVal enumVal)
        
        ; 显示成功消息
        axlMsgPut("Data saved successfully")
        
        t
    )
)

;----------------------------------------------------------------
; 测试函数
;----------------------------------------------------------------
defun( test_MyForm()
    printf("Opening form...\n")
    MyForm()
)

;; 运行测试
; test_MyForm()
```

### 16.3 完整命令程序模板

```skill
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; my_command.il --
;
; Author -- 您的名字
; Function -- 交互式命令示例
; Date -- 2024-01-01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;----------------------------------------------------------------
; 全局变量
;----------------------------------------------------------------
unless( boundp('g_selectedObjects) g_selectedObjects = nil )

;----------------------------------------------------------------
; 命令注册
;----------------------------------------------------------------
axlCmdRegister("mycmd" 'MyCommand ?cmdType "interactive")

;----------------------------------------------------------------
; 主命令函数
;----------------------------------------------------------------
defun( MyCommand()
    let( (myPopup result)
        
        ; 定义弹出菜单
        myPopup = axlUIPopupDefine(nil, 
            list(
                list("Done" 'axlFinishEnterFun)
                list("Cancel" 'axlCancelEnterFun)
                list(separator)
                list("Options" 'MyCommandOptions)
            ))
        
        ; 设置弹出菜单
        axlUIPopupSet(myPopup)
        
        ; 设置查找过滤器
        axlSetFindFilter(?enabled, '("NOALL", "ALLTYPES")
                         ?onButtons "ALLTYPES")
        
        ; 开始选择循环
        g_selectedObjects = nil
        while(axlSelect(), 
            objects = axlGetSelSet()
            g_selectedObjects = append(g_selectedObjects, objects)
            
            ; 处理选中的对象
            foreach( obj objects
                MyCommandProcess(obj)
            )
        )
        
        ; 显示结果
        printf("Selected %d objects\n" length(g_selectedObjects))
        
        ; 后处理
        MyCommandPostProcess()
        
        t
    )
)

;----------------------------------------------------------------
; 处理对象函数
;----------------------------------------------------------------
defun( MyCommandProcess(obj)
    prog( ( )
        
        ; 根据对象类型处理
        case( obj->objType
            
            ("net"
                printf("Processing net: %s\n" obj->name)
                ; 处理网络
            )
            
            ("pin"
                printf("Processing pin: %s\n" obj->pinName)
                ; 处理引脚
            )
            
            (t
                printf("Unknown object type: %s\n" obj->objType)
            )
        )
        
        return()
    )
)

;----------------------------------------------------------------
; 后处理函数
;----------------------------------------------------------------
defun( MyCommandPostProcess()
    prog( ( )
        
        unless( g_selectedObjects
            axlMsgPut("No objects selected")
            return()
        )
        
        ; 生成报告
        printf("=== Report ===\n")
        foreach( obj g_selectedObjects
            printf("  %s: %s\n" obj->objType obj->name)
        )
        
        axlMsgPut(sprintf(nil "Processed %d objects" 
                         length(g_selectedObjects)))
        
        return()
    )
)

;----------------------------------------------------------------
; 选项回调函数
;----------------------------------------------------------------
defun( MyCommandOptions()
    printf("Options called\n")
    ; 显示选项对话框
)
```

---

## 17. 参考资源

- **Cadence Allegro Skill 文档**：`D:\Cadence\SPB_24.1\doc\algroskill`
- **示例代码**：`D:\Cadence\SPB_24.1\share\pcb\examples\skill`
  - `dbcreate\` - 数据库创建示例
  - `form\` - 表单编程示例
  - `ui\` - UI编程示例
  - `select\` - 选择操作示例
  - `cmds\` - 命令编程示例
- **Cadence 官方文档和培训材料**

---

## 18. 总结

这份详细代码规范基于 Cadence Allegro Skill 官方示例代码编写，涵盖了：

1. **文件结构** - 标准文件头、命名规范、组织顺序
2. **代码格式** - 缩进、空格、换行规则
3. **命名规范** - 函数、变量、常量命名规则
4. **注释规范** - 注释风格、内容要求
5. **函数定义** - defun/procedure 使用、参数处理、返回值
6. **变量作用域** - 全局/局部变量管理
7. **错误处理** - errset、when/unless、error/warn 使用
8. **表单编程** - 创建、回调、字段操作
9. **数据库操作** - 创建、查询、修改
10. **UI和菜单** - 命令注册、弹出菜单、菜单编辑
11. **选择操作** - 交互式/程序化选择、查找过滤器
12. **调试和日志** - printf、axlMsgPut、pprint 使用
13. **性能优化** - 列表操作、避免重复计算
14. **代码组织** - 文件结构、分隔线使用
15. **最佳实践** - 一致性、可读性、模块化、测试
16. **完整示例** - 函数、表单、命令程序模板

遵循这些规范可以编写出高质量、可维护的 Cadence Allegro Skill 代码。

---

*本规范基于 Cadence Allegro Skill 17.4 和 24.1 版本示例代码编写*
*最后更新：2024年*
