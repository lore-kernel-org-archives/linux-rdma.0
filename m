From: Bharat Potnuri <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] dapl: Fix segfault while freeing qp
Date: Tue, 29 Sep 2015 17:59:34 +0530
Message-ID: <1443529774-26431-1-git-send-email-bharat@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Bharat Potnuri <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In function dapls_ib_qp_free(), pointers qp and cm_ptr->cm_id->qp are
pointing to the same qp structure, initialized in function
dapls_ib_qp_alloc(). The memory pointed by these pointers are freed
twice in function dapls_ib_qp_free(), using rdma_destroy_qp() for the
case _OPENIB_CMA defined and then further using ibv_destroy_qp(),
causing a segmentation fault while freeing the qp. Therefore assigned
NULL value to qp to avoid freeing illegal memory.

Fixes: 7ff4f840bf11 ("common: add CM-EP linking to support mutiple CM's
and proper protection during destruction")

Signed-off-by: Bharat Potnuri <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 dapl/openib_common/qp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/dapl/openib_common/qp.c b/dapl/openib_common/qp.c
index 527fc1d4c46b..01f91ca2bd83 100644
--- a/dapl/openib_common/qp.c
+++ b/dapl/openib_common/qp.c
@@ -397,6 +397,7 @@ DAT_RETURN dapls_ib_qp_free(IN DAPL_IA * ia_ptr, IN DAPL_EP * ep_ptr)
 #ifdef _OPENIB_CMA_
 		rdma_destroy_qp(cm_ptr->cm_id);
 		cm_ptr->cm_id->qp = NULL;
+		qp = NULL;
 #endif
 
 #ifdef _OPENIB_MCM_
-- 
2.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
