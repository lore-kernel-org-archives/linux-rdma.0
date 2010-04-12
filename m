From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] uDAPL v1.2 - cma: memory leak of verbs CQ and completion
 channels created during dat_ia_open
Date: Mon, 12 Apr 2010 14:21:09 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983B6715D89@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


check/cleanup CQ and completion channels during dat_ia_close

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_cma/dapl_ib_util.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/dapl/openib_cma/dapl_ib_util.c b/dapl/openib_cma/dapl_ib_util.c
index 9d97ae1..00aa5fb 100755
--- a/dapl/openib_cma/dapl_ib_util.c
+++ b/dapl/openib_cma/dapl_ib_util.c
@@ -373,12 +373,6 @@ DAT_RETURN dapls_ib_close_hca(IN DAPL_HCA *hca_ptr)
 	dapl_dbg_log(DAPL_DBG_TYPE_UTIL," close_hca: %p->%p\n",
 		     hca_ptr,hca_ptr->ib_hca_handle);
 
-	if (hca_ptr->ib_hca_handle != IB_INVALID_HANDLE) {
-		if (rdma_destroy_id(hca_ptr->ib_trans.cm_id)) 
-			return(dapl_convert_errno(errno,"ib_close_device"));
-		hca_ptr->ib_hca_handle = IB_INVALID_HANDLE;
-	}
-
 	dapl_os_lock(&g_hca_lock);
 	if (g_ib_thread_state != IB_THREAD_RUN) {
 		dapl_os_unlock(&g_hca_lock);
@@ -410,6 +404,22 @@ DAT_RETURN dapls_ib_close_hca(IN DAPL_HCA *hca_ptr)
 		nanosleep (&sleep, &remain);
 	}
 bail:
+	if (hca_ptr->ib_trans.ib_cq)
+		ibv_destroy_comp_channel(hca_ptr->ib_trans.ib_cq);
+
+	if (hca_ptr->ib_trans.ib_cq_empty) {
+		struct ibv_comp_channel *channel;
+		channel = hca_ptr->ib_trans.ib_cq_empty->channel;
+		ibv_destroy_cq(hca_ptr->ib_trans.ib_cq_empty);
+		ibv_destroy_comp_channel(channel);
+	}
+
+	if (hca_ptr->ib_hca_handle != IB_INVALID_HANDLE) {
+		if (rdma_destroy_id(hca_ptr->ib_trans.cm_id))
+			return (dapl_convert_errno(errno, "ib_close_device"));
+		hca_ptr->ib_hca_handle = IB_INVALID_HANDLE;
+	}
+
 	return (DAT_SUCCESS);
 }
   
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
