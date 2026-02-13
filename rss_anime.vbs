Set WshShell = CreateObject("WScript.Shell")
Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")

' --- 1. 启动阶段 ---
WshShell.Run """此处改为python script中flexget.exe的路径"" daemon stop", 0, True
' 强制清理残留进程（防止 PID 冲突报错）
WshShell.Run "taskkill /F /IM flexget.exe /T", 0, True
' 尝试删除锁文件 (VBS 也可以处理文件，但直接 shell 运行更简单)
WshShell.Run "cmd /c del /f /q ""%USERPROFILE%\.flexget\.config-lock""", 0, True

' 启动 qBittorrent (隐藏窗口)
WshShell.Run """此处改为qbittorrent.exe的路径""", 0, False

' 等待 5 秒，确保 qBit 进程已出现在系统列表中且 WebUI 已就绪
Wscript.Sleep 5000 

' 启动 Flexget Daemon 
WshShell.Run """此处改为python script中flexget.exe的路径"" daemon start", 0, False

Wscript.Sleep 30000

WshShell.Run "flexget execute", 0, False
' --- 2. 监控阶段 ---
' 进入循环，直到发现 qBit 进程消失
Do
    ' 查询是否存在 qbittorrent.exe 进程
    Set colProcesses = objWMIService.ExecQuery _
        ("Select * from Win32_Process Where Name = 'qbittorrent.exe'")
    
    ' 如果进程数为 0，说明 qBit 已关闭
    If colProcesses.Count = 0 Then
        ' --- 3. 退出阶段 ---
        ' 执行 flexget daemon stop 指令地关闭 Flexget
        ' 使用 0 隐藏窗口，True 表示脚本会等待这条命令执行完再往下走
        WshShell.Run """此处改为python script中flexget.exe的路径"" daemon stop", 0, True
        Exit Do 
    End If
    
    ' 每 10 秒检查一次，避免过度占用 CPU
    Wscript.Sleep 10000 
Loop

' 释放对象
Set objWMIService = Nothing
Set WshShell = Nothing