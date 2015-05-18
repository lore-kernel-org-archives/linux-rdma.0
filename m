From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 2/2] RDMA/nes: Enable the use of the tos field in
 the nes driver
Date: Mon, 18 May 2015 15:28:14 -0500
Message-ID: <20150518202814.GA9896@TENIKOLO-MOBL2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Faisal Latif <Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

RDMA/nes: Enable the use of the tos field in the nes driver

Signed-off-by: Faisal Latif <Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c |    7 +++++++
 drivers/infiniband/hw/nes/nes_cm.h |    2 ++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 6f09a72..adeea3f 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -1586,6 +1586,8 @@ static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
 		  &cm_node->loc_addr, cm_node->loc_port,
 		  &cm_node->rem_addr, cm_node->rem_port);
 	cm_node->listener = listener;
+	if (listener)
+		cm_node->tos = listener->tos;
 	cm_node->netdev = nesvnic->netdev;
 	cm_node->cm_id = cm_info->cm_id;
 	memcpy(cm_node->loc_mac, nesvnic->netdev->dev_addr, ETH_ALEN);
@@ -2907,6 +2909,9 @@ static int nes_cm_init_tsa_conn(struct nes_qp *nesqp, struct nes_cm_node *cm_nod
 
 	nesqp->nesqp_context->misc2 |= cpu_to_le32(64 << NES_QPCONTEXT_MISC2_TTL_SHIFT);
 
+	nesqp->nesqp_context->misc2 |= cpu_to_le32(
+		cm_node->tos << NES_QPCONTEXT_MISC2_TOS_SHIFT);
+
 	nesqp->nesqp_context->mss |= cpu_to_le32(((u32)cm_node->tcp_cntxt.mss) << 16);
 
 	nesqp->nesqp_context->tcp_state_flow_label |= cpu_to_le32(
@@ -3581,6 +3586,7 @@ int nes_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		cm_node->ord_size = 1;
 
 	cm_node->apbvt_set = apbvt_set;
+	cm_node->tos = cm_id->tos;
 	nesqp->cm_node = cm_node;
 	cm_node->nesqp = nesqp;
 	nes_add_ref(&nesqp->ibqp);
@@ -3635,6 +3641,7 @@ int nes_create_listen(struct iw_cm_id *cm_id, int backlog)
 	}
 
 	cm_id->provider_data = cm_node;
+	cm_node->tos = cm_id->tos;
 
 	if (!cm_node->reused_node) {
 		if (nes_create_mapinfo(&cm_info))
diff --git a/drivers/infiniband/hw/nes/nes_cm.h b/drivers/infiniband/hw/nes/nes_cm.h
index f522cf6..32a6420 100644
--- a/drivers/infiniband/hw/nes/nes_cm.h
+++ b/drivers/infiniband/hw/nes/nes_cm.h
@@ -303,6 +303,7 @@ struct nes_cm_listener {
 	int                        backlog;
 	enum nes_cm_listener_state listener_state;
 	u32                        reused_node;
+	u8			   tos;
 };
 
 /* per connection node and node state information */
@@ -352,6 +353,7 @@ struct nes_cm_node {
 	struct list_head	reset_entry;
 	struct nes_qp		*nesqp;
 	atomic_t 		passive_state;
+	u8			tos;
 };
 
 /* structure for client or CM to fill when making CM api calls. */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
