;; ============================================================
;; File: core/form_utils.il
;; Purpose: UI form utilities for allegro_skill_toolbox
;; Encoding: GBK (Simplified Chinese)
;; Note: Save this file in GBK encoding, do NOT use UTF-8
;; ============================================================

/*
#########################################################################################
#  UI Form Utilities - Common dialog/form helpers                                         #
#########################################################################################
*/

;;=========================================================================
;; Show simple message dialog
;;=========================================================================
procedure( ASTB_ShowMessage(msg)
  axlUIConfirm(msg)
)

procedure( ASTB_ShowWarning(msg)
  axlUIConfirm(strcat("警告:\n" msg))
)

procedure( ASTB_ShowError(msg)
  axlUIConfirm(strcat("错误:\n" msg))
)

;;=========================================================================
;; Ask user for a string value
;;=========================================================================
procedure( ASTB_AskString(prompt defaultVal)
  prog((result)
    result = axlUIDataAsk("string" prompt defaultVal)
    if( null(result)
    then
      nil
    else
      result
    )
  )
)

;;=========================================================================
;; Ask user to select a file
;; mode: "open" | "save"
;;=========================================================================
procedure( ASTB_AskFile(prompt defaultPath mode)
  prog((result)
    if( mode == "save"
    then
      result = axlUIDialogSave(prompt defaultPath)
    else
      result = axlUIDialogFile(prompt defaultPath nil)
    )
    result
  )
)

;;=========================================================================
;; Ask user to pick a point
;; Returns: point list (x y) or nil
;;=========================================================================
procedure( ASTB_AskPoint(prompt)
  prog((result)
    result = axlEnterPoint(prompt)
    result
  )
)

;;=========================================================================
;; Progress indicator (console based, Allegro progress bar if available)
;;=========================================================================
procedure( ASTB_ProgressStart(title)
  ASTB_LogInfo(strcat("开始: " title))
)

procedure( ASTB_ProgressUpdate(percent msg)
  when( msg
    ASTB_LogInfo(sprintf(nil "[%d%%] %s" percent msg))
  )
)

procedure( ASTB_ProgressEnd(msg)
  when( msg
    ASTB_LogInfo(strcat("完成: " msg))
  )
)

;;=========================================================================
;; Create a simple form definition list (to be used with axlFormCreate)
;; This returns a form spec list; actual .form file is preferred
;;=========================================================================
procedure( ASTB_BuildFormSpec(formName title w h)
  list(
    list('form formName)
    list('title title)
    list('width w)
    list('height h)
  )
)

printf("[ASTB] core/form_utils.il loaded.\n")
