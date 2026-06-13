---
name: allegro-skill-debugging
description: Debugging and hard-won lessons from the allegro_skill_toolbox project. Use when diagnosing Allegro SKILL/AXL issues in this project, especially config loading, menu language switching, string handling, return-value bugs, GBK encoding problems, or mysterious nil values in SPB 17.4/24.1.
---

# Allegro SKILL Debugging Lessons

This skill captures the concrete bugs and fixes encountered while developing `allegro_skill_toolbox` for Cadence Allegro SPB 17.4/24.1.

## 1. `substring` Semantics

In Allegro SKILL, `substring(s i j)` means **start at 1-based position `i`, return `j` characters** (length), not "from i to j".

Wrong (treated j as end index):
```skill
substring(str i i)      ;; returns i chars starting at i
substring(str start+1 end)
```

Correct:
```skill
substring(str i 1)                      ;; single char at i
substring(str start+1 end - start)      ;; slice from start+1 to end inclusive
substring(str 1 lenPrefix)              ;; prefix of length lenPrefix
```

Real bug: `ASTB_ParseCfgLine` used `substring(trimmed i i)` to scan for `=`, so it never matched and the config file was never loaded.

## 2. String Comparison

Use `strcmp(a b) == 0` for safe string equality inside loops or when types are uncertain. `==` can appear to work in some contexts and silently fail in others.

```skill
when( strcmp(substring(trimmed i 1) "=") == 0
  pos = i
)
```

## 3. Config Table Lifecycle

Do **not** reset `ASTB_CONFIG` every time `core/config.il` reloads. Use `defvar` once and let the table persist across reloads; otherwise already-set values disappear while `ASTB_CONFIG_KEYS` persists, leaving keys pointing to an empty table.

```skill
defvar(ASTB_CONFIG makeTable('ASTB_CONFIG))
defvar(ASTB_CONFIG_KEYS nil)
```

## 4. Return Values and `unbound`

A hash table lookup for a missing key returns the symbol `unbound`. Callers often format `unbound` as `nil`. Always guard against returning `unbound`:

```skill
procedure( ASTB_GetConfig(key defaultVal)
  prog((val hasKey)
    hasKey = ASTB_StringInList(key ASTB_CONFIG_KEYS)
    val = defaultVal
    when( hasKey
      val = ASTB_CONFIG[key]
    )
    when( eq(val 'unbound)
      val = defaultVal
    )
    return(val)
  )
)
```

Use explicit `return()` to avoid losing values in dynamic-scoping call chains.

## 5. Menu Language Switching in 17.4

Dynamic refresh of an already-injected menu is **not reliable** in Allegro 17.4:

- `axlUIMenuChange(id 'display label)` returns success but does **not** visually update the menu.
- `axlUIMenuDelete` cannot remove a popup created via `axlUIMenuInsert`.
- Re-injecting creates duplicate menus.

The only robust workflow:
1. Save language to config (`language=en` / `zh-CN`).
2. Show a confirmation in the target language.
3. **Restart Allegro** and re-run `ASTB_Init`.

## 6. Logging Strategy

Use two channels:

- `ASTB_LogInfo(msg)` → command window, user-visible, keep minimal.
- `ASTB_DebugLog(msg)` → `D:/Cadence/MFLXskill/astb_debug.log`, verbose diagnostics.

Move repetitive internal logs (`ASTB_GetConfig`, `ASTB_SetConfig`, per-line config parsing) to `ASTB_DebugLog` so the command window stays readable.

## 7. Encoding

All `.il`, `.form`, `.cfg`, and `.ilinit` files must be **GBK/GB18030**. Never let editors save them as UTF-8 — Chinese strings will corrupt and tools like `convert_to_gbk.py` will fail with replacement characters (`\ufffd`).

Use the provided tools after any edit:
```bash
python tools/check_parens.py <files>
python tools/convert_to_gbk.py <files>
```

When patching files programmatically, read/write in GBK (`gbk` codec) and preserve CRLF line endings.

## 8. Quick Diagnostic Checklist

When a config value is correct in the file but wrong at runtime:

1. Check `ASTB_LoadConfig` is parsing lines (`ASTB_ParseCfgLine`).
2. Check `ASTB_SetConfig` is adding keys to `ASTB_CONFIG_KEYS`.
3. Check `ASTB_GetConfig` returns the value, not `unbound` or `nil`.
4. Check `ASTB_InitDefaultConfig` is not overwriting the loaded value.
5. Verify `substring` calls use `(start, length)` semantics.
6. Confirm file is valid GBK, not UTF-8.
