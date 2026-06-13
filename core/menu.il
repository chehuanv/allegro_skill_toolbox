;; ============================================================
;; File: core/menu.il
;; Purpose: Menu manager - build and register Allegro menu
;; Encoding: GBK (Simplified Chinese)
;; Note: Save this file in GBK encoding, do NOT use UTF-8
;; ============================================================

/*
#########################################################################################
#  Menu Manager - Build and inject Allegro menu for allegro_skill_toolbox                 #
#########################################################################################
*/

;;=========================================================================
;; Menu structure definition (flat list with popup/end/separator markers)
;; Each command item: (englishLabel chineseLabel commandName)
;; Each popup item:   (popup englishLabel chineseLabel)
;;=========================================================================
procedure( ASTB_GetMenuStructure()
  list(
    '(popup "allegro_skill_toolbox" "allegro_skill_toolbox")
    '(popup "Package" "封装")
    '("Change Origin" "封装原点" "ASTB_Pkg_ChangeOrigin")
    '("Optimize Pads" "优化焊盘" "ASTB_Pkg_OptimizePads")
    '("Add Keepout" "添加禁止区域" "ASTB_Pkg_AddKeepout")
    '("Rename Pins" "重命名管脚" "ASTB_Pkg_RenamePins")
    '("Create Oval Flash" "创建椭圆形Flash" "ASTB_Pkg_CreateOvalFlash")
    '("Export Footprint" "导出封装" "ASTB_Pkg_ExportFootprint")
    '("Create Device File" "创建器件文件" "ASTB_Pkg_CreateDevFile")
    '(end)
    '(separator)
    '(popup "Layout" "布局")
    '("Place by Page" "按页摆放" "ASTB_Layout_PlaceByPage")
    '("Gather Components" "收拢器件" "ASTB_Layout_GatherComps")
    '("Place One by One" "逐个摆放" "ASTB_Layout_PlaceOneByOne")
    '("Mirror Group" "镜像群组" "ASTB_Layout_MirrorGroup")
    '("Align" "对齐" "ASTB_Layout_Align")
    '("Copy with Spacing" "带间距复制" "ASTB_Layout_CopyWithSpacing")
    '("Set Grid" "设置栅格" "ASTB_Layout_SetGrid")
    '("Auto Place" "自动摆放" "ASTB_Layout_AutoPlace")
    '(end)
    '(separator)
    '(popup "Router" "布线")
    '("Cut Line/Shape" "切割线/铜皮" "ASTB_Router_CutLineShape")
    '("Change Via Net" "修改过孔网络" "ASTB_Router_ChangeViaNet")
    '("Diff Via Keepout" "差分过孔禁布区" "ASTB_Router_DiffViaKeepout")
    '("Change Line Width" "修改线宽" "ASTB_Router_ChangeLineWidth")
    '("Tune Diff Pair" "差分对绕线" "ASTB_Router_TuneDiff")
    '("Pad Relief" "焊盘反焊盘" "ASTB_Router_PadRelief")
    '("RF Copper Cut" "RF 铜皮切割" "ASTB_Router_RfCopperCut")
    '("Line to Shape" "线转铜皮" "ASTB_Router_LineToShape")
    '("Swap Pins" "交换管脚" "ASTB_Router_SwapPin")
    '("Replace Via" "替换过孔" "ASTB_Router_ReplaceVia")
    '("Create Match Group" "创建等长组" "ASTB_Router_CreateMatchGroup")
    '("Check Cross Split" "检查跨分割" "ASTB_Router_CheckSplit")
    '("Via Stitching" "过孔缝合" "ASTB_Router_ViaStitching")
    '(end)
    '(separator)
    '(popup "Text/Silk" "文字/丝印")
    '("Set Text Attr" "设置文字属性" "ASTB_Text_SetTextAttr")
    '("Add Chinese" "添加中文" "ASTB_Text_AddChinese")
    '("Import Logo" "导入 Logo" "ASTB_Text_ImportLogo")
    '("Adjust RefDes" "调整位号" "ASTB_Text_AdjustRefDes")
    '("Add Net Name" "添加网络名" "ASTB_Text_AddNetName")
    '("Complete RefDes" "补全位号" "ASTB_Text_CompleteRefDes")
    '("Check Ref Orient" "检查位号方向" "ASTB_Text_CheckRefOrient")
    '(end)
    '(separator)
    '(popup "Manufacturing" "制造")
    '("Import Stackup" "导入叠层" "ASTB_Mfg_ImportStackup")
    '("DFM Check" "DFM 检查" "ASTB_Mfg_DFMCheck")
    '("Export Gerber" "导出 Gerber" "ASTB_Mfg_ExportGerber")
    '("Export PDF" "导出 PDF" "ASTB_Mfg_ExportPDF")
    '("Export DXF/3D" "导出 DXF/3D" "ASTB_Mfg_ExportDXF3D")
    '("Export Coords" "导出坐标" "ASTB_Mfg_ExportCoords")
    '("Panelize" "拼板" "ASTB_Mfg_Panelize")
    '("Impedance Calc" "阻抗计算" "ASTB_Mfg_ImpedanceCalc")
    '("Highlight Path" "高亮路径" "ASTB_Mfg_HighlightPath")
    '(end)
    '(separator)
    '(popup "Utilities" "工具")
    '("Unit Convert" "单位换算" "ASTB_Util_UnitConvert")
    '("Set Lib Path" "设置库路径" "ASTB_Util_SetLibPath")
    '("Color Scheme" "配色方案" "ASTB_Util_ColorScheme")
    '("Current Calc" "电流计算" "ASTB_Util_CurrentCalc")
    '("Set Shortcut" "设置快捷键" "ASTB_Util_SetShortcut")
    '("Color Power Nets" "电源网络上色" "ASTB_Util_ColorPowerNets")
    '("Swap Layers" "交换层" "ASTB_Util_SwapLayers")
    '(end)
    '(separator)
    '(popup "System" "系统")
    '("About" "关于" "ASTB_About")
    '("Reload" "重新加载" "ASTB_Reload")
    '(separator)
    '(popup "Language" "语言")
    '("English" "英文" "ASTB_SetLanguageEnglish")
    '("Chinese" "中文" "ASTB_SetLanguageChinese")
    '(end)
    '(end)
    '(end)
  )
)

;;=========================================================================
;; Determine if current language is English
;;=========================================================================
procedure( ASTB_IsLanguageEnglish()
  prog((lang)
    lang = ASTB_GetConfig("language" "zh")
    when( null(lang)  lang = "zh" )
    return( lang == "en" || lang == "en-US" || lang == "english" )
  )
)

;;=========================================================================
;; Item type predicates
;;=========================================================================
procedure( ASTB_MenuIsPopup(item)
  listp(item) && car(item) == 'popup
)

procedure( ASTB_MenuIsEnd(item)
  listp(item) && car(item) == 'end
)

procedure( ASTB_MenuIsSeparator(item)
  listp(item) && car(item) == 'separator
)

procedure( ASTB_MenuIsCommand(item)
  and(listp(item) length(item) >= 3 stringp(car(item)) stringp(cadr(item)) stringp(caddr(item)))
)

;;=========================================================================
;; Get display label for current language
;;=========================================================================
procedure( ASTB_MenuGetPopupLabel(item)
  if( ASTB_IsLanguageEnglish() then cadr(item) else caddr(item) )
)

procedure( ASTB_MenuGetCommandLabel(item)
  if( ASTB_IsLanguageEnglish() then car(item) else cadr(item) )
)

procedure( ASTB_MenuGetCommand(item)
  caddr(item)
)

;;=========================================================================
;; Extract all command names from menu structure
;;=========================================================================
procedure( ASTB_GetMenuCommands(menuList)
  prog((result item)
    result = nil
    foreach( item menuList
      when( ASTB_MenuIsCommand(item)
        result = cons(ASTB_MenuGetCommand(item) result)
      )
    )
    result
  )
)

;;=========================================================================
;; Track whether menu has been injected in this session
;;=========================================================================
when( boundp('ASTB_MENU_INJECTED)
  ASTB_MENU_INJECTED = nil
)
defvar(ASTB_MENU_INJECTED nil)

;;=========================================================================
;; Store menu item IDs for language switching
;;=========================================================================
when( boundp('ASTB_MENU_IDS)
  ASTB_MENU_IDS = makeTable('ASTB_MENU_IDS)
)
defvar(ASTB_MENU_IDS makeTable('ASTB_MENU_IDS))

;;=========================================================================
;; Check if our menu is already injected
;;=========================================================================
procedure( ASTB_MenuAlreadyInjected()
  prog((tmpFile port line found ret)
    when( ASTB_MENU_INJECTED
      return(t)
    )
    found = nil
    ret = errset(
      prog(()
        tmpFile = axlTempFile()
        when( tmpFile
          axlUIMenuDump(tmpFile)
          port = infile(tmpFile)
          when( port
            while( gets(line port)
              when( rexMatchp("allegro_skill_toolbox" line)
                found = t
              )
            )
            close(port)
          )
          deleteFile(tmpFile)
        )
      )
      t
    )
    unless( ret
      ASTB_DebugLog("ASTB_MenuAlreadyInjected: error")
      return(nil)
    )
    found
  )
)

;;=========================================================================
;; Inject menu into Allegro menu bar using axlUIMenuInsert
;;=========================================================================
procedure( ASTB_InjectMenu()
  prog((menuList stack parentId item ret label cmd subId firstPopup enKey)
    when( ASTB_MenuAlreadyInjected()
      ASTB_LogInfo("Menu already injected, skipping.")
      return(t)
    )
    
    menuList = ASTB_GetMenuStructure()
    when( null(menuList)
      ASTB_LogError("Menu structure is empty")
      return(nil)
    )
    
    ;; First item must be the top-level popup
    firstPopup = car(menuList)
    unless( ASTB_MenuIsPopup(firstPopup)
      ASTB_LogError("Invalid top-level menu structure")
      return(nil)
    )
    
    ;; Insert top-level popup before the last menu (Help)
    parentId = axlUIMenuFind(nil -1)
    ASTB_DebugLog(strcat("ASTB_InjectMenu: helpMenuId = " sprintf(nil "%L" parentId)))
    label = ASTB_MenuGetPopupLabel(firstPopup)
    enKey = cadr(firstPopup)
    ret = errset(parentId = axlUIMenuInsert(parentId 'popup label) t)
    unless( ret
      ASTB_LogError("Failed to create top-level popup")
      return(nil)
    )
    parentId = car(ret)
    ASTB_MENU_IDS[enKey] = parentId
    ASTB_DebugLog(strcat("ASTB_InjectMenu: topPopupId = " sprintf(nil "%L" parentId)))
    stack = list(parentId)
    
    ;; Process remaining items
    foreach( item cdr(menuList)
      when( listp(item)
        cond(
          ;; Sub-popup
          ( ASTB_MenuIsPopup(item)
            label = ASTB_MenuGetPopupLabel(item)
            enKey = cadr(item)
            ASTB_DebugLog(strcat("ASTB_InjectMenu: creating popup " label " under id " sprintf(nil "%L" parentId)))
            ret = errset(subId = axlUIMenuInsert(parentId 'popup label) t)
            when( ret
              stack = cons(car(ret) stack)
              parentId = car(ret)
              ASTB_MENU_IDS[enKey] = parentId
            )
          )
          ;; End of current popup
          ( ASTB_MenuIsEnd(item)
            ASTB_DebugLog("ASTB_InjectMenu: closing popup")
            stack = cdr(stack)
            parentId = car(stack)
          )
          ;; Separator
          ( ASTB_MenuIsSeparator(item)
            ASTB_DebugLog("ASTB_InjectMenu: adding separator")
            errset(axlUIMenuInsert(parentId 'separator "") t)
          )
          ;; Command item
          ( ASTB_MenuIsCommand(item)
            label = ASTB_MenuGetCommandLabel(item)
            cmd = ASTB_MenuGetCommand(item)
            ASTB_DebugLog(strcat("ASTB_InjectMenu: adding item " label " -> " cmd))
            ret = errset(subId = axlUIMenuInsert(parentId label cmd) t)
            when( ret
              ASTB_MENU_IDS[cmd] = car(ret)
            )
          )
        )
      )
    )
    
    ASTB_MENU_INJECTED = t
    ASTB_LogInfo("Menu injected successfully.")
    return(t)
  )
)

;;=========================================================================
;; Apply current language to already injected menu
;;=========================================================================
procedure( ASTB_ApplyMenuLanguage()
  prog((menuList item id label enKey cmd ret changed failed)
    changed = 0
    failed = 0
    menuList = ASTB_GetMenuStructure()
    foreach( item menuList
      when( ASTB_MenuIsPopup(item)
        enKey = cadr(item)
        label = ASTB_MenuGetPopupLabel(item)
        id = ASTB_MENU_IDS[enKey]
        unless( id
          ASTB_DebugLog(strcat("ASTB_ApplyMenuLanguage: popup ID not found for " enKey))
          failed = failed + 1
        )
        when( id
          ret = errset(axlUIMenuChange(id 'display label) t)
          if( ret
          then
            changed = changed + 1
          else
            ASTB_DebugLog(strcat("ASTB_ApplyMenuLanguage: failed to change popup " enKey " to " label))
            failed = failed + 1
          )
        )
      )
      when( ASTB_MenuIsCommand(item)
        cmd = ASTB_MenuGetCommand(item)
        label = ASTB_MenuGetCommandLabel(item)
        id = ASTB_MENU_IDS[cmd]
        unless( id
          ASTB_DebugLog(strcat("ASTB_ApplyMenuLanguage: command ID not found for " cmd))
          failed = failed + 1
        )
        when( id
          ret = errset(axlUIMenuChange(id 'display label) t)
          if( ret
          then
            changed = changed + 1
          else
            ASTB_DebugLog(strcat("ASTB_ApplyMenuLanguage: failed to change command " cmd " to " label))
            failed = failed + 1
          )
        )
      )
    )
    ;; Force UI refresh after changing labels
    errset(axlUIWUpdate(nil) t)
    ASTB_LogInfo(sprintf(nil "Menu language applied: %s (changed=%d failed=%d)" if(ASTB_IsLanguageEnglish() then "en" else "zh") changed failed))
  )
)

;;=========================================================================
;; Set menu language and update displayed labels
;;=========================================================================
procedure( ASTB_SetLanguage(lang)
  prog((oldLang)
    oldLang = ASTB_GetConfig("language" "zh")
    when( oldLang == lang
      return(t)
    )
    ASTB_SetConfig("language" lang)
    ASTB_SaveConfig()
    ASTB_ApplyMenuLanguage()
    axlUIConfirm(sprintf(nil "Language switched to %s" lang))
    return(t)
  )
)

procedure( ASTB_SetLanguageEnglish()
  ASTB_SetLanguage("en")
)

procedure( ASTB_SetLanguageChinese()
  ASTB_SetLanguage("zh-CN")
)

;;=========================================================================
;; Delayed menu injection - retry until Allegro menu system is ready
;;=========================================================================
procedure( ASTB_DelayedMenuInjection(@optional window timerId elapsedTime)
  prog((tid ret)
    errset(
      prog(()
        ASTB_DebugLog("ASTB_DelayedMenuInjection: start")
        when( ASTB_MenuAlreadyInjected()
          ASTB_DebugLog("ASTB_DelayedMenuInjection: already injected")
          return(t)
        )
        when( ASTB_InjectMenu()
          ASTB_DebugLog("ASTB_DelayedMenuInjection: injected")
          return(t)
        )
        ;; Limit retries to avoid infinite loops in headless environments
        unless( boundp('ASTB_MENU_RETRY_COUNT)
          defvar(ASTB_MENU_RETRY_COUNT 0)
        )
        ASTB_MENU_RETRY_COUNT = ASTB_MENU_RETRY_COUNT + 1
        when( ASTB_MENU_RETRY_COUNT > 20
          ASTB_LogWarn("Menu injection retries exceeded, giving up.")
          return(nil)
        )
        tid = axlUIWTimerAdd(nil 2000 nil 'ASTB_DelayedMenuInjection)
        ASTB_DebugLog("ASTB_DelayedMenuInjection: rescheduled")
        t
      )
      t
    )
    ASTB_DebugLog("ASTB_DelayedMenuInjection: safe-exit")
    t
  )
)

;;=========================================================================
;; Register all commands found in menu structure
;;=========================================================================
procedure( ASTB_RegisterAllMenuCommands()
  prog((menuList item cmd count)
    menuList = ASTB_GetMenuStructure()
    count = 0
    foreach( item menuList
      when( ASTB_MenuIsCommand(item)
        cmd = ASTB_MenuGetCommand(item)
        ASTB_DebugLog(strcat("ASTB_RegisterAllMenuCommands: registering " cmd))
        ASTB_RegisterCommand(cmd cmd ?cmdType "interactive")
        count = count + 1
      )
    )
    ASTB_LogInfo(sprintf(nil "Registered %d menu commands" count))
  )
)

printf("[ASTB] core/menu.il loaded.\n")
