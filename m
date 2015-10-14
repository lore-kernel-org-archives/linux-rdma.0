From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/6] IB/mad: Add QP parameters to ib_mad_qp_info
Date: Wed, 14 Oct 2015 11:29:44 +0300
Message-ID: <1444811388-22486-3-git-send-email-haggaie@mellanox.com>
References: <1444811388-22486-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444811388-22486-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In preparation for having an array of QPs in each ib_mad_qp_info, add the
qp_type and qp_num parameters to the ib_mad_qp_info struct so that clients
won't need to access the QPs themselves for this information.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/mad.c      | 16 ++++++++++------
 drivers/infiniband/core/mad_priv.h |  2 ++
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 62ce3a4c20b7..7a1186173179 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1799,7 +1799,7 @@ static int validate_mad(const struct ib_mad_hdr *mad_hdr,
 			bool opa)
 {
 	int valid = 0;
-	u32 qp_num = qp_info->qp->qp_num;
+	u32 qp_num = qp_info->qp_num;
 
 	/* Make sure MAD base version is understood */
 	if (mad_hdr->base_version != IB_MGMT_BASE_VERSION &&
@@ -2054,7 +2054,7 @@ static enum smi_action handle_ib_smi(const struct ib_mad_port_private *port_priv
 				    &response->grh, wc,
 				    port_priv->device,
 				    smi_get_fwd_port(smp),
-				    qp_info->qp->qp_num,
+				    qp_info->qp_num,
 				    response->mad_size,
 				    false);
 
@@ -2142,7 +2142,7 @@ handle_opa_smi(struct ib_mad_port_private *port_priv,
 				    &response->grh, wc,
 				    port_priv->device,
 				    opa_smi_get_fwd_port(smp),
-				    qp_info->qp->qp_num,
+				    qp_info->qp_num,
 				    recv->header.wc.byte_len,
 				    true);
 
@@ -2264,7 +2264,7 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 						    &recv->grh, wc,
 						    port_priv->device,
 						    port_num,
-						    qp_info->qp->qp_num,
+						    qp_info->qp_num,
 						    mad_size, opa);
 				goto out;
 			}
@@ -2283,7 +2283,7 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 		   generate_unmatched_resp(recv, response, &mad_size, opa)) {
 		agent_send_response((const struct ib_mad_hdr *)response->mad, &recv->grh, wc,
 				    port_priv->device, port_num,
-				    qp_info->qp->qp_num, mad_size, opa);
+				    qp_info->qp_num, mad_size, opa);
 	}
 
 out:
@@ -3009,7 +3009,8 @@ static int ib_mad_port_start(struct ib_mad_port_private *port_priv)
 		 */
 		attr->qp_state = IB_QPS_INIT;
 		attr->pkey_index = pkey_index;
-		attr->qkey = (qp->qp_num == 0) ? 0 : IB_QP1_QKEY;
+		attr->qkey = (port_priv->qp_info[i].qp_num == 0) ? 0 :
+			     IB_QP1_QKEY;
 		ret = ib_modify_qp(qp, attr, IB_QP_STATE |
 					     IB_QP_PKEY_INDEX | IB_QP_QKEY);
 		if (ret) {
@@ -3101,6 +3102,8 @@ static int create_mad_qp(struct ib_mad_qp_info *qp_info,
 	struct ib_qp_init_attr	qp_init_attr;
 	int ret;
 
+	qp_info->qp_type = qp_type;
+
 	memset(&qp_init_attr, 0, sizeof qp_init_attr);
 	qp_init_attr.send_cq = qp_info->port_priv->cq;
 	qp_init_attr.recv_cq = qp_info->port_priv->cq;
@@ -3124,6 +3127,7 @@ static int create_mad_qp(struct ib_mad_qp_info *qp_info,
 	/* Use minimum queue sizes unless the CQ is resized */
 	qp_info->send_queue.max_active = mad_sendq_size;
 	qp_info->recv_queue.max_active = mad_recvq_size;
+	qp_info->qp_num = qp_info->qp->qp_num;
 	return 0;
 
 error:
diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index 4a4f7aad0978..ae099f0f9701 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -191,6 +191,8 @@ struct ib_mad_qp_info {
 	struct ib_mad_snoop_private **snoop_table;
 	int snoop_table_size;
 	atomic_t snoop_count;
+	enum ib_qp_type qp_type;
+	u32 qp_num;
 };
 
 struct ib_mad_port_private {
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
