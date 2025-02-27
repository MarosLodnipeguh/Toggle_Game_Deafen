#Include VA.ahk

first_exec := true
audio_app := 0
muted := false
default_volume := 0
reduced_volume := 0

reduction_percentage := 0.133 ; Defines how much the default volume will be reduced (13.33% of the original volume in this case)

F1::  ; F1 hotkey - adjust volume of active window

  ; Get the process ID of the active window
  WinGet, ActivePid, PID, A

  ; Get the volume object of the active window
  audio_app := GetVolumeObject(ActivePid)

  if (!audio_app) {
    MsgBox, 48, , There was a problem retrieving the application volume interface. Focus on your game / app and try again. , 10
    return
  }

  if (first_exec) {
    VA_ISimpleAudioVolume_GetMasterVolume(audio_app, default_volume) ; Get the original volume level of the application
    reduced_volume := (default_volume * reduction_percentage) ; Calculate the reduced volume level
    first_exec := false
  }

  if (!muted) {
    VA_ISimpleAudioVolume_SetMasterVolume(audio_app, reduced_volume) ; Set volume to reduced value
    muted := true
  } else {
    VA_ISimpleAudioVolume_SetMasterVolume(audio_app, default_volume) ; Set volume back to the original value
    muted := false
  }

  ObjRelease(audio_app)
return

; Required for app-specific volume adjustment
GetVolumeObject(Param = 0)
{
    static IID_IASM2 := "{77AA99A0-1BD6-484F-8BC7-2C654C9A9B6F}"
    , IID_IASC2 := "{bfb7ff88-7239-4fc9-8fa2-07c950be9c6d}"
    , IID_ISAV := "{87CE5498-68D6-44E5-9215-6DA47EF883D8}"

    ; Get PID from process name
    if Param is not Integer
    {
        Process, Exist, %Param%
        Param := ErrorLevel
    }

    ; Get the default audio endpoint
    DAE := VA_GetDevice()

    ; Activate the session manager
    VA_IMMDevice_Activate(DAE, IID_IASM2, 0, 0, IASM2)

    ; Enumerate sessions on this device
    VA_IAudioSessionManager2_GetSessionEnumerator(IASM2, IASE)
    VA_IAudioSessionEnumerator_GetCount(IASE, Count)

    ; Search for an audio session with the required name
    Loop, % Count
    {
        ; Get the IAudioSessionControl object
        VA_IAudioSessionEnumerator_GetSession(IASE, A_Index-1, IASC)

        ; Query the IAudioSessionControl for an IAudioSessionControl2 object
        IASC2 := ComObjQuery(IASC, IID_IASC2)
        ObjRelease(IASC)

        ; Get the session's process ID
        VA_IAudioSessionControl2_GetProcessID(IASC2, SPID)

        ; If the process name is the one we are looking for
        if (SPID == Param)
        {
            ; Query for the ISimpleAudioVolume
            ISAV := ComObjQuery(IASC2, IID_ISAV)

            ObjRelease(IASC2)
            break
        }
        ObjRelease(IASC2)
    }
    ObjRelease(IASE)
    ObjRelease(IASM2)
    ObjRelease(DAE)

    return ISAV
}

;
; ISimpleAudioVolume: {87CE5498-68D6-44E5-9215-6DA47EF883D8}
;
VA_ISimpleAudioVolume_SetMasterVolume(this, ByRef fLevel, GuidEventContext="") {
    return DllCall(NumGet(NumGet(this+0)+3*A_PtrSize), "ptr", this, "float", fLevel, "ptr", VA_GUID(GuidEventContext))
}
VA_ISimpleAudioVolume_GetMasterVolume(this, ByRef fLevel) {
  return DllCall(NumGet(NumGet(this+0)+4*A_PtrSize), "ptr", this, "float*", fLevel)
}
VA_ISimpleAudioVolume_SetMute(this, ByRef Muted, GuidEventContext="") {
  return DllCall(NumGet(NumGet(this+0)+5*A_PtrSize), "ptr", this, "int", Muted, "ptr", VA_GUID(GuidEventContext))
}
VA_ISimpleAudioVolume_GetMute(this, ByRef Muted) {
  return DllCall(NumGet(NumGet(this+0)+6*A_PtrSize), "ptr", this, "int*", Muted)
}
