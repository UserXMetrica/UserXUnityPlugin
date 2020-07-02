//#define INIT_USERX_AT_START

using System.Runtime.InteropServices;
using UnityEngine;
using System.Collections.Generic;

public class UserXKitExtension : MonoBehaviour
{
#if UNITY_IOS && !UNITY_EDITOR
    [DllImport("__Internal")]
    private static extern void _UserXPluginInit(string title);

    [DllImport("__Internal")]
    private static extern void _UserXPluginStart();

    [DllImport("__Internal")]
    private static extern void _UserXPluginStop();

    [DllImport("__Internal")]
    private static extern void _UserXPluginUID(string title);

    [DllImport("__Internal")]
    private static extern void _UserXPluginAddEvent(string e);

    [DllImport("__Internal")]
    private static extern void _UserXPluginAddEventParamsCount(string e, int paramCount, string[] parametrs);
    
    [DllImport("__Internal")]
    private static extern void _UserXPluginStartScreen(string scr, string parentScr);

    [RuntimeInitializeOnLoadMethod]
    private static void Initialize()
    {
#if INIT_USERX_AT_START
        _UserXPluginInit("USERX_KEY");
#endif
    }
#endif

    public static void Init(string key)
    {
#if UNITY_IOS && !UNITY_EDITOR
        _UserXPluginInit(key);
#endif
    }

    public static void StartRecording()
    {
#if UNITY_IOS && !UNITY_EDITOR
        _UserXPluginStart();
#endif
    }

    public static void StopRecording()
    {
#if UNITY_IOS && !UNITY_EDITOR
        _UserXPluginStop();
#endif
    }

    public static void SetUserID(string key)
    {
#if UNITY_IOS && !UNITY_EDITOR
        _UserXPluginUID(key);
#endif
    }

    public static void AddEvent(string e)
    {
#if UNITY_IOS && !UNITY_EDITOR
        _UserXPluginAddEvent(e);
#endif
    }

    public static void AddEvent(string e, Dictionary<string, string> parametrs)
    {
#if UNITY_IOS && !UNITY_EDITOR
        List<string> mutableList = new List<string>();
        foreach( KeyValuePair<string, string> item in parametrs )
        {
            mutableList.Add(item.Key);
            mutableList.Add(item.Value);
        }
        var param = mutableList.ToArray();
        int count = param.Length/2;
        _UserXPluginAddEventParamsCount(e, count, param);
#endif
    }

    public static void StartScreen(string scr, string parentScr = null)
    {
#if UNITY_IOS && !UNITY_EDITOR
        _UserXPluginStartScreen(scr, parentScr);
#endif
    }
}
