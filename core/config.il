;; ============================================================
;; File: core/config.il
;; Purpose: Configuration management for allegro_skill_toolbox
;; Encoding: GBK (Simplified Chinese)
;; Note: Save this file in GBK encoding, do NOT use UTF-8
;; ============================================================

/*
#########################################################################################
#  Configuration Manager - Load/save user preferences                                     #
#########################################################################################
*/

;;=========================================================================
;; Global config table and key list
;;=========================================================================
when( boundp('ASTB_CONFIG)
  ASTB_CONFIG = makeTable('ASTB_CONFIG)
)

defvar(ASTB_CONFIG makeTable('ASTB_CONFIG))

defvar(ASTB_CONFIG_KEYS nil)

;;=========================================================================
;; Check if a config key exists (using tracked key list)
;;=========================================================================
procedure( ASTB_TableHasKey(table key)
  member(key ASTB_CONFIG_KEYS)
)

;;=========================================================================
;; Config file path
;;=========================================================================
procedure( ASTB_ConfigFile()
  strcat(ASTB_GLOBAL->ConfigPath "/astb.cfg")
)

;;=========================================================================
;; Load configuration from file
;;=========================================================================
procedure( ASTB_LoadConfig()
  prog((cfgFile port line kv)
    cfgFile = ASTB_ConfigFile()
    unless( isFile(cfgFile)
      ASTB_LogInfo("Config file not found, using defaults.")
      return(nil)
    )
    port = infile(cfgFile)
    when( null(port)
      ASTB_LogWarn(sprintf(nil "Cannot open config file: %s" cfgFile))
      return(nil)
    )
    while( gets(line port)
      kv = ASTB_ParseCfgLine(line)
      when( kv
        ASTB_SetConfig(car(kv) cadr(kv))
      )
    )
    close(port)
    ASTB_LogInfo(sprintf(nil "Config loaded from %s" cfgFile))
  )
)

;;=========================================================================
;; Save configuration to file
;;=========================================================================
procedure( ASTB_SaveConfig()
  prog((cfgFile port key)
    cfgFile = ASTB_ConfigFile()
    ASTB_EnsureDir(ASTB_GLOBAL->ConfigPath)
    port = outfile(cfgFile)
    when( null(port)
      ASTB_LogError(sprintf(nil "Cannot write config file: %s" cfgFile))
      return(nil)
    )
    fprintf(port "# allegro_skill_toolbox configuration\n")
    fprintf(port "# Auto-generated, do NOT edit with UTF-8 editor\n")
    foreach( key ASTB_CONFIG_KEYS
      fprintf(port "%s=%s\n" key ASTB_CONFIG[key])
    )
    close(port)
    ASTB_LogInfo(sprintf(nil "Config saved to %s" cfgFile))
  )
)

;;=========================================================================
;; Get a config value with default
;;=========================================================================
procedure( ASTB_GetConfig(key defaultVal)
  prog((val)
    val = defaultVal
    when( ASTB_TableHasKey(ASTB_CONFIG key)
      val = ASTB_CONFIG[key]
    )
    val
  )
)

;;=========================================================================
;; Set a config value
;;=========================================================================
procedure( ASTB_SetConfig(key value)
  prog((s)
    s = if( stringp(value) value sprintf(nil "%s" value) )
    ASTB_CONFIG[key] = s
    unless( member(key ASTB_CONFIG_KEYS)
      ASTB_CONFIG_KEYS = cons(key ASTB_CONFIG_KEYS)
    )
    s
  )
)

;;=========================================================================
;; Initialize default config values
;;=========================================================================
procedure( ASTB_InitDefaultConfig()
  prog(()
    unless( ASTB_TableHasKey(ASTB_CONFIG "version")
      ASTB_SetConfig("version" "1.0")
    )
    unless( ASTB_TableHasKey(ASTB_CONFIG "language")
      ASTB_SetConfig("language" "zh-CN")
    )
    unless( ASTB_TableHasKey(ASTB_CONFIG "logLevel")
      ASTB_SetConfig("logLevel" "INFO")
    )
    unless( ASTB_TableHasKey(ASTB_CONFIG "autoReload")
      ASTB_SetConfig("autoReload" "true")
    )
  )
)

printf("[ASTB] core/config.il loaded.\n")
