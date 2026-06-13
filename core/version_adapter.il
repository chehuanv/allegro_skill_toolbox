;; ============================================================
;; File: core/version_adapter.il
;; Purpose: Version detection and API compatibility adapter
;; Encoding: GBK (Simplified Chinese)
;; Note: Save this file in GBK encoding, do NOT use UTF-8
;; ============================================================

/*
#########################################################################################
#  Version Adapter - Detect Allegro version and provide compatibility shims               #
#########################################################################################
*/

;;=========================================================================
;; Global version info
;;=========================================================================
when( boundp('ASTB_VERSION_INFO)
  ASTB_VERSION_INFO = nil
)

defvar(ASTB_VERSION_INFO nil)

;;=========================================================================
;; Try common axlVersion property names and direct symbol call
;;=========================================================================
procedure( ASTB_ExtractVersionString(ver)
  prog((keys k ret)
    ;; Direct symbol call often returns the version string immediately
    ret = errset(axlVersion('fullVersion) t)
    when( ret && car(ret)
      return(car(ret))
    )
    ret = errset(axlVersion('version) t)
    when( ret && car(ret)
      return(car(ret))
    )
    ;; Otherwise inspect the property list
    when( ver
      keys = '(fullVersion version release productVersion progVersion buildDate)
      foreach( k keys
        when( ver->k
          return(ver->k)
        )
      )
    )
    return("")
  )
)

;;=========================================================================
;; Initialize version info
;;=========================================================================
procedure( ASTB_VersionInit()
  prog((ver verStr ret)
    ret = errset(ver = axlVersion() t)
    unless( ret
      ASTB_LogWarn("axlVersion() failed, version detection skipped.")
      return(nil)
    )
    ver = car(ret)
    ASTB_VERSION_INFO = ver
    verStr = ASTB_ExtractVersionString(ver)
    ASTB_LogInfo(sprintf(nil "Allegro version: %s" verStr))
  )
)

;;=========================================================================
;; Get raw version string
;;=========================================================================
procedure( ASTB_GetVersion()
  ASTB_ExtractVersionString(ASTB_VERSION_INFO)
)

;;=========================================================================
;; Check if version string contains a substring
;;=========================================================================
procedure( ASTB_VersionContains(sub)
  prog((verStr)
    verStr = ASTB_GetVersion()
    when( verStr
      rexMatchp(sub verStr)
    )
  )
)

;;=========================================================================
;; Common version checks
;;=========================================================================
procedure( ASTB_IsVersion174()
  ASTB_VersionContains("17.4")
)

procedure( ASTB_IsVersion241()
  ASTB_VersionContains("24.1")
)

;;=========================================================================
;; Require minimum version (simple string compare, may need numeric parse)
;;=========================================================================
procedure( ASTB_VersionRequire(minVer)
  prog((msg)
    unless( ASTB_VERSION_INFO
      ASTB_MsgError("无法获取 Allegro 版本")
      return(nil)
    )
    when( ASTB_VersionContains(minVer)
      return(t)
    )
    msg = sprintf(nil "当前版本 %s 不满足最低要求 %s" ASTB_GetVersion() minVer)
    ASTB_MsgError(msg)
    return(nil)
  )
)

;;=========================================================================
;; Adapter for API differences between versions
;; Example: some functions may have different signatures
;;=========================================================================
procedure( ASTB_DBCreateShapeSafe(points layer @key netName)
  prog((net)
    net = if(netName then axlDBNetCreate(netName) else nil)
    if( ASTB_IsVersion241()
    then
      ;; SPB 24.1 signature
      axlDBCreateShape(points layer net)
    else
      ;; SPB 17.4 signature
      axlDBCreateShape(points layer net)
    )
  )
)

printf("[ASTB] core/version_adapter.il loaded.\n")
