From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 02/10] IB/mad: Remove ib_get_dma_mr calls
Date: Wed, 22 Jul 2015 17:34:35 -0600
Message-ID: <1437608083-22898-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1437608083-22898-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437608083-22898-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Chien Yen <chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dominique Martinet <dominique.martinet-KCE40YydGKI@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eric Van Hensbergen <ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ido Shamay <idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Latchesar Ionkov <lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ron Minnich <rminnich-4OHPYypu0djtX7QSmKvirg@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Simon Derr <simon.derr-6ktuUTfB/bM@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Zach Brown <zach.brown-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The pd now has a local_dma_lkey member which completely replaces
ib_get_dma_mr, use it instead.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/core/mad.c      | 26 +++-----------------------
 drivers/infiniband/core/mad_priv.h |  1 -
 include/rdma/ib_mad.h              |  1 -
 3 files changed, 3 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index a4b1466c1bf6..3c5fa8dc5ba7 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -338,13 +338,6 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 		goto error1;
 	}
 
-	mad_agent_priv->agent.mr = ib_get_dma_mr(port_priv->qp_info[qpn].qp->pd,
-						 IB_ACCESS_LOCAL_WRITE);
-	if (IS_ERR(mad_agent_priv->agent.mr)) {
-		ret = ERR_PTR(-ENOMEM);
-		goto error2;
-	}
-
 	if (mad_reg_req) {
 		reg_req = kmemdup(mad_reg_req, sizeof *reg_req, GFP_KERNEL);
 		if (!reg_req) {
@@ -429,8 +422,6 @@ error4:
 	spin_unlock_irqrestore(&port_priv->reg_lock, flags);
 	kfree(reg_req);
 error3:
-	ib_dereg_mr(mad_agent_priv->agent.mr);
-error2:
 	kfree(mad_agent_priv);
 error1:
 	return ret;
@@ -590,7 +581,6 @@ static void unregister_mad_agent(struct ib_mad_agent_private *mad_agent_priv)
 	wait_for_completion(&mad_agent_priv->comp);
 
 	kfree(mad_agent_priv->reg_req);
-	ib_dereg_mr(mad_agent_priv->agent.mr);
 	kfree(mad_agent_priv);
 }
 
@@ -1037,7 +1027,7 @@ struct ib_mad_send_buf * ib_create_send_mad(struct ib_mad_agent *mad_agent,
 
 	mad_send_wr->mad_agent_priv = mad_agent_priv;
 	mad_send_wr->sg_list[0].length = hdr_len;
-	mad_send_wr->sg_list[0].lkey = mad_agent->mr->lkey;
+	mad_send_wr->sg_list[0].lkey = mad_agent->qp->pd->local_dma_lkey;
 
 	/* OPA MADs don't have to be the full 2048 bytes */
 	if (opa && base_version == OPA_MGMT_BASE_VERSION &&
@@ -1046,7 +1036,7 @@ struct ib_mad_send_buf * ib_create_send_mad(struct ib_mad_agent *mad_agent,
 	else
 		mad_send_wr->sg_list[1].length = mad_size - hdr_len;
 
-	mad_send_wr->sg_list[1].lkey = mad_agent->mr->lkey;
+	mad_send_wr->sg_list[1].lkey = mad_agent->qp->pd->local_dma_lkey;
 
 	mad_send_wr->send_wr.wr_id = (unsigned long) mad_send_wr;
 	mad_send_wr->send_wr.sg_list = mad_send_wr->sg_list;
@@ -2884,7 +2874,7 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
 	struct ib_mad_queue *recv_queue = &qp_info->recv_queue;
 
 	/* Initialize common scatter list fields */
-	sg_list.lkey = (*qp_info->port_priv->mr).lkey;
+	sg_list.lkey = qp_info->port_priv->pd->local_dma_lkey;
 
 	/* Initialize common receive WR fields */
 	recv_wr.next = NULL;
@@ -3200,13 +3190,6 @@ static int ib_mad_port_open(struct ib_device *device,
 		goto error4;
 	}
 
-	port_priv->mr = ib_get_dma_mr(port_priv->pd, IB_ACCESS_LOCAL_WRITE);
-	if (IS_ERR(port_priv->mr)) {
-		dev_err(&device->dev, "Couldn't get ib_mad DMA MR\n");
-		ret = PTR_ERR(port_priv->mr);
-		goto error5;
-	}
-
 	if (has_smi) {
 		ret = create_mad_qp(&port_priv->qp_info[0], IB_QPT_SMI);
 		if (ret)
@@ -3247,8 +3230,6 @@ error8:
 error7:
 	destroy_mad_qp(&port_priv->qp_info[0]);
 error6:
-	ib_dereg_mr(port_priv->mr);
-error5:
 	ib_dealloc_pd(port_priv->pd);
 error4:
 	ib_destroy_cq(port_priv->cq);
@@ -3283,7 +3264,6 @@ static int ib_mad_port_close(struct ib_device *device, int port_num)
 	destroy_workqueue(port_priv->wq);
 	destroy_mad_qp(&port_priv->qp_info[1]);
 	destroy_mad_qp(&port_priv->qp_info[0]);
-	ib_dereg_mr(port_priv->mr);
 	ib_dealloc_pd(port_priv->pd);
 	ib_destroy_cq(port_priv->cq);
 	cleanup_recv_queue(&port_priv->qp_info[1]);
diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index 5be89f98928f..4a4f7aad0978 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -199,7 +199,6 @@ struct ib_mad_port_private {
 	int port_num;
 	struct ib_cq *cq;
 	struct ib_pd *pd;
-	struct ib_mr *mr;
 
 	spinlock_t reg_lock;
 	struct ib_mad_mgmt_version_table version[MAX_MGMT_VERSION];
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index c8422d5a5a91..1f27023c919a 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -388,7 +388,6 @@ enum {
 struct ib_mad_agent {
 	struct ib_device	*device;
 	struct ib_qp		*qp;
-	struct ib_mr		*mr;
 	ib_mad_recv_handler	recv_handler;
 	ib_mad_send_handler	send_handler;
 	ib_mad_snoop_handler	snoop_handler;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
