From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: [PATCH v2 02/12] IB/mad: Remove ib_get_dma_mr calls
Date: Thu, 30 Jul 2015 17:22:16 -0600
Message-ID: <1438298547-21404-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
Sender: target-devel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
Cc: Amir Vadai <amirv@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Chien Yen <chien.yen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Dominique Martinet <dominique.martinet@cea.fr>, Eli Cohen <eli@mellanox.com>, Eric Van Hensbergen <ericvh@gmail.com>, Ido Shamay <idos@mellanox.com>, Latchesar Ionkov <lucho@ionkov.net>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Ron Minnich <rminnich@sandia.gov>, Sagi Grimberg <sagig@mellanox.com>, Simon Derr <simon.derr@bull.net>, Tom Tucker <tom@opengridcomputing.com>, rds-devel@oss.oracle.com, target-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
List-Id: linux-rdma@vger.kernel.org

The pd now has a local_dma_lkey member which completely replaces
ib_get_dma_mr, use it instead.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/infiniband/core/mad.c      | 26 +++-----------------------
 drivers/infiniband/core/mad_priv.h |  1 -
 include/rdma/ib_mad.h              |  1 -
 3 files changed, 3 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 786fc51bf04b..7c728a2d1d56 100644
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
 
@@ -1038,7 +1028,7 @@ struct ib_mad_send_buf * ib_create_send_mad(struct ib_mad_agent *mad_agent,
 
 	mad_send_wr->mad_agent_priv = mad_agent_priv;
 	mad_send_wr->sg_list[0].length = hdr_len;
-	mad_send_wr->sg_list[0].lkey = mad_agent->mr->lkey;
+	mad_send_wr->sg_list[0].lkey = mad_agent->qp->pd->local_dma_lkey;
 
 	/* OPA MADs don't have to be the full 2048 bytes */
 	if (opa && base_version == OPA_MGMT_BASE_VERSION &&
@@ -1047,7 +1037,7 @@ struct ib_mad_send_buf * ib_create_send_mad(struct ib_mad_agent *mad_agent,
 	else
 		mad_send_wr->sg_list[1].length = mad_size - hdr_len;
 
-	mad_send_wr->sg_list[1].lkey = mad_agent->mr->lkey;
+	mad_send_wr->sg_list[1].lkey = mad_agent->qp->pd->local_dma_lkey;
 
 	mad_send_wr->send_wr.wr_id = (unsigned long) mad_send_wr;
 	mad_send_wr->send_wr.sg_list = mad_send_wr->sg_list;
@@ -2885,7 +2875,7 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
 	struct ib_mad_queue *recv_queue = &qp_info->recv_queue;
 
 	/* Initialize common scatter list fields */
-	sg_list.lkey = (*qp_info->port_priv->mr).lkey;
+	sg_list.lkey = qp_info->port_priv->pd->local_dma_lkey;
 
 	/* Initialize common receive WR fields */
 	recv_wr.next = NULL;
@@ -3201,13 +3191,6 @@ static int ib_mad_port_open(struct ib_device *device,
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
@@ -3248,8 +3231,6 @@ error8:
 error7:
 	destroy_mad_qp(&port_priv->qp_info[0]);
 error6:
-	ib_dereg_mr(port_priv->mr);
-error5:
 	ib_dealloc_pd(port_priv->pd);
 error4:
 	ib_destroy_cq(port_priv->cq);
@@ -3284,7 +3265,6 @@ static int ib_mad_port_close(struct ib_device *device, int port_num)
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
