From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm: Add configure output messages for several
	configure options
Date: Fri, 05 Apr 2013 15:32:35 -0700
Message-ID: <1365201155.5901.73.camel@auk59.llnl.gov>
References: <1365097110.5901.36.camel@auk59.llnl.gov>
	 <515F3470.5090702@dev.mellanox.co.il>
	 <1365196997.5901.69.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1365196997.5901.69.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The --enable-console-loopback, --enable-console-socket, --enable-perf-mgr,
--enable-perf-mgr-profile, and --enable-default-event-plugin did not
have a checking message or notice message indicating if they were
enabled/disabled when running configure.

This made things difficult when perusing old build logs to determine
if things were properly enabled/disabled.

Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 config/osmvsel.m4 |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/config/osmvsel.m4 b/config/osmvsel.m4
index 6c98c07..87e1d74 100644
--- a/config/osmvsel.m4
+++ b/config/osmvsel.m4
@@ -183,6 +183,7 @@ AC_DEFUN([OPENIB_OSM_CONSOLE_SOCKET_SEL], [
 # --- BEGIN OPENIB_OSM_CONSOLE_SOCKET_SEL ---
 
 dnl Console over a loopback socket is default if libwrap is available
+AC_MSG_CHECKING([to enable console loopback])
 AC_ARG_ENABLE(console-loopback,
 [  --enable-console-loopback Enable a console socket on the loopback interface, requires tcp_wrappers (default yes)],
 [case $enableval in
@@ -190,6 +191,7 @@ AC_ARG_ENABLE(console-loopback,
      no)  console_loopback=no ;;
    esac],
    console_loopback=yes)
+AC_MSG_RESULT([$console_loopback])
 
 if test $console_loopback = yes; then
 AC_CHECK_LIB(wrap, request_init, [], [console_loopback=no
@@ -202,6 +204,7 @@ if test $console_loopback = yes; then
 fi
 
 dnl Console over a socket connection
+AC_MSG_CHECKING([to enable console socket])
 AC_ARG_ENABLE(console-socket,
 [  --enable-console-socket Enable a console socket, requires --enable-console-loopback (default no)],
 [case $enableval in
@@ -209,6 +212,8 @@ AC_ARG_ENABLE(console-socket,
      no)  console_socket=no ;;
    esac],
    console_socket=no)
+AC_MSG_RESULT([$console_socket])
+
 if test $console_socket = yes; then
   if test $console_loopback = no; then
     AC_MSG_ERROR([--enable-console-socket requires --enable-console-loopback])
@@ -228,6 +233,7 @@ AC_DEFUN([OPENIB_OSM_PERF_MGR_SEL], [
 # --- BEGIN OPENIB_OSM_PERF_MGR_SEL ---
 
 dnl enable the perf-mgr
+AC_MSG_CHECKING([to enable perf mgr])
 AC_ARG_ENABLE(perf-mgr,
 [  --enable-perf-mgr Enable the performance manager (default yes)],
    [case $enableval in
@@ -235,6 +241,9 @@ AC_ARG_ENABLE(perf-mgr,
      no)  perf_mgr=no ;;
    esac],
    perf_mgr=yes)
+AC_MSG_RESULT([$perf_mgr])
+
+AC_MSG_CHECKING([to enable perf mgr profiling])
 AC_ARG_ENABLE(perf-mgr-profile,
 [  --enable-perf-mgr-profile Enable the performance manager profiling (default no)],
 	[case $enableval in
@@ -242,6 +251,8 @@ AC_ARG_ENABLE(perf-mgr-profile,
 	no)  perf_mgr_profile=no ;;
 	esac],
 	perf_mgr_profile=no)
+AC_MSG_RESULT([$perf_mgr_profile])
+
 if test $perf_mgr = yes; then
   AC_DEFINE(ENABLE_OSM_PERF_MGR,
 	1,
@@ -261,6 +272,7 @@ AC_DEFUN([OPENIB_OSM_DEFAULT_EVENT_PLUGIN_SEL], [
 # --- BEGIN OPENIB_OSM_DEFAULT_EVENT_PLUGIN_SEL ---
 
 dnl enable the default-event-plugin
+AC_MSG_CHECKING([to enable default event plugin])
 AC_ARG_ENABLE(default-event-plugin,
 [  --enable-default-event-plugin  Enable a default event plugin "osmeventplugin" (default no)],
    [case $enableval in
@@ -268,6 +280,8 @@ AC_ARG_ENABLE(default-event-plugin,
      no)  default_event_plugin=no ;;
    esac],
    default_event_plugin=no)
+AC_MSG_RESULT([$default_event_plugin])
+
 if test $default_event_plugin = yes; then
   AC_DEFINE(ENABLE_OSM_DEFAULT_EVENT_PLUGIN,
 	    1,
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
