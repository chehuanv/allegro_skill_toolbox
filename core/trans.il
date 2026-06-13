;; ============================================================
;; File: core/trans.il
;; Purpose: Transaction control and safe execution wrapper
;; Encoding: GBK
;; ============================================================

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Transaction & Error Handling - Wrap DB operations and catch exceptions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Global list to track registered commands
when( boundp('ASTB_REGISTERED_COMMANDS)
  ASTB_REGISTERED_COMMANDS = nil
)

defvar(ASTB_REGISTERED_COMMANDS nil)

;; Safe execute a procedure with catch/throw handling
;; Returns: t if success, nil if error
procedure( ASTB_SafeExec(proc args @optional (errMsgOut nil))
  prog((result errMsg ret)
    when( null(proc)
      ASTB_LogError("ASTB_SafeExec: proc is nil")
      return(nil)
    )
    ret = errset(result = apply(proc args) t)
    if( ret
    then
      return(car(ret))
    else
      errMsg = "Execution error"
      ASTB_LogError(errMsg)
      when( errMsgOut
        errMsgOut->value = errMsg
      )
      return(nil)
    )
  )
)

;; Execute a database-modifying procedure inside a transaction
procedure( ASTB_DBTransaction(proc args @optional (errMsgOut nil))
  prog((result errMsg ret txId)
    when( null(proc)
      ASTB_LogError("ASTB_DBTransaction: proc is nil")
      return(nil)
    )
    txId = axlDBTransactionStart("ASTB")
    ret = errset(result = apply(proc args) t)
    if( ret
    then
      axlDBTransactionCommit(txId)
      return(car(ret))
    else
      errMsg = "DB transaction failed, rolled back"
      axlDBTransactionRollback(txId)
      ASTB_LogError(errMsg)
      when( errMsgOut
        errMsgOut->value = errMsg
      )
      return(nil)
    )
  )
)

;; Dummy done/cancel callbacks for interactive commands
procedure( ASTB_DummyDone()
  t
)

procedure( ASTB_DummyCancel()
  t
)

;; Convert a string or symbol to symbol safely
procedure( ASTB_ToSymbol(x)
  cond(
    ( symbolp(x) x )
    ( stringp(x) stringToSymbol(x) )
    ( t nil )
  )
)

;; Register a command directly to an implementation function
;; cmdType: "interactive" | "general"
procedure( ASTB_RegisterCommand(cmdName procName @key (cmdType "general"))
  prog((procSym ret cmdStr)
    procSym = ASTB_ToSymbol(procName)
    cmdStr = if( stringp(cmdName) then cmdName else sprintf(nil "%s" cmdName) )
    unless( procSym
      ASTB_LogWarn(sprintf(nil "Command %s target is invalid" cmdStr))
      return(nil)
    )
    unless( fboundp(procSym)
      ASTB_LogWarn(sprintf(nil "Command %s target %s not defined" cmdStr procName))
      return(nil)
    )
    ret = errset(axlCmdRegister(cmdStr procSym ?cmdType cmdType ?doneCmd 'ASTB_DummyDone ?cancelCmd 'ASTB_DummyCancel) t)
    unless( ret
      ASTB_LogWarn(sprintf(nil "Failed to register command %s" cmdStr))
      return(nil)
    )
    ASTB_REGISTERED_COMMANDS = cons(list(cmdStr procName cmdType) ASTB_REGISTERED_COMMANDS)
    ASTB_LogInfo(sprintf(nil "Registered command: %s -> %s" cmdStr procName))
    return(t)
  )
)

;; Create a stub procedure for a command that is not yet implemented
procedure( ASTB_CreateStub(cmdName)
  prog((procSym code ret)
    procSym = ASTB_ToSymbol(cmdName)
    when( null(procSym)
      return(nil)
    )
    when( fboundp(procSym)
      return(nil)
    )
    code = list('procedure procSym '()
                 list('prog '()
                       list('ASTB_MsgBox sprintf(nil "Feature [%s] is under development" cmdName))
                       list('return 't)
                 )
           )
    ret = errset(eval(code) t)
    when( ret
      ASTB_LogInfo(sprintf(nil "Created stub: %s" cmdName))
    )
  )
)

printf("[ASTB] core/trans.il loaded.\n")
