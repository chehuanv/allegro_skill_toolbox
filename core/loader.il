;; ============================================================
;; File: core/loader.il
;; Purpose: Module auto-loader for allegro_skill_toolbox
;; Encoding: GBK (Simplified Chinese)
;; Note: Save this file in GBK encoding, do NOT use UTF-8
;; ============================================================

/*
#########################################################################################
#  Module Loader - Auto-discover and load core/module files                               #
#########################################################################################
*/

;;=========================================================================
;; Internal helper to check file suffix (loader must be self-contained)
;;=========================================================================
procedure( ASTB_HasSuffix(str suffix)
  prog((lenSuffix lenStr start)
    lenSuffix = strlen(suffix)
    lenStr = strlen(str)
    if( lenStr < lenSuffix
    then
      return(nil)
    else
      start = lenStr - lenSuffix + 1
      return(substring(str start lenStr) == suffix)
    )
  )
)

;;=========================================================================
;; Load all .il files in a directory (optionally recursive)
;;=========================================================================
procedure( ASTB_LoadDir(dirPath @optional (recursive nil))
  prog((files f fullPath result)
    when( isDir(dirPath)
      ASTB_DebugLog(strcat("ASTB_LoadDir: scanning " dirPath))
      files = sort(getDirFiles(dirPath) 'alphalessp)
      foreach( f files
        ;; Skip self/parent directory references to avoid infinite recursion
        unless( or(f == "." f == "..")
          fullPath = strcat(dirPath "/" f)
          when( isDir(fullPath) && recursive
            ASTB_LoadDir(fullPath recursive)
          )
          when( ASTB_HasSuffix(f ".il") && isFile(fullPath)
            ASTB_DebugLog(strcat("ASTB_LoadDir: loading file " fullPath))
            result = errset(load(fullPath) t)
            unless( result
              ASTB_LogError(sprintf(nil "Failed to load %s" fullPath))
            )
          )
        )
      )
    )
  )
)

;;=========================================================================
;; Load core libraries (load utils.il first as others may depend on it)
;;=========================================================================
procedure( ASTB_LoadCore()
  prog((coreFiles f result)
    ;; utils.il must be loaded first
    result = errset(load(strcat(ASTB_GLOBAL->CorePath "/utils.il")) t)
    unless( result
      ASTB_LogError("Failed to load core/utils.il")
    )
    
    coreFiles = sort(getDirFiles(ASTB_GLOBAL->CorePath) 'alphalessp)
    foreach( f coreFiles
      when( and(ASTB_HasSuffix(f ".il") f != "utils.il" f != "loader.il")
        result = errset(load(strcat(ASTB_GLOBAL->CorePath "/" f)) t)
        unless( result
          ASTB_LogError(sprintf(nil "Failed to load core/%s" f))
        )
      )
    )
    ASTB_LogInfo("Core libraries loaded.")
  )
)

;;=========================================================================
;; Load all module files
;;=========================================================================
procedure( ASTB_LoadModules()
  prog(()
    ASTB_DebugLog("ASTB_LoadModules: start")
    ASTB_LoadDir(ASTB_GLOBAL->ModulePath t)
    ASTB_LogInfo("Modules loaded.")
    ASTB_DebugLog("ASTB_LoadModules: done")
  )
)

;;=========================================================================
;; Reload everything
;;=========================================================================
procedure( ASTB_ReloadAll()
  prog(()
    ASTB_LoadCore()
    ASTB_LoadModules()
    ASTB_RegisterAllMenuCommands()
    ASTB_InjectMenu()
    axlUIConfirm("allegro_skill_toolbox �����¼��ء�")
  )
)

printf("[ASTB] core/loader.il loaded.\n")
