;; ============================================================
;; File: main.il
;; Purpose: allegro_skill_toolbox main entry file
;; Encoding: GBK (Simplified Chinese)
;; Note: Save this file in GBK encoding, do NOT use UTF-8
;; ============================================================

/*
#########################################################################################
#  allegro_skill_toolbox - Main Framework                                                 #
#  Architecture: auto-discovery | modular loader | config-driven menu                     #
#########################################################################################
#
#  IMPORTANT: This file is safe to load from allegro.ilinit. It only defines
#  procedures and registers the ASTB_Init command. All AXL-dependent
#  initialization happens when ASTB_Init is called manually or by a timer.
#########################################################################################
*/

;;=========================================================================
;; Local helper: find last occurrence of a character in a string
;; Returns 1-based index or nil
;;=========================================================================
procedure( ASTB_LastIndexOf(str ch)
  prog((len i)
    len = strlen(str)
    i = len
    while( i >= 1
      when( substring(str i i) == ch
        return(i)
      )
      i = i - 1
    )
    return(nil)
  )
)

;;=========================================================================
;; Diagnostic logging - writes to file so we can see progress after crash
;;=========================================================================
procedure( ASTB_DebugLog(msg)
  prog((port path)
    errset(
      prog(()
        path = "D:/Cadence/MFLXskill/astb_debug.log"
        port = outfile(path "a")
        when( port
          fprintf(port "ASTB %s\n" msg)
          close(port)
        )
      )
      t
    )
    nil
  )
)

;;=========================================================================
;; 1. Global Environment & Path Discovery
;;=========================================================================
procedure( ASTB_InitEnv()
  prog((installPath paths p found mainFile pos pos2 tbPath)
    ASTB_DebugLog("ASTB_InitEnv: start")
    unless( boundp('ASTB_GLOBAL)
      defvar(ASTB_GLOBAL ncons(nil))
    )
    
    found = nil
    
    ;; Priority 1: path passed from allegro.ilinit via ASTB_INSTALL_DIR
    if( and(boundp('ASTB_INSTALL_DIR) ASTB_INSTALL_DIR)
    then
      installPath = ASTB_INSTALL_DIR
      ASTB_DebugLog(strcat("ASTB_InitEnv: ASTB_INSTALL_DIR = " installPath))
      when( isFile(strcat(installPath "/allegro_skill_toolbox/main.il"))
        found = t
      )
    )
    
    ;; Priority 2: derive path from current file being loaded (main.il)
    unless( found
      errset(
        prog(()
          mainFile = simplifyFilename(get_filename(piport))
          ASTB_DebugLog(strcat("ASTB_InitEnv: mainFile = " mainFile))
          when( mainFile
            pos = ASTB_LastIndexOf(mainFile "/")
            when( pos > 0
              tbPath = substring(mainFile 1 pos - 1)
              when( isFile(strcat(tbPath "/main.il"))
                ASTB_GLOBAL->ToolboxPath = tbPath
                pos2 = ASTB_LastIndexOf(tbPath "/")
                when( pos2 > 0
                  installPath = substring(tbPath 1 pos2 - 1)
                  found = t
                )
              )
            )
          )
        )
        t
      )
    )
    
    ;; Priority 3: find path that contains allegro_skill_toolbox/main.il
    unless( found
      paths = getSkillPath()
      foreach( p paths
        when( isFile(strcat(p "/allegro_skill_toolbox/main.il"))
          installPath = p
          found = t
        )
      )
    )
    
    ;; Priority 4: check current working directory
    unless( found
      p = getWorkingDir()
      when( isFile(strcat(p "/allegro_skill_toolbox/main.il"))
        installPath = p
        found = t
      )
    )
    
    ;; If still not found, abort with clear message
    unless( found
      printf("[ASTB][ERROR] 无法定位 allegro_skill_toolbox 安装目录。\n")
      printf("[ASTB][ERROR] 解决方法\n")
      printf("[ASTB][ERROR] 1. 设置 ASTB_INSTALL_DIR 后重新加载；\n")
      printf("[ASTB][ERROR] 2. 或将安装目录加入 SKILL 搜索路径。\n")
      printf("[ASTB][ERROR] 示例：ASTB_INSTALL_DIR = \"D:/Cadence/MFLXskill\"\n")
      error("Cannot locate allegro_skill_toolbox installation directory")
    )
    
    ASTB_DebugLog(strcat("ASTB_InitEnv: installPath before normalize = " installPath))
    ASTB_GLOBAL->InstallPath = axlOSSlash(installPath)
    ASTB_GLOBAL->ToolboxPath = strcat(ASTB_GLOBAL->InstallPath "/allegro_skill_toolbox")
    ASTB_GLOBAL->CorePath    = strcat(ASTB_GLOBAL->ToolboxPath "/core")
    ASTB_GLOBAL->ModulePath  = strcat(ASTB_GLOBAL->ToolboxPath "/modules")
    ASTB_GLOBAL->FormPath    = strcat(ASTB_GLOBAL->ToolboxPath "/forms")
    ASTB_GLOBAL->ConfigPath  = strcat(ASTB_GLOBAL->ToolboxPath "/config")
    ASTB_GLOBAL->DocsPath    = strcat(ASTB_GLOBAL->ToolboxPath "/docs")
    
    ;; Make forms discoverable by Allegro
    when( isDir(ASTB_GLOBAL->FormPath)
      unless( member(ASTB_GLOBAL->FormPath getSkillPath())
        setSkillPath(cons(ASTB_GLOBAL->FormPath getSkillPath()))
      )
    )
    
    printf("[ASTB] Install path: %s\n" ASTB_GLOBAL->InstallPath)
    printf("[ASTB] Toolbox path: %s\n" ASTB_GLOBAL->ToolboxPath)
    ASTB_DebugLog(strcat("ASTB_InitEnv: done, ToolboxPath = " ASTB_GLOBAL->ToolboxPath))
  )
)

;;=========================================================================
;; 2. About / Reload commands
;;=========================================================================
procedure( ASTB_About()
  prog((msg)
    msg = strcat("allegro_skill_toolbox v1.0\n"
                 "Allegro PCB SKILL 插件集\n\n"
                 "Path: " ASTB_GLOBAL->ToolboxPath "\n")
    axlUIConfirm(msg)
    return(t)
  )
)

procedure( ASTB_Reload()
  prog(()
    ASTB_LoadCore()
    ASTB_LoadModules()
    ASTB_RegisterAllMenuCommands()
    ASTB_InjectMenu()
    axlUIConfirm("allegro_skill_toolbox 已重新加载。")
    return(t)
  )
)

;;=========================================================================
;; 3. Master Init - called after Allegro is fully ready
;;=========================================================================
procedure( ASTB_Init()
  prog((tid)
    errset(deleteFile("D:/Cadence/MFLXskill/astb_debug.log") t)
    ASTB_DebugLog("ASTB_Init: start")
    ASTB_InitEnv()
    ASTB_DebugLog("ASTB_Init: env done")
    load(strcat(ASTB_GLOBAL->CorePath "/loader.il"))
    ASTB_DebugLog("ASTB_Init: loader done")
    ASTB_LoadCore()
    ASTB_DebugLog("ASTB_Init: core done")
    ASTB_LoadConfig()
    ASTB_DebugLog("ASTB_Init: config done")
    ASTB_InitDefaultConfig()
    ASTB_DebugLog("ASTB_Init: default config done")
    ASTB_VersionInit()
    ASTB_DebugLog("ASTB_Init: version done")
    ASTB_LoadModules()
    ASTB_DebugLog("ASTB_Init: modules done")
    ASTB_RegisterAllMenuCommands()
    ASTB_DebugLog("ASTB_Init: commands done")
    
    ;; Inject menu immediately (Allegro GUI is ready when ASTB_Init is called)
    ASTB_InjectMenu()
    ASTB_DebugLog("ASTB_Init: menu injected")
    
    printf("[ASTB] allegro_skill_toolbox initialized successfully.\n")
    ASTB_DebugLog("ASTB_Init: success")
  )
)

;;=========================================================================
;; 4. Register init command (safe during allegro.ilinit)
;;=========================================================================
axlCmdRegister("ASTB_Init" 'ASTB_Init ?cmdType "general")
