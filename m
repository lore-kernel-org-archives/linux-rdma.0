From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] dapl-2.0: common: add some debug prints to help isolate QP
 type issues
Date: Wed, 19 May 2010 10:05:12 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C7012F20@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/qp.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/dapl/openib_common/qp.c b/dapl/openib_common/qp.c
index 15c1dae..473604b 100644
--- a/dapl/openib_common/qp.c
+++ b/dapl/openib_common/qp.c
@@ -182,8 +182,8 @@ dapls_ib_qp_alloc(IN DAPL_IA * ia_ptr,
 	}
 #endif
 	dapl_dbg_log(DAPL_DBG_TYPE_EP,
-		     " qp_alloc: qpn %p sq %d,%d rq %d,%d\n",
-		     ep_ptr->qp_handle->qp_num,
+		     " qp_alloc: qpn %p type %d sq %d,%d rq %d,%d\n",
+		     ep_ptr->qp_handle->qp_num, ep_ptr->qp_handle->qp_type,
 		     qp_create.cap.max_send_wr, qp_create.cap.max_send_sge,
 		     qp_create.cap.max_recv_wr, qp_create.cap.max_recv_sge);
 
@@ -561,8 +561,11 @@ dapls_create_ah(IN DAPL_HCA		*hca,
 	struct ibv_qp_attr qp_attr;
 	ib_ah_handle_t	ah;
 
-	if (qp->qp_type != IBV_QPT_UD)
+	if (qp->qp_type != IBV_QPT_UD) {
+		dapl_log(DAPL_DBG_TYPE_ERR, 
+			 " create_ah ERR: QP_type != UD\n");
 		return NULL;
+	}
 
 	dapl_os_memzero((void *)&qp_attr, sizeof(qp_attr));
 	qp_attr.qp_state = IBV_QP_STATE;
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
