From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 22/47] RDMA/i40iw: Suppress gcc 7 fall-through complaints
Date: Fri,  6 Oct 2017 14:33:08 -0700
Message-ID: <20171006213333.6721-23-bart.vanassche@wdc.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006213333.6721-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that gcc 7 reports the following warning when building with W=1:

warning: this statement may fall through [-Wimplicit-fallthrough=]

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c   | 1 +
 drivers/infiniband/hw/i40iw/i40iw_hw.c   | 1 +
 drivers/infiniband/hw/i40iw/i40iw_puda.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 9017c1cc51d4..617030679a48 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -2406,6 +2406,7 @@ static void i40iw_handle_rst_pkt(struct i40iw_cm_node *cm_node,
 	case I40IW_CM_STATE_FIN_WAIT1:
 	case I40IW_CM_STATE_LAST_ACK:
 		cm_node->cm_id->rem_ref(cm_node->cm_id);
+		/* fall through */
 	case I40IW_CM_STATE_TIME_WAIT:
 		cm_node->state = I40IW_CM_STATE_CLOSED;
 		i40iw_rem_ref_cm_node(cm_node);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_hw.c b/drivers/infiniband/hw/i40iw/i40iw_hw.c
index 476867a3f584..7e9de845a350 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_hw.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_hw.c
@@ -410,6 +410,7 @@ void i40iw_process_aeq(struct i40iw_device *iwdev)
 		case I40IW_AE_UDA_XMIT_DGRAM_TOO_LONG:
 		case I40IW_AE_UDA_XMIT_IPADDR_MISMATCH:
 			ctx_info->err_rq_idx_valid = false;
+			/* fall through */
 		default:
 			if (!info->sq && ctx_info->err_rq_idx_valid) {
 				ctx_info->err_rq_idx = info->wqe_idx;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_puda.c b/drivers/infiniband/hw/i40iw/i40iw_puda.c
index c2cab20c4bc5..2a3bf6488b4b 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_puda.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_puda.c
@@ -816,6 +816,7 @@ void i40iw_puda_dele_resources(struct i40iw_sc_vsi *vsi,
 	switch (rsrc->completion) {
 	case PUDA_HASH_CRC_COMPLETE:
 		i40iw_free_hash_desc(rsrc->hash_desc);
+		/* fall through */
 	case PUDA_QP_CREATED:
 		if (!reset)
 			i40iw_puda_free_qp(rsrc);
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
