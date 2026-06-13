# Cadence Allegro Skill 代码规范

## 1. 文件结构规范

### 1.1 文件头注释
每个Skill文件应以标准文件头开始，包含版权信息、作者、功能描述等：

```skill
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; filename.il --
;
; Author --
;    您的名字
;
; Function --
;    简要描述文件的功能
;
; Copyright, 2024, 公司名称
; 版权声明（根据项目需求调整）
;
; 其他说明（可选）
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
```

### 1.2 文件命名
- 使用小写字母和下划线组合，如：`my_function.il`
- 文件名应具有描述性，反映文件内容
- 扩展名使用 `.il` (Skill代码) 或 `.form` (表单定义)

---

## 2. 代码格式规范

### 2.1 缩进与对齐
- 使用空格或Tab进行缩进（推荐2或4个空格）
- 括号应对齐，保持代码结构清晰

```skill
; 好的示例
procedure( myFunction( param1 param2 )
    let( (localVar1 localVar2)
        localVar1 = param1 + param2
        when( localVar1 > 0
            printf("Value: %d\n" localVar1)
        )
    )
)

; 避免的格式
procedure( myFunction( param1 param2 )
let( (localVar1 localVar2)
localVar1 = param1 + param2
when( localVar1 > 0
printf("Value: %d\n" localVar1)
)
)
)
```

### 2.2 空格使用
- 操作符前后加空格：`a = b + c`
- 逗号后加空格：`function(a, b, c)`
- 函数名与括号之间不加空格：`myFunc(param)`

---

## 3. 命名规范

### 3.1 函数命名
- **自定义函数**：使用小写字母和下划线，具有描述性
  ```skill
  defun( calculate_trace_width()
  defun( create_component_symbol()
  procedure( validate_design_rules()
  ```

- **测试函数**：使用 `test_` 或 `te_` 前缀
  ```skill
  defun( test_create_symbol()
  defun( te_args_validation()
  ```

- **回调函数**：使用描述性名称，通常以 `_callback` 或 `CB` 结尾
  ```skill
  procedure( _afCallback(fw)
  defun( myFormCallback(theForm)
  ```

### 3.2 变量命名
- **局部变量**：使用驼峰命名或小写加下划线
  ```skill
  let( (myVariable localCount indexValue)
  ```

- **全局变量**：使用描述性名称，避免过于简短
  ```skill
  globalVar = nil      ; 避免
  g_formHandle = nil   ; 推荐：有明确含义
  ```

- **Cadence API函数**：以 `axl` 前缀开头
  ```skill
  axlDBCreateSymbol()
  axlMsgPut()
  axlFormCreate()
  ```

### 3.3 常量命名
- 使用大写字母和下划线
  ```skill
  define( MAX_WIDTH 100 )
  define( DEFAULT_LAYER "ETCH/TOP" )
  ```

---

## 4. 注释规范

### 4.1 注释风格
- 使用分号 `;` 进行注释
- 单行注释：一个分号
  ```skill
  ; 这是单行注释
  axlMsgPut("Hello")  ; 行尾注释
  ```

- 函数说明：使用两个或多个分号
  ```skill
  ;;
  ;; myFunction - 函数功能描述
  ;;   参数说明
  ;;   返回值说明
  ;;
  defun( myFunction( param1 )
  ```

- 分隔线：使用多个分号
  ```skill
  ;----------------------------------------------------------------
  ; 主要部分标题
  ;----------------------------------------------------------------
  ```

### 4.2 注释内容
- 函数应注释功能、参数、返回值
- 复杂逻辑应有行内注释
- 临时或待完成的代码使用 `TODO` 标记
  ```skill
  ; TODO: 需要添加错误处理
  ; FIXME: 此函数在边界情况下可能失败
  ```

---

## 5. 函数定义规范

### 5.1 使用 `defun` 或 `procedure`
- `defun`：用于定义全局函数
  ```skill
  defun( myGlobalFunc( param1 param2 )
      ; 函数体
  )
  ```

- `procedure`：用于定义函数，支持词法作用域
  ```skill
  procedure( myFunc( param1 )
      ; 函数体
  )
  ```

### 5.2 函数体结构
- 使用 `let` 绑定局部变量
- 使用 `prog` 进行程序块控制（需要return时）
  ```skill
  procedure( myFunc( param )
      let( (localVar result)
          localVar = param * 2
          result = localVar + 10
          result  ; 返回值
      )
  )
  ```

### 5.3 返回值
- 函数最后一个表达式的值为返回值
- 使用 `return` 提前返回
  ```skill
  defun( checkValue( x )
      when( x < 0
          return(nil)  ; 提前返回
      )
      x * 2  ; 正常返回值
  )
  ```

---

## 6. 错误处理规范

### 6.1 使用 `errset`
- 包裹可能出错的代码
  ```skill
  errset(
      result = axlDBCreatePath(path, layer, net)
  )
  ```

### 6.2 使用 `when` 和 `unless`
- 条件判断，避免嵌套过深
  ```skill
  ; 好的示例
  when( fileHandle
      close(fileHandle)
  )
  
  unless( validData
      error("Invalid data")
      return(nil)
  )
  
  ; 避免的示例
  if( fileHandle != nil then
      close(fileHandle)
  )
  ```

---

## 7. 表单编程规范

### 7.1 表单创建
- 使用 `axlFormCreate` 创建表单
- 指定回调函数处理表单事件
  ```skill
  procedure( MyForm( fw )
      ; 如果表单已打开，暴露它并返回
      when( fw
          axlUIWExpose(fw)
          return(fw)
      )
      
      ; 创建表单
      fw = axlFormCreate('fwHandle "myform.form" 
                         '("NE") '_myFormCallback t nil)
      
      ; 设置表单标题
      axlFormTitle(fw "我的表单")
      
      ; 显示表单
      axlFormDisplay(fw)
      fw
  )
  ```

### 7.2 回调函数结构
- 处理不同字段的事件
  ```skill
  defun( _myFormCallback( fw )
      ; 处理鼠标活动帮助
      when( fw->mouseActive
          axlFormSetField(fw "active_help" 
                          sprintf(nil "Help for %s" fw->curField))
          return(t)
      )
      
      ; 打印调试信息
      printf("Field: %L = %L\n" fw->curField fw->curValue)
      
      ; 根据字段名处理
      case( fw->curField
      ("button_ok"
          ; 处理OK按钮
          saveData(fw)
          axlFormClose(fw)
      )
      ("button_cancel"
          ; 处理Cancel按钮
          axlFormClose(fw)
      )
      )
      
      ; 检查是否完成
      when( fw->doneState
          axlFormClose(fw)
      )
  )
  ```

---

## 8. 数据库操作规范

### 8.1 创建数据库对象
- 使用 `axlDBCreate*` 系列函数
  ```skill
  ; 创建Symbol
  axlDBCreateSymbol("R1" 0.7:6.3)
  
  ; 创建Path
  axlDBCreatePath(
      axlPathStart(list(0:0 10:0) 0.2)
      "ETCH/TOP"
      "net1"
  )
  ```

### 8.2 查询数据库
- 使用 `axlDBGet*` 系列函数
  ```skill
  ; 获取选中的对象
  objects = axlGetSelSet()
  
  ; 遍历对象
  foreach( obj objects
      printf("Object: %L\n" obj)
  )
  ```

---

## 9. 菜单和UI规范

### 9.1 菜单注册
- 使用 `axlCmdRegister` 注册命令
  ```skill
  axlCmdRegister("mycmd" 'MyCommand ?cmdType "interactive")
  ```

### 9.2 弹出菜单
- 使用 `axlUIPopupDefine` 定义右键菜单
  ```skill
  defun( MyCommand()
      myPopup = axlUIPopupDefine(nil 
                  list(list("Done" 'axlFinishEnterFun)
                       list("Cancel" 'axlCancelEnterFun)))
      axlUIPopupSet(myPopup)
      ; 开始交互式选择
      while(axlSelect(), 
          processSelection(axlGetSelSet())
      )
  )
  ```

---

## 10. 调试和日志规范

### 10.1 使用 `printf` 和 `println`
- 输出调试信息
  ```skill
  printf("Debug: value = %L\n" myVar)
  println("Reached this point")
  ```

### 10.2 使用 `axlMsgPut`
- 在Allegro消息区显示信息
  ```skill
  axlMsgPut("操作完成")
  axlMsgPut("**错误：无效的参数")
  ```

### 10.3 使用 `pprint`
- 打印复杂数据结构
  ```skill
  pprint(myList)
  pprint(axlFormGetField(fw "fieldName"))
  ```

---

## 11. 性能优化建议

### 11.1 列表操作
- 对于大量数据，一次性设置而非多次调用
  ```skill
  ; 好的方式：一次性设置列表
  axlFormSetField(fw "listfield" largeList)
  
  ; 避免的方式：多次调用
  foreach( item largeList
      axlFormSetField(fw "listfield" item)
  )
  ```

### 11.2 避免重复计算
- 缓存重复使用的计算结果
  ```skill
  ; 好的方式
  layer = "ETCH/TOP"
  axlDBCreatePath(path1, layer, net)
  axlDBCreatePath(path2, layer, net)
  
  ; 避免的方式
  axlDBCreatePath(path1, "ETCH/TOP", net)
  axlDBCreatePath(path2, "ETCH/TOP", net)
  ```

---

## 12. 代码组织建议

### 12.1 文件组织
- 相关函数放在同一个文件中
- 使用分隔线分隔不同功能的代码块
- 公开函数放在前面，辅助函数放在后面

### 12.2 初始化代码
- 使用 `unless(boundp(...))` 避免重复初始化
  ```skill
  unless( boundp('g_myGlobalVar)
      g_myGlobalVar = nil
      g_myGlobalVar2 = t
  )
  ```

### 12.3 别名定义
- 为常用函数定义别名（可选）
  ```skill
  alias( fset axlFormSetField )
  alias( fget axlFormGetField )
  alias( fdelete axlFormListDeleteAll )
  ```

---

## 13. 最佳实践总结

1. **一致性**：保持代码风格一致
2. **可读性**：使用有意义的名称，添加适当注释
3. **模块化**：将复杂功能分解为小函数
4. **错误处理**：适当处理可能的错误情况
5. **性能**：注意性能优化，避免不必要的计算
6. **测试**：为关键功能编写测试函数
7. **文档**：为复杂的逻辑添加详细注释

---

## 14. 示例模板

### 14.1 完整函数模板
```skill
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; my_function.il --
;
; Author -- 您的名字
; Function -- 简要描述功能
; Date -- 2024-01-01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; myFunction - 详细功能描述
;;   参数：
;;     param1: 参数1说明
;;     param2: 参数2说明
;;   返回值：
;;     返回结果的说明
;;
defun( myFunction( param1 param2 )
    let( (localVar1 localVar2 result)
        
        ; 参数验证
        unless( param1 && param2
            error("Invalid parameters")
            return(nil)
        )
        
        ; 主要逻辑
        localVar1 = param1 * 2
        localVar2 = param2 + 10
        
        ; 计算结果
        result = localVar1 + localVar2
        
        ; 返回结果
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
)
```

---

## 15. 参考资源

- Cadence Allegro Skill 文档：`D:\Cadence\SPB_24.1\doc\algroskill`
- 示例代码：`D:\Cadence\SPB_24.1\share\pcb\examples\skill`
- Cadence 官方文档和培训材料

---

*本规范基于 Cadence Allegro Skill 示例代码和最佳实践编写*
