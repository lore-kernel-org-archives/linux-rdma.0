From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] dapl-2.0: windows: comp_channel.cpp is included by util.c
 in the openib_common.
Date: Wed, 19 May 2010 16:27:40 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C70135ED@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Remove it from device.c in individual providers to avoid
duplicate definitions.

Line endings were corrected to linux format from windows as part of
the change.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_cma/device.c |   75 ++++++++++++++++++++++-----------------------
 dapl/openib_scm/device.c |    1 -
 dapl/openib_ucm/device.c |    5 +--
 3 files changed, 39 insertions(+), 42 deletions(-)

diff --git a/dapl/openib_cma/device.c b/dapl/openib_cma/device.c
index 99b8c55..e4ff22e 100644
--- a/dapl/openib_cma/device.c
+++ b/dapl/openib_cma/device.c
@@ -54,7 +54,6 @@ DAPL_OS_LOCK g_hca_lock;
 struct dapl_llist_entry *g_hca_list;
 
 #if defined(_WIN64) || defined(_WIN32)
-#include "..\..\..\..\..\etc\user\comp_channel.cpp"
 #include <rdma\winverbs.h>
 
 static COMP_SET ufds;
@@ -144,43 +143,43 @@ static int dapls_thread_signal(void)
 }
 #endif
 
-/* Get IP address using network name, address, or device name */
-static int getipaddr(char *name, char *addr, int len)
-{
-        struct addrinfo *res;
-
-        /* assume netdev for first attempt, then network and address type */
-        if (getipaddr_netdev(name, addr, len)) {
-                if (getaddrinfo(name, NULL, NULL, &res)) {
-                        dapl_log(DAPL_DBG_TYPE_ERR,
-                                 " open_hca: getaddr_netdev ERROR:"
-                                 " %s. Is %s configured?\n",
-                                 strerror(errno), name);
-                        return 1;
-                } else {
-                        if (len >= res->ai_addrlen)
-                                memcpy(addr, res->ai_addr, res->ai_addrlen);
-                        else {
-                                freeaddrinfo(res);
-                                return 1;
-                        }
-                        freeaddrinfo(res);
-                }
-        }
-
-        dapl_dbg_log(
-                DAPL_DBG_TYPE_UTIL,
-                " getipaddr: family %d port %d addr %d.%d.%d.%d\n",
-                ((struct sockaddr_in *)addr)->sin_family,
-                ((struct sockaddr_in *)addr)->sin_port,
-                ((struct sockaddr_in *)addr)->sin_addr.s_addr >> 0 & 0xff,
-                ((struct sockaddr_in *)addr)->sin_addr.s_addr >> 8 & 0xff,
-                ((struct sockaddr_in *)addr)->sin_addr.s_addr >> 16 & 0xff,
-                ((struct sockaddr_in *)addr)->sin_addr.
-                 s_addr >> 24 & 0xff);
-
-        return 0;
-}
+/* Get IP address using network name, address, or device name */
+static int getipaddr(char *name, char *addr, int len)
+{
+        struct addrinfo *res;
+
+        /* assume netdev for first attempt, then network and address type */
+        if (getipaddr_netdev(name, addr, len)) {
+                if (getaddrinfo(name, NULL, NULL, &res)) {
+                        dapl_log(DAPL_DBG_TYPE_ERR,
+                                 " open_hca: getaddr_netdev ERROR:"
+                                 " %s. Is %s configured?\n",
+                                 strerror(errno), name);
+                        return 1;
+                } else {
+                        if (len >= res->ai_addrlen)
+                                memcpy(addr, res->ai_addr, res->ai_addrlen);
+                        else {
+                                freeaddrinfo(res);
+                                return 1;
+                        }
+                        freeaddrinfo(res);
+                }
+        }
+
+        dapl_dbg_log(
+                DAPL_DBG_TYPE_UTIL,
+                " getipaddr: family %d port %d addr %d.%d.%d.%d\n",
+                ((struct sockaddr_in *)addr)->sin_family,
+                ((struct sockaddr_in *)addr)->sin_port,
+                ((struct sockaddr_in *)addr)->sin_addr.s_addr >> 0 & 0xff,
+                ((struct sockaddr_in *)addr)->sin_addr.s_addr >> 8 & 0xff,
+                ((struct sockaddr_in *)addr)->sin_addr.s_addr >> 16 & 0xff,
+                ((struct sockaddr_in *)addr)->sin_addr.
+                 s_addr >> 24 & 0xff);
+
+        return 0;
+}
 
 /*
  * dapls_ib_init, dapls_ib_release
diff --git a/dapl/openib_scm/device.c b/dapl/openib_scm/device.c
index a5b0742..4c50f03 100644
--- a/dapl/openib_scm/device.c
+++ b/dapl/openib_scm/device.c
@@ -67,7 +67,6 @@ DAT_RETURN  dapli_ib_thread_init(void);
 void dapli_ib_thread_destroy(void);
 
 #if defined(_WIN64) || defined(_WIN32)
-#include "..\..\..\..\..\etc\user\comp_channel.cpp"
 #include <rdma\winverbs.h>
 
 static COMP_SET ufds;
diff --git a/dapl/openib_ucm/device.c b/dapl/openib_ucm/device.c
index 1f324b3..1959c76 100644
--- a/dapl/openib_ucm/device.c
+++ b/dapl/openib_ucm/device.c
@@ -37,17 +37,16 @@ static void ucm_service_destroy(IN DAPL_HCA *hca);
 static int  ucm_service_create(IN DAPL_HCA *hca);
 
 #if defined (_WIN32)
-#include "..\..\..\..\..\etc\user\comp_channel.cpp"
 #include <rdma\winverbs.h>
 
 static int32_t create_os_signal(IN DAPL_HCA * hca_ptr)
 {
-	return CompSetInit(&hca_ptr->ib_trans.signal.set);
+	return CompSetInit(&hca_ptr->ib_trans.signal.set);
 }
 
 static void destroy_os_signal(IN DAPL_HCA * hca_ptr)
 {
-	CompSetCleanup(&hca_ptr->ib_trans.signal.set);
+	CompSetCleanup(&hca_ptr->ib_trans.signal.set);
 }
 
 static int dapls_config_verbs(struct ibv_context *verbs)
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
