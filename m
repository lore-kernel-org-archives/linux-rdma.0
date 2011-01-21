From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] dapl-2.0: ucm, scm: exchange max_qp_rd_atom and limit
 outstanding requests
Date: Thu, 20 Jan 2011 18:52:06 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983011F5526C1@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

exchange and add proper checking to limit outstanding
rdma reads and atomics. Use one of the reserve bytes
in CM message protocol to exchange limits and reset
EP attribute rdma_out and set QP RTS attribute properly.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/dapl_ib_common.h |    5 +++--
 dapl/openib_common/qp.c             |    5 +++--
 dapl/openib_scm/cm.c                |   11 +++++++++++
 dapl/openib_ucm/cm.c                |   13 +++++++++++++
 4 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/dapl/openib_common/dapl_ib_common.h b/dapl/openib_common/dapl_ib_common.h
index 8b0e0ba..78f71d2 100644
--- a/dapl/openib_common/dapl_ib_common.h
+++ b/dapl/openib_common/dapl_ib_common.h
@@ -58,7 +58,7 @@ typedef	struct ibv_context	*ib_hca_handle_t;
 typedef ib_hca_handle_t		dapl_ibal_ca_t;
 
 /* QP info to exchange, wire protocol version for these CM's */
-#define DCM_VER 6
+#define DCM_VER 7
 
 /* CM private data areas, same for all operations */
 #define        DCM_MAX_PDATA_SIZE      118
@@ -98,7 +98,8 @@ typedef struct _ib_cm_msg
 	uint16_t		p_size;
 	uint32_t		s_id;  /* src pid */
 	uint32_t		d_id;  /* dst pid */
-	uint8_t			resv[6];
+	uint8_t			rd_in; /* atomic_rd_in */
+	uint8_t			resv[5];
 	union dcm_addr		saddr;
 	union dcm_addr		daddr;
 	union dcm_addr		saddr_alt;
diff --git a/dapl/openib_common/qp.c b/dapl/openib_common/qp.c
index 1826362..fb13576 100644
--- a/dapl/openib_common/qp.c
+++ b/dapl/openib_common/qp.c
@@ -442,11 +442,12 @@ dapls_modify_qp_state(IN ib_qp_handle_t		qp_handle,
 	case IBV_QPS_RTR:
 		dapl_dbg_log(DAPL_DBG_TYPE_EP,
 				" QPS_RTR: type %d qpn 0x%x gid %p (%d) lid 0x%x"
-				" port %d ep %p qp_state %d \n",
+				" port %d ep %p qp_state %d rd_atomic %d\n",
 				qp_handle->qp_type, ntohl(qpn), gid, 
 				ia_ptr->hca_ptr->ib_trans.global,
 				ntohs(lid), ia_ptr->hca_ptr->port_num,
-				ep_ptr, ep_ptr->qp_state);
+				ep_ptr, ep_ptr->qp_state,
+				ep_ptr->param.ep_attr.max_rdma_read_in);
 
 		mask |= IBV_QP_AV |
 			IBV_QP_PATH_MTU |
diff --git a/dapl/openib_scm/cm.c b/dapl/openib_scm/cm.c
index c638663..b0fbadf 100644
--- a/dapl/openib_scm/cm.c
+++ b/dapl/openib_scm/cm.c
@@ -530,6 +530,9 @@ static void dapli_socket_connected(dp_ib_cm_handle_t cm_ptr, int err)
 	cm_ptr->state = DCM_REP_PENDING;
 	dapl_os_unlock(&cm_ptr->lock);
 
+	/* set max rdma inbound requests */
+	cm_ptr->msg.rd_in = ep_ptr->param.ep_attr.max_rdma_read_in;
+
 	/* send qp info and pdata to remote peer */
 	exp = sizeof(ib_cm_msg_t) - DCM_MAX_PDATA_SIZE;
 	iov[0].iov_base = (void *)&cm_ptr->msg;
@@ -798,6 +801,10 @@ static void dapli_socket_connect_rtu(dp_ib_cm_handle_t cm_ptr)
 		goto bail;
 	}
 
+	/* rdma_out, initiator, cannot exceed remote rdma_in max */
+	ep_ptr->param.ep_attr.max_rdma_read_out = 
+		DAPL_MIN(ep_ptr->param.ep_attr.max_rdma_read_out, cm_ptr->msg.rd_in);
+
 	/* modify QP to RTR and then to RTS with remote info */
 	dapl_os_lock(&ep_ptr->header.lock);
 	if (dapls_modify_qp_state(ep_ptr->qp_handle,
@@ -1196,6 +1203,9 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,
 		goto bail;
 	}
 #endif
+	/* rdma_out, initiator, cannot exceed remote rdma_in max */
+	ep_ptr->param.ep_attr.max_rdma_read_out = 
+		DAPL_MIN(ep_ptr->param.ep_attr.max_rdma_read_out, cm_ptr->msg.rd_in);
 
 	/* modify QP to RTR and then to RTS with remote info already read */
 	dapl_os_lock(&ep_ptr->header.lock);
@@ -1235,6 +1245,7 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,
 	/* send our QP info, IA address, pdata. Don't overwrite dst data */
 	local.ver = htons(DCM_VER);
 	local.op = htons(DCM_REP);
+	local.rd_in = ep_ptr->param.ep_attr.max_rdma_read_in;
 	local.saddr.ib.qpn = htonl(ep_ptr->qp_handle->qp_num);
 	local.saddr.ib.qp_type = ep_ptr->qp_handle->qp_type;
 	local.saddr.ib.lid = ia_ptr->hca_ptr->ib_trans.lid;
diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index 5b157fd..c5ddf04 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -1080,6 +1080,10 @@ static void ucm_connect_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 	}
 	dapl_os_unlock(&cm->lock);
 
+        /* rdma_out, initiator, cannot exceed remote rdma_in max */
+        cm->ep->param.ep_attr.max_rdma_read_out =
+                DAPL_MIN(cm->ep->param.ep_attr.max_rdma_read_out, cm->msg.rd_in);
+
 	/* modify QP to RTR and then to RTS with remote info */
 	dapl_os_lock(&cm->ep->header.lock);
 	if (dapls_modify_qp_state(cm->ep->qp_handle,
@@ -1232,6 +1236,7 @@ static void ucm_accept(ib_cm_srvc_handle_t cm, ib_cm_msg_t *msg)
 	acm->msg.sqpn = cm->msg.sqpn;
 	acm->msg.p_size = msg->p_size;
 	acm->msg.d_id = msg->s_id;
+	acm->msg.rd_in = msg->rd_in;
 
 	/* CR saddr is CM daddr info, need EP for local saddr */
 	dapl_os_memcpy(&acm->msg.daddr, &msg->saddr, sizeof(union dcm_addr));
@@ -1510,6 +1515,10 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 	}
 #endif
 
+        /* rdma_out, initiator, cannot exceed remote rdma_in max */
+        ep->param.ep_attr.max_rdma_read_out =
+                DAPL_MIN(ep->param.ep_attr.max_rdma_read_out, cm->msg.rd_in);
+
 	/* modify QP to RTR and then to RTS with remote info already read */
 	dapl_os_lock(&ep->header.lock);
 	if (dapls_modify_qp_state(ep->qp_handle,
@@ -1544,6 +1553,7 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 
 	/* setup local QP info and type from EP, copy pdata, for reply */
 	cm->msg.op = htons(DCM_REP);
+	cm->msg.rd_in = ep->param.ep_attr.max_rdma_read_in;
 	cm->msg.saddr.ib.qpn = htonl(ep->qp_handle->qp_num);
 	cm->msg.saddr.ib.qp_type = ep->qp_handle->qp_type;
 	cm->msg.saddr.ib.lid = cm->hca->ib_trans.addr.ib.lid; 
@@ -1626,6 +1636,9 @@ dapls_ib_connect(IN DAT_EP_HANDLE ep_handle,
 	cm->msg.dqpn = cm->msg.daddr.ib.qpn;
 	cm->msg.daddr.ib.qpn = 0; /* don't have a remote qpn until reply */
 	
+        /* set max rdma inbound requests */
+        cm->msg.rd_in = ep->param.ep_attr.max_rdma_read_in;
+
 	if (p_size) {
 		cm->msg.p_size = htons(p_size);
 		dapl_os_memcpy(&cm->msg.p_data, p_data, p_size);
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
