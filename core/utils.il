;; ============================================================
;; File: core/utils.il
;; Purpose: Common utility functions for allegro_skill_toolbox
;; Encoding: GBK (Simplified Chinese)
;; Note: Save this file in GBK encoding, do NOT use UTF-8
;; ============================================================

/*
#########################################################################################
#  Common Utilities - String, BBox, unit, file, list helpers                              #
#########################################################################################
*/

;;=========================================================================
;; String utilities
;;=========================================================================
procedure( ASTB_StringTrim(str)
  prog((start end len ch)
    len = strlen(str)
    start = 0
    end = len
    
    when( start < len
      ch = substring(str start + 1 1)
      while( and(start < len or(ch == " " ch == "\t" ch == "\n" ch == "\r"))
        start = start + 1
        when( start < len
          ch = substring(str start + 1 1)
        )
      )
    )
    
    when( end > start
      ch = substring(str end 1)
      while( and(end > start or(ch == " " ch == "\t" ch == "\n" ch == "\r"))
        end = end - 1
        when( end > start
          ch = substring(str end 1)
        )
      )
    )
    
    return(substring(str start + 1 end - start))
  )
)

procedure( ASTB_StringSplit(str sep)
  prog((result pos len token)
    result = nil
    when( null(str) return(nil) )
    when( null(sep) sep = "," )
    len = strlen(str)
    pos = 0
    token = ""
    while( pos < len
      ch = substring(str pos + 1 1)
      if( ch == sep
      then
        result = cons(ASTB_StringTrim(token) result)
        token = ""
      else
        token = strcat(token ch)
      )
      pos = pos + 1
    )
    result = cons(ASTB_StringTrim(token) result)
    return(reverse(result))
  )
)

procedure( ASTB_StringStartsWith(str prefix)
  prog((lenPrefix lenStr)
    lenPrefix = strlen(prefix)
    lenStr = strlen(str)
    if( lenStr < lenPrefix
    then
      return(nil)
    else
      return(substring(str 1 lenPrefix) == prefix)
    )
  )
)

procedure( ASTB_StringEndsWith(str suffix)
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
;; BBox utilities
;;=========================================================================
procedure( ASTB_BBoxCenter(bBox)
  prog((x y)
    x = (caar(bBox) + caadr(bBox)) / 2.0
    y = (cadar(bBox) + cadadr(bBox)) / 2.0
    return(list(x y))
  )
)

procedure( ASTB_BBoxUnion(bBox1 bBox2)
  prog((x1 y1 x2 y2)
    x1 = min(caar(bBox1) caar(bBox2))
    y1 = min(cadar(bBox1) cadar(bBox2))
    x2 = max(caadr(bBox1) caadr(bBox2))
    y2 = max(cadadr(bBox1) cadadr(bBox2))
    return(list(list(x1 y1) list(x2 y2)))
  )
)

procedure( ASTB_BBoxWidth(bBox)
  abs(caadr(bBox) - caar(bBox))
)

procedure( ASTB_BBoxHeight(bBox)
  abs(cadadr(bBox) - cadar(bBox))
)

;;=========================================================================
;; Unit conversion
;;=========================================================================
procedure( ASTB_MilToMm(mil)
  mil * 0.0254
)

procedure( ASTB_MmToMil(mm)
  mm / 0.0254
)

procedure( ASTB_InchToMm(inch)
  inch * 25.4
)

procedure( ASTB_MmToInch(mm)
  mm / 25.4
)

;;=========================================================================
;; User message / logging
;;=========================================================================
procedure( ASTB_LogInfo(msg)
  printf("[ASTB][INFO] %s\n" msg)
)

procedure( ASTB_LogWarn(msg)
  printf("[ASTB][WARN] %s\n" msg)
)

procedure( ASTB_LogError(msg)
  printf("[ASTB][ERROR] %s\n" msg)
)

procedure( ASTB_MsgBox(msg)
  axlUIConfirm(msg)
)

procedure( ASTB_MsgWarn(msg)
  axlUIConfirm(strcat("����:\n" msg))
)

procedure( ASTB_MsgError(msg)
  axlUIConfirm(strcat("����:\n" msg))
)

;;=========================================================================
;; File / directory utilities
;;=========================================================================
procedure( ASTB_FileExists(path)
  isFile(path)
)

procedure( ASTB_DirExists(path)
  isDir(path)
)

procedure( ASTB_EnsureDir(path)
  unless( isDir(path)
    axlOSCreateDir(path)
  )
  isDir(path)
)

procedure( ASTB_ListFiles(dir pattern)
  prog((result allFiles f)
    result = nil
    when( isDir(dir)
      allFiles = getDirFiles(dir)
      foreach( f allFiles
        when( rexMatchp(pattern f)
          result = cons(f result)
        )
      )
    )
    return(reverse(result))
  )
)

;;=========================================================================
;; List utilities
;;=========================================================================
procedure( ASTB_Filter(lst pred)
  prog((result item)
    result = nil
    foreach( item lst
      when( apply(pred list(item))
        result = cons(item result)
      )
    )
    return(reverse(result))
  )
)

procedure( ASTB_FindFirst(lst pred)
  prog((item)
    foreach( item lst
      when( apply(pred list(item))
        return(item)
      )
    )
    return(nil)
  )
)

;;=========================================================================
;; Config line parsing: key=value, support # comment
;;=========================================================================
procedure( ASTB_ParseCfgLine(line)
  prog((trimmed pos key value len i)
    trimmed = ASTB_StringTrim(line)
    when( or(null(trimmed) eq(trimmed "") substring(trimmed 1 1) == "#")
      return(nil)
    )
    ;; Find position of '=' (1-based index)
    pos = nil
    len = strlen(trimmed)
    i = 1
    while( i <= len
      prog(()
        when( strcmp(substring(trimmed i 1) "=") == 0
          pos = i
          i = len + 1  ;; break
        )
        i = i + 1
      )
    )
    when( pos && pos > 0
      key = ASTB_StringTrim(substring(trimmed 1 pos - 1))
      value = ASTB_StringTrim(substring(trimmed pos + 1 len))
      return(list(key value))
    )
    return(nil)
  )
)

;;=========================================================================
;; Check if running in interactive mode (GUI available)
;;=========================================================================
procedure( ASTB_IsInteractive()
  prog((mode)
    mode = axlGetVariable("interface")
    if( mode == "Allegro PCB"
    then
      return(t)
    else
      return(nil)
    )
  )
)

printf("[ASTB] core/utils.il loaded.\n")
