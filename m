From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 8/9] dapl-2.0: scm, cma: fini code can be called multiple
 times and hang via fork
Date: Wed, 19 May 2010 11:25:25 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C70130E1@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


The providers should protect against forked child exits and
not cleanup until the parent init actually exits. Otherwise,
the child will hang trying to cleanup dapl thread. Modify to
check process id for proper init to fini cleanup and limit
cleanup to parent only.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_cma/device.c |    8 ++++++--
 dapl/openib_scm/device.c |    7 +++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/dapl/openib_cma/device.c b/dapl/openib_cma/device.c
index c9fc8c3..99b8c55 100644
--- a/dapl/openib_cma/device.c
+++ b/dapl/openib_cma/device.c
@@ -197,9 +197,10 @@ static int getipaddr(char *name, char *addr, int len)
  * 	0 success, -1 error
  *
  */
+DAT_UINT32 g_parent = 0;
 int32_t dapls_ib_init(void)
 {
-	dapl_dbg_log(DAPL_DBG_TYPE_UTIL, " dapl_ib_init: \n");
+	g_parent = dapl_os_getpid();
 
 	/* initialize hca_list lock */
 	dapl_os_lock_init(&g_hca_lock);
@@ -215,7 +216,10 @@ int32_t dapls_ib_init(void)
 
 int32_t dapls_ib_release(void)
 {
-	dapl_dbg_log(DAPL_DBG_TYPE_UTIL, " dapl_ib_release: \n");
+	/* only parent will cleanup */
+	if (dapl_os_getpid() != g_parent)
+		return 0;
+
 	dapli_ib_thread_destroy();
 	if (g_cm_events != NULL)
 		rdma_destroy_event_channel(g_cm_events);
diff --git a/dapl/openib_scm/device.c b/dapl/openib_scm/device.c
index 03d38a6..a5b0742 100644
--- a/dapl/openib_scm/device.c
+++ b/dapl/openib_scm/device.c
@@ -216,8 +216,11 @@ static void destroy_cr_pipe(IN DAPL_HCA * hca_ptr)
  * 	0 success, -1 error
  *
  */
+DAT_UINT32 g_parent = 0;
 int32_t dapls_ib_init(void)
 {
+        g_parent = dapl_os_getpid();
+
 	/* initialize hca_list */
 	dapl_os_lock_init(&g_hca_lock);
 	dapl_llist_init_head(&g_hca_list);
@@ -230,6 +233,10 @@ int32_t dapls_ib_init(void)
 
 int32_t dapls_ib_release(void)
 {
+        /* only parent init will cleanup */
+        if (dapl_os_getpid() != g_parent)
+                return 0;
+	
 	dapli_ib_thread_destroy();
 	dapls_os_release();
 	return 0;
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
