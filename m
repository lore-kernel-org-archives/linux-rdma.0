From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/4] dapl/openib_scm: update windows support to use 'fd' abstraction
Date: Wed, 30 Sep 2009 16:11:19 -0700
Message-ID: <E61D2EAC1B404A49ACB04B4092C00BEC@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The completion manager was updated to provide an abstraction that
better mimicked how fd's were used.  Update dapl to use this
abstraction, rather than the older completion manager api.

This helps minimize changes between linux and windows.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 dapl/openib_scm/device.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/dapl/openib_scm/device.c b/dapl/openib_scm/device.c
index bb72279..a327390 100644
--- a/dapl/openib_scm/device.c
+++ b/dapl/openib_scm/device.c
@@ -70,18 +70,16 @@ void dapli_ib_thread_destroy(void);
 #include "..\..\..\..\..\etc\user\comp_channel.cpp"
 #include <rdma\winverbs.h>
 
-struct ibvw_windata windata;
+static COMP_SET ufds;
 
 static int dapls_os_init(void)
 {
-	return ibvw_get_windata(&windata, IBVW_WINDATA_VERSION);
+	return CompSetInit(&ufds);
 }
 
 static void dapls_os_release(void)
 {
-	if (windata.comp_mgr)
-		ibvw_release_windata(&windata, IBVW_WINDATA_VERSION);
-	windata.comp_mgr = NULL;
+	CompSetCleanup(&ufds);
 }
 
 static int dapls_config_verbs(struct ibv_context *verbs)
@@ -98,7 +96,7 @@ static int dapls_config_comp_channel(struct ibv_comp_channel *channel)
 
 static int dapls_thread_signal(void)
 {
-	CompManagerCancel(windata.comp_mgr);
+	CompSetCancel(&ufds);
 	return 0;
 }
 #else				// _WIN64 || WIN32
@@ -584,7 +582,6 @@ void dapli_thread(void *arg)
 {
 	struct _ib_hca_transport *hca;
 	struct _ib_hca_transport *uhca[8];
-	COMP_CHANNEL *channel;
 	int ret, idx, cnt;
 
 	dapl_dbg_log(DAPL_DBG_TYPE_UTIL, " ib_thread(%d,0x%x): ENTER: \n",
@@ -595,11 +592,14 @@ void dapli_thread(void *arg)
 	     g_ib_thread_state == IB_THREAD_RUN; 
 	     dapl_os_lock(&g_hca_lock)) {
 
+		CompSetZero(&ufds);
 		idx = 0;
 		hca = dapl_llist_is_empty(&g_hca_list) ? NULL :
 		      dapl_llist_peek_head(&g_hca_list);
 
 		while (hca) {
+			CompSetAdd(&hca->ib_ctx->channel, &ufds);
+			CompSetAdd(&hca->ib_cq->comp_channel, &ufds);
 			uhca[idx++] = hca;
 			hca = dapl_llist_next_entry(&g_hca_list,
 						    (DAPL_LLIST_ENTRY *)
@@ -608,7 +608,7 @@ void dapli_thread(void *arg)
 		cnt = idx;
 
 		dapl_os_unlock(&g_hca_lock);
-		ret = CompManagerPoll(windata.comp_mgr, INFINITE, &channel);
+		ret = CompSetPoll(&ufds, INFINITE);
 
 		dapl_dbg_log(DAPL_DBG_TYPE_UTIL,
 			     " ib_thread(%d) poll_event 0x%x\n",



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
