###FlexGet-qBit-Sync-Tool
这是一个轻量级的 Windows 自动化脚本，旨在无缝集成 FlexGet 与 qBittorrent 的生命周期管理 。通过 VBScript 实现后台静默运行，解决常见的程序多开锁定问题，并确保下载器与订阅工具同步开关 。
+2

##📋 环境要求
在开始之前，请确保你的系统中已安装：

Python & FlexGet：建议安装在 Anaconda 环境或系统全局环境中 。
FlexGet：通过 pip install flexget 安装

qBittorrent：需要开启 Web UI（默认端口 8080），以便 FlexGet 推送种子 。

Windows 操作系统：支持运行 .vbs 脚本。

##🚀 快速上手
1. 配置 FlexGet
将 config.yml 放入你的 FlexGet 配置文件夹（默认通常为 C:\Users\YourName\.flexget\） 。

注意：请在 config.yml 中修改 username 和 password 为你自己的 qBit Web UI 凭据 。

2. 自定义启动脚本
打开 rss_anime.vbs，根据你的安装路径修改以下部分 ：

VBScript
' 修改为你的 FlexGet 程序路径 
WshShell.Run """此处改为python script中flexget.exe的路径"" daemon stop", 0, True

WshShell.Run """此处改为python script中flexget.exe的路径"" daemon start", 0, False

' 修改为你的 qBittorrent 安装路径 
WshShell.Run """此处改为qbittorrent.exe的路径""", 0, False

3. 运行
双击 rss_anime.vbs。你会发现 qBittorrent 正常启动，而 FlexGet 已在后台静默运行并开始执行每 3 小时一次的扫描任务 。

##📂 文件结构

rss_anime.vbs: 主逻辑脚本，负责进程控制、锁定清理及生命周期监控 。

config.yml: FlexGet 配置文件，包含 RSS 订阅源及下载路径策略 。

##🌟 核心特性

静默后台运行：使用 WshShell.Run 的隐藏参数，彻底消除黑色 CMD 窗口弹出，实现真正的无感自动化 。

异常自动修复：启动前自动清理残留的 flexget.exe 进程，防止 PID 冲突 。

强制删除 %USERPROFILE%\.flexget\.config-lock 锁文件，确保在非法关机后依然能顺利启动 。

生命周期同步：脚本会每隔 10 秒监控一次 qbittorrent.exe 的状态 。当 qBittorrent 关闭时，脚本会自动发送 daemon stop 指令安全停止 FlexGet 并退出，避免浪费系统资源 。

智能路径归档：配套的 config.yml 支持根据当前年份和季度动态创建文件夹（例如：D:/anime/26.01/芙莉莲2），实现番剧自动分类存储 。

