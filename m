From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] dapl-2.0: windows: remove static paths from dapltest scripts
Date: Wed, 19 May 2010 10:02:39 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C7012F0A@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 

signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 test/dapltest/scripts/dt-cli.bat |   11 +++++------
 test/dapltest/scripts/dt-svr.bat |   12 +++++-------
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/test/dapltest/scripts/dt-cli.bat b/test/dapltest/scripts/dt-cli.bat
index f1eb23b..441b975 100644
--- a/test/dapltest/scripts/dt-cli.bat
+++ b/test/dapltest/scripts/dt-cli.bat
@@ -17,13 +17,12 @@ if not "!F!" == "off" (
 rem set DAT_OVERRIDE=D:\dapl2\dat.conf
 rem favor DAT 2.0 (dapl2test.exe) over DAT 1.1 (dapltest.exe)
 
-set PF="%ProgramFiles%\WinOF"
-
-if NOT EXIST %PF%\dapl2test.exe (
-    echo Missing file %PF%\dapl2test.exe ?
-    exit /B 1
-)
 set DT=dapl2test.exe
+%DT% -h > Nul 2>&1
+if not "%ERRORLEVEL%" == "1" (
+    echo %0: ERR - %DT% not in exec path?
+    exit /B %ERRORLEVEL%
+)
 rem     To debug dapl2test - use dapl2testd.exe with ibnic0v2d
 
 rem setup DAPL provider name: translate shorthand name or use name from dat.conf.
diff --git a/test/dapltest/scripts/dt-svr.bat b/test/dapltest/scripts/dt-svr.bat
index abd17fb..9974d23 100644
--- a/test/dapltest/scripts/dt-svr.bat
+++ b/test/dapltest/scripts/dt-svr.bat
@@ -5,15 +5,13 @@ rem
 SETLOCAL
 
 rem set DAT_OVERRIDE=C:\DAT\dat.conf
+set DT=dapl2test.exe
 
-set PF="%ProgramFiles%\WinOF"
-
-if NOT EXIST %PF%\dapl2test.exe (
-    echo Missing file %PF%\dapl2test.exe ?
-    exit /B 1
+%DT% -h > Nul 2>&1
+if not "%ERRORLEVEL%" == "1" (
+    echo %0: ERR - %DT% not in exec path?
+    exit /B %ERRORLEVEL%
 )
-
-set DT=dapl2test.exe
 rem To debug dapl2test - use dapl2testd.exe with ibnic0v2d
 
 rem which Dapl provider?
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
