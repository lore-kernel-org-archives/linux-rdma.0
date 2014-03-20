From: Ilya Nelkenbaum <ilyan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] ibutils/ibis: fix ibis_get_local_ports_info uninitialized
 variable
Date: Thu, 20 Mar 2014 10:40:33 +0200
Message-ID: <532AA981.9080403@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Initialize attr_array before calling osm_vendor_get_all_port_attr

Signed-off-by: Eitan Zahavi <eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 ibis/src/ibis.i          |    1 +
 ibis/src/ibis_wrap.c     |    1 +
 ibis/src/ibissh_wrap.cpp |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/ibis/src/ibis.i b/ibis/src/ibis.i
index 8fc4440..28a0912 100644
--- a/ibis/src/ibis.i
+++ b/ibis/src/ibis.i
@@ -385,6 +385,7 @@ ibisp_is_debug(void)
 	 static char res[128];
 	 Tcl_Obj *p_obj;
 
+    memset(attr_array, 0, MAX_LOCAL_IBPORTS*sizeof(ib_port_attr_t));
     if (!IbisObj.initialized)
     {
       Tcl_SetStringObj(
diff --git a/ibis/src/ibis_wrap.c b/ibis/src/ibis_wrap.c
index 5098c2a..ee97601 100644
--- a/ibis/src/ibis_wrap.c
+++ b/ibis/src/ibis_wrap.c
@@ -3209,6 +3209,7 @@ typedef struct {
 	 static char res[128];
 	 Tcl_Obj *p_obj;
 
+    memset(attr_array, 0, MAX_LOCAL_IBPORTS*sizeof(ib_port_attr_t));
     if (!IbisObj.initialized)
     {
       Tcl_SetStringObj(
diff --git a/ibis/src/ibissh_wrap.cpp b/ibis/src/ibissh_wrap.cpp
index f75cde6..917904f 100644
--- a/ibis/src/ibissh_wrap.cpp
+++ b/ibis/src/ibissh_wrap.cpp
@@ -3209,6 +3209,7 @@ typedef struct {
 	 static char res[128];
 	 Tcl_Obj *p_obj;
 
+    memset(attr_array, 0, MAX_LOCAL_IBPORTS*sizeof(ib_port_attr_t));
     if (!IbisObj.initialized)
     {
       Tcl_SetStringObj(
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
