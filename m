From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/5] dapl ucm: allocate/free AH hash table for UD endpoint
 types
Date: Fri, 22 May 2015 21:43:55 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F977D76BA5@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/qp.c |   32 ++++++++++++++++++++++++++++++--
 1 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/dapl/openib_common/qp.c b/dapl/openib_common/qp.c index 10abfbb..95ea70d 100644
--- a/dapl/openib_common/qp.c
+++ b/dapl/openib_common/qp.c
@@ -183,6 +183,13 @@ dapls_ib_qp_alloc(IN DAPL_IA * ia_ptr,
 		    (128 << ia_ptr->hca_ptr->ib_trans.ib_cm.mtu)) {
 			goto err;
 		}
+		ep_ptr->qp_handle->ah =
+			(ib_ah_handle_t*) dapl_os_alloc(sizeof(ib_ah_handle_t) * DCM_AH_SPACE);
+
+		if (!ep_ptr->qp_handle->ah)
+			goto err;
+
+		dapl_os_memzero(ep_ptr->qp_handle->ah, sizeof(ib_ah_handle_t) * DCM_AH_SPACE);
 	}
 #endif
 
@@ -225,9 +232,15 @@ dapls_ib_qp_alloc(IN DAPL_IA * ia_ptr,  #endif
 	ep_ptr->qp_handle->qp =	ibv_create_qp(ib_pd_handle, &qp_create);
 	if (!ep_ptr->qp_handle->qp) {
-		dapl_log(1," qp_alloc ERR %d %s line %d on device %s\n",
-			   errno, strerror(errno), __LINE__ ,
+		dapl_log(1," qp_alloc ERR %d %s on device %s\n",
+			   errno, strerror(errno),
 			   ibv_get_device_name(ia_ptr->hca_ptr->ib_trans.ib_dev));
+		dapl_log(1," qp_attr: SQ %d,%d cq %p RQ %d,%d cq %p SRQ %p [inl %d typ %d]\n",
+			    qp_create.cap.max_send_wr, qp_create.cap.max_send_sge,
+			    req_cq, qp_create.cap.max_recv_wr,
+			    qp_create.cap.max_recv_sge, rcv_cq,
+			    qp_create.srq, qp_create.cap.max_inline_data,
+			    qp_create.qp_type);
 		ret = errno;
 		goto err;
 	}
@@ -330,6 +343,10 @@ err:
 		if (ep_ptr->qp_handle->qp2)
 			ibv_destroy_qp(ep_ptr->qp_handle->qp2);
 #endif
+		if (ep_ptr->qp_handle->ah)
+			dapl_os_free(ep_ptr->qp_handle->ah,
+				     sizeof(ib_ah_handle_t) * DCM_AH_SPACE);
+
 		dapl_os_free(ep_ptr->qp_handle, sizeof(struct dcm_ib_qp));
 	}
 	ep_ptr->qp_handle = IB_INVALID_HANDLE; @@ -405,6 +422,17 @@ DAT_RETURN dapls_ib_qp_free(IN DAPL_IA * ia_ptr, IN DAPL_EP * ep_ptr)
 		dapl_os_unlock(&ep_ptr->header.lock);
 	}
 
+	/* destroy any UD address handles */
+	if (ep_ptr->qp_handle->ah) {
+		int i;
+
+		for (i = 0; i < DCM_AH_SPACE; i++) {
+			if (ep_ptr->qp_handle->ah[i])
+				ibv_destroy_ah(ep_ptr->qp_handle->ah[i]);
+		}
+		dapl_os_free(ep_ptr->qp_handle->ah, sizeof(ib_ah_handle_t) * DCM_AH_SPACE);
+	}
+
 	dapl_os_free(ep_ptr->qp_handle, sizeof(struct dcm_ib_qp));
 	ep_ptr->qp_handle = IB_INVALID_HANDLE;
 	return DAT_SUCCESS;
--
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
