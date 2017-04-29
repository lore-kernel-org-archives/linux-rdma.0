From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 rdma-next 10/18] IB/core: Rename ib_destroy_ah to rdma_destroy_ah
Date: Sat, 29 Apr 2017 14:41:22 -0400
Message-ID: <1493491290-31621-11-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Rename ib_destroy_ah to rdma_destroy_ah so its in sync with the
rename of the ib address handle attribute

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/agent.c                 |  4 ++--
 drivers/infiniband/core/cm.c                    |  6 +++---
 drivers/infiniband/core/mad_rmpp.c              | 10 +++++-----
 drivers/infiniband/core/sa_query.c              |  2 +-
 drivers/infiniband/core/user_mad.c              |  4 ++--
 drivers/infiniband/core/uverbs_cmd.c            |  2 +-
 drivers/infiniband/core/uverbs_std_types.c      |  2 +-
 drivers/infiniband/core/verbs.c                 |  4 ++--
 drivers/infiniband/hw/mlx4/mad.c                | 24 ++++++++++++------------
 drivers/infiniband/hw/mthca/mthca_mad.c         |  4 ++--
 drivers/infiniband/hw/qib/qib_mad.c             |  2 +-
 drivers/infiniband/sw/rdmavt/mad.c              |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c         |  2 +-
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c |  6 +++---
 drivers/infiniband/ulp/srpt/ib_srpt.c           |  4 ++--
 include/rdma/ib_verbs.h                         |  4 ++--
 16 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/drivers/infiniband/core/agent.c b/drivers/infiniband/core/agent.c
index 11dacd9..324ef85 100644
--- a/drivers/infiniband/core/agent.c
+++ b/drivers/infiniband/core/agent.c
@@ -137,13 +137,13 @@ void agent_send_response(const struct ib_mad_hdr *mad_hdr, const struct ib_grh *
 err2:
 	ib_free_send_mad(send_buf);
 err1:
-	ib_destroy_ah(ah);
+	rdma_destroy_ah(ah);
 }
 
 static void agent_send_handler(struct ib_mad_agent *mad_agent,
 			       struct ib_mad_send_wc *mad_send_wc)
 {
-	ib_destroy_ah(mad_send_wc->send_buf->ah);
+	rdma_destroy_ah(mad_send_wc->send_buf->ah);
 	ib_free_send_mad(mad_send_wc->send_buf);
 }
 
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index ac62dd8..7d4db26 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -355,7 +355,7 @@ static int cm_alloc_msg(struct cm_id_private *cm_id_priv,
 			       GFP_ATOMIC,
 			       IB_MGMT_BASE_VERSION);
 	if (IS_ERR(m)) {
-		ib_destroy_ah(ah);
+		rdma_destroy_ah(ah);
 		ret = PTR_ERR(m);
 		goto out;
 	}
@@ -390,7 +390,7 @@ static int cm_alloc_response_msg(struct cm_port *port,
 			       GFP_ATOMIC,
 			       IB_MGMT_BASE_VERSION);
 	if (IS_ERR(m)) {
-		ib_destroy_ah(ah);
+		rdma_destroy_ah(ah);
 		return PTR_ERR(m);
 	}
 	m->ah = ah;
@@ -400,7 +400,7 @@ static int cm_alloc_response_msg(struct cm_port *port,
 
 static void cm_free_msg(struct ib_mad_send_buf *msg)
 {
-	ib_destroy_ah(msg->ah);
+	rdma_destroy_ah(msg->ah);
 	if (msg->context[0])
 		cm_deref_id(msg->context[0]);
 	ib_free_send_mad(msg);
diff --git a/drivers/infiniband/core/mad_rmpp.c b/drivers/infiniband/core/mad_rmpp.c
index 0e597c8..a64f820 100644
--- a/drivers/infiniband/core/mad_rmpp.c
+++ b/drivers/infiniband/core/mad_rmpp.c
@@ -81,7 +81,7 @@ static void destroy_rmpp_recv(struct mad_rmpp_recv *rmpp_recv)
 {
 	deref_rmpp_recv(rmpp_recv);
 	wait_for_completion(&rmpp_recv->comp);
-	ib_destroy_ah(rmpp_recv->ah);
+	rdma_destroy_ah(rmpp_recv->ah);
 	kfree(rmpp_recv);
 }
 
@@ -171,7 +171,7 @@ static struct ib_mad_send_buf *alloc_response_msg(struct ib_mad_agent *agent,
 				 hdr_len, 0, GFP_KERNEL,
 				 IB_MGMT_BASE_VERSION);
 	if (IS_ERR(msg))
-		ib_destroy_ah(ah);
+		rdma_destroy_ah(ah);
 	else {
 		msg->ah = ah;
 		msg->context[0] = ah;
@@ -201,7 +201,7 @@ static void ack_ds_ack(struct ib_mad_agent_private *agent,
 
 	ret = ib_post_send_mad(msg, NULL);
 	if (ret) {
-		ib_destroy_ah(msg->ah);
+		rdma_destroy_ah(msg->ah);
 		ib_free_send_mad(msg);
 	}
 }
@@ -209,7 +209,7 @@ static void ack_ds_ack(struct ib_mad_agent_private *agent,
 void ib_rmpp_send_handler(struct ib_mad_send_wc *mad_send_wc)
 {
 	if (mad_send_wc->send_buf->context[0] == mad_send_wc->send_buf->ah)
-		ib_destroy_ah(mad_send_wc->send_buf->ah);
+		rdma_destroy_ah(mad_send_wc->send_buf->ah);
 	ib_free_send_mad(mad_send_wc->send_buf);
 }
 
@@ -237,7 +237,7 @@ static void nack_recv(struct ib_mad_agent_private *agent,
 
 	ret = ib_post_send_mad(msg, NULL);
 	if (ret) {
-		ib_destroy_ah(msg->ah);
+		rdma_destroy_ah(msg->ah);
 		ib_free_send_mad(msg);
 	}
 }
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index e998d6b..9c11f90 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1027,7 +1027,7 @@ static void free_sm_ah(struct kref *kref)
 {
 	struct ib_sa_sm_ah *sm_ah = container_of(kref, struct ib_sa_sm_ah, ref);
 
-	ib_destroy_ah(sm_ah->ah);
+	rdma_destroy_ah(sm_ah->ah);
 	kfree(sm_ah);
 }
 
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 3ac6f97..c699a7d 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -197,7 +197,7 @@ static void send_handler(struct ib_mad_agent *agent,
 	struct ib_umad_packet *packet = send_wc->send_buf->context[0];
 
 	dequeue_send(file, packet);
-	ib_destroy_ah(packet->msg->ah);
+	rdma_destroy_ah(packet->msg->ah);
 	ib_free_send_mad(packet->msg);
 
 	if (send_wc->status == IB_WC_RESP_TIMEOUT_ERR) {
@@ -596,7 +596,7 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 err_msg:
 	ib_free_send_mad(packet->msg);
 err_ah:
-	ib_destroy_ah(ah);
+	rdma_destroy_ah(ah);
 err_up:
 	mutex_unlock(&file->mutex);
 err:
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 6e9bdcd..bfdd3d8 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2588,7 +2588,7 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	return in_len;
 
 err_copy:
-	ib_destroy_ah(ah);
+	rdma_destroy_ah(ah);
 
 err_put:
 	uobj_put_obj_read(pd);
diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index ad3caad..ef29337 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -41,7 +41,7 @@
 static int uverbs_free_ah(struct ib_uobject *uobject,
 			  enum rdma_remove_reason why)
 {
-	return ib_destroy_ah((struct ib_ah *)uobject->object);
+	return rdma_destroy_ah((struct ib_ah *)uobject->object);
 }
 
 static int uverbs_free_flow(struct ib_uobject *uobject,
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 35efff6..a517a46 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -587,7 +587,7 @@ int rdma_query_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr)
 }
 EXPORT_SYMBOL(rdma_query_ah);
 
-int ib_destroy_ah(struct ib_ah *ah)
+int rdma_destroy_ah(struct ib_ah *ah)
 {
 	struct ib_pd *pd;
 	int ret;
@@ -599,7 +599,7 @@ int ib_destroy_ah(struct ib_ah *ah)
 
 	return ret;
 }
-EXPORT_SYMBOL(ib_destroy_ah);
+EXPORT_SYMBOL(rdma_destroy_ah);
 
 /* Shared receive queues */
 
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 76010d0..90915c5 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -207,7 +207,7 @@ static void update_sm_ah(struct mlx4_ib_dev *dev, u8 port_num, u16 lid, u8 sl)
 
 	spin_lock_irqsave(&dev->sm_lock, flags);
 	if (dev->sm_ah[port_num - 1])
-		ib_destroy_ah(dev->sm_ah[port_num - 1]);
+		rdma_destroy_ah(dev->sm_ah[port_num - 1]);
 	dev->sm_ah[port_num - 1] = new_ah;
 	spin_unlock_irqrestore(&dev->sm_lock, flags);
 }
@@ -580,7 +580,7 @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
 
 	tun_mad = (struct mlx4_rcv_tunnel_mad *) (tun_qp->tx_ring[tun_tx_ix].buf.addr);
 	if (tun_qp->tx_ring[tun_tx_ix].ah)
-		ib_destroy_ah(tun_qp->tx_ring[tun_tx_ix].ah);
+		rdma_destroy_ah(tun_qp->tx_ring[tun_tx_ix].ah);
 	tun_qp->tx_ring[tun_tx_ix].ah = ah;
 	ib_dma_sync_single_for_cpu(&dev->ib_dev,
 				   tun_qp->tx_ring[tun_tx_ix].buf.map,
@@ -653,7 +653,7 @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
 	spin_unlock(&tun_qp->tx_lock);
 	tun_qp->tx_ring[tun_tx_ix].ah = NULL;
 end:
-	ib_destroy_ah(ah);
+	rdma_destroy_ah(ah);
 	return ret;
 }
 
@@ -1018,7 +1018,7 @@ static void send_handler(struct ib_mad_agent *agent,
 			 struct ib_mad_send_wc *mad_send_wc)
 {
 	if (mad_send_wc->send_buf->context[0])
-		ib_destroy_ah(mad_send_wc->send_buf->context[0]);
+		rdma_destroy_ah(mad_send_wc->send_buf->context[0]);
 	ib_free_send_mad(mad_send_wc->send_buf);
 }
 
@@ -1073,7 +1073,7 @@ void mlx4_ib_mad_cleanup(struct mlx4_ib_dev *dev)
 		}
 
 		if (dev->sm_ah[p])
-			ib_destroy_ah(dev->sm_ah[p]);
+			rdma_destroy_ah(dev->sm_ah[p]);
 	}
 }
 
@@ -1410,7 +1410,7 @@ int mlx4_ib_send_to_wire(struct mlx4_ib_dev *dev, int slave, u8 port,
 
 	sqp_mad = (struct mlx4_mad_snd_buf *) (sqp->tx_ring[wire_tx_ix].buf.addr);
 	if (sqp->tx_ring[wire_tx_ix].ah)
-		ib_destroy_ah(sqp->tx_ring[wire_tx_ix].ah);
+		rdma_destroy_ah(sqp->tx_ring[wire_tx_ix].ah);
 	sqp->tx_ring[wire_tx_ix].ah = ah;
 	ib_dma_sync_single_for_cpu(&dev->ib_dev,
 				   sqp->tx_ring[wire_tx_ix].buf.map,
@@ -1455,7 +1455,7 @@ int mlx4_ib_send_to_wire(struct mlx4_ib_dev *dev, int slave, u8 port,
 	spin_unlock(&sqp->tx_lock);
 	sqp->tx_ring[wire_tx_ix].ah = NULL;
 out:
-	ib_destroy_ah(ah);
+	rdma_destroy_ah(ah);
 	return ret;
 }
 
@@ -1714,7 +1714,7 @@ static void mlx4_ib_free_pv_qp_bufs(struct mlx4_ib_demux_pv_ctx *ctx,
 				    tx_buf_size, DMA_TO_DEVICE);
 		kfree(tun_qp->tx_ring[i].buf.addr);
 		if (tun_qp->tx_ring[i].ah)
-			ib_destroy_ah(tun_qp->tx_ring[i].ah);
+			rdma_destroy_ah(tun_qp->tx_ring[i].ah);
 	}
 	kfree(tun_qp->tx_ring);
 	kfree(tun_qp->ring);
@@ -1746,7 +1746,7 @@ static void mlx4_ib_tunnel_comp_worker(struct work_struct *work)
 				pr_debug("received tunnel send completion:"
 					 "wrid=0x%llx, status=0x%x\n",
 					 wc.wr_id, wc.status);
-				ib_destroy_ah(tun_qp->tx_ring[wc.wr_id &
+				rdma_destroy_ah(tun_qp->tx_ring[wc.wr_id &
 					      (MLX4_NUM_TUNNEL_BUFS - 1)].ah);
 				tun_qp->tx_ring[wc.wr_id & (MLX4_NUM_TUNNEL_BUFS - 1)].ah
 					= NULL;
@@ -1763,7 +1763,7 @@ static void mlx4_ib_tunnel_comp_worker(struct work_struct *work)
 				 " status = %d, wrid = 0x%llx\n",
 				 ctx->slave, wc.status, wc.wr_id);
 			if (!MLX4_TUN_IS_RECV(wc.wr_id)) {
-				ib_destroy_ah(tun_qp->tx_ring[wc.wr_id &
+				rdma_destroy_ah(tun_qp->tx_ring[wc.wr_id &
 					      (MLX4_NUM_TUNNEL_BUFS - 1)].ah);
 				tun_qp->tx_ring[wc.wr_id & (MLX4_NUM_TUNNEL_BUFS - 1)].ah
 					= NULL;
@@ -1900,7 +1900,7 @@ static void mlx4_ib_sqp_comp_worker(struct work_struct *work)
 		if (wc.status == IB_WC_SUCCESS) {
 			switch (wc.opcode) {
 			case IB_WC_SEND:
-				ib_destroy_ah(sqp->tx_ring[wc.wr_id &
+				rdma_destroy_ah(sqp->tx_ring[wc.wr_id &
 					      (MLX4_NUM_TUNNEL_BUFS - 1)].ah);
 				sqp->tx_ring[wc.wr_id & (MLX4_NUM_TUNNEL_BUFS - 1)].ah
 					= NULL;
@@ -1930,7 +1930,7 @@ static void mlx4_ib_sqp_comp_worker(struct work_struct *work)
 				 " status = %d, wrid = 0x%llx\n",
 				 ctx->slave, wc.status, wc.wr_id);
 			if (!MLX4_TUN_IS_RECV(wc.wr_id)) {
-				ib_destroy_ah(sqp->tx_ring[wc.wr_id &
+				rdma_destroy_ah(sqp->tx_ring[wc.wr_id &
 					      (MLX4_NUM_TUNNEL_BUFS - 1)].ah);
 				sqp->tx_ring[wc.wr_id & (MLX4_NUM_TUNNEL_BUFS - 1)].ah
 					= NULL;
diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infiniband/hw/mthca/mthca_mad.c
index 7f671a2..6f2e448 100644
--- a/drivers/infiniband/hw/mthca/mthca_mad.c
+++ b/drivers/infiniband/hw/mthca/mthca_mad.c
@@ -93,7 +93,7 @@ static void update_sm_ah(struct mthca_dev *dev,
 
 	spin_lock_irqsave(&dev->sm_lock, flags);
 	if (dev->sm_ah[port_num - 1])
-		ib_destroy_ah(dev->sm_ah[port_num - 1]);
+		rdma_destroy_ah(dev->sm_ah[port_num - 1]);
 	dev->sm_ah[port_num - 1] = new_ah;
 	spin_unlock_irqrestore(&dev->sm_lock, flags);
 }
@@ -345,6 +345,6 @@ void mthca_free_agents(struct mthca_dev *dev)
 		}
 
 		if (dev->sm_ah[p])
-			ib_destroy_ah(dev->sm_ah[p]);
+			rdma_destroy_ah(dev->sm_ah[p]);
 	}
 }
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index d2ac298..8593619 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -2500,5 +2500,5 @@ void qib_notify_free_mad_agent(struct rvt_dev_info *rdi, int port_idx)
 		del_timer_sync(&dd->pport[port_idx].cong_stats.timer);
 
 	if (dd->pport[port_idx].ibport_data.smi_ah)
-		ib_destroy_ah(&dd->pport[port_idx].ibport_data.smi_ah->ibah);
+		rdma_destroy_ah(&dd->pport[port_idx].ibport_data.smi_ah->ibah);
 }
diff --git a/drivers/infiniband/sw/rdmavt/mad.c b/drivers/infiniband/sw/rdmavt/mad.c
index bba241f..d6981dc 100644
--- a/drivers/infiniband/sw/rdmavt/mad.c
+++ b/drivers/infiniband/sw/rdmavt/mad.c
@@ -160,7 +160,7 @@ void rvt_free_mad_agents(struct rvt_dev_info *rdi)
 			ib_unregister_mad_agent(agent);
 		}
 		if (rvp->sm_ah) {
-			ib_destroy_ah(&rvp->sm_ah->ibah);
+			rdma_destroy_ah(&rvp->sm_ah->ibah);
 			rvp->sm_ah = NULL;
 		}
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index e0ba6b0..0060b2f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -658,7 +658,7 @@ static void __ipoib_reap_ah(struct net_device *dev)
 	list_for_each_entry_safe(ah, tah, &priv->dead_ahs, list)
 		if ((int) priv->tx_tail - (int) ah->last_send >= 0) {
 			list_del(&ah->list);
-			ib_destroy_ah(ah->ah);
+			rdma_destroy_ah(ah->ah);
 			kfree(ah);
 		}
 
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
index f6c11f6..ad2ecd2 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
@@ -603,7 +603,7 @@ static void vema_set(struct opa_vnic_vema_port *port,
 static void vema_send(struct ib_mad_agent *mad_agent,
 		      struct ib_mad_send_wc *mad_wc)
 {
-	ib_destroy_ah(mad_wc->send_buf->ah);
+	rdma_destroy_ah(mad_wc->send_buf->ah);
 	ib_free_send_mad(mad_wc->send_buf);
 }
 
@@ -677,7 +677,7 @@ static void vema_recv(struct ib_mad_agent *mad_agent,
 	ib_free_send_mad(rsp);
 
 err_rsp:
-	ib_destroy_ah(ah);
+	rdma_destroy_ah(ah);
 free_recv_mad:
 	ib_free_recv_mad(mad_wc);
 }
@@ -842,7 +842,7 @@ void opa_vnic_vema_send_trap(struct opa_vnic_adapter *adapter,
 	}
 
 err_sndbuf:
-	ib_destroy_ah(ah);
+	rdma_destroy_ah(ah);
 err_exit:
 	v_err("Aborting trap\n");
 }
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 7e314c2..7d6c199 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -417,7 +417,7 @@ static void srpt_mgmt_method_get(struct srpt_port *sp, struct ib_mad *rq_mad,
 static void srpt_mad_send_handler(struct ib_mad_agent *mad_agent,
 				  struct ib_mad_send_wc *mad_wc)
 {
-	ib_destroy_ah(mad_wc->send_buf->ah);
+	rdma_destroy_ah(mad_wc->send_buf->ah);
 	ib_free_send_mad(mad_wc->send_buf);
 }
 
@@ -481,7 +481,7 @@ static void srpt_mad_recv_handler(struct ib_mad_agent *mad_agent,
 	ib_free_send_mad(rsp);
 
 err_rsp:
-	ib_destroy_ah(ah);
+	rdma_destroy_ah(ah);
 err:
 	ib_free_recv_mad(mad_wc);
 }
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 16fd940..ecaf9d5 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2796,10 +2796,10 @@ struct ib_ah *ib_create_ah_from_wc(struct ib_pd *pd, const struct ib_wc *wc,
 int rdma_query_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr);
 
 /**
- * ib_destroy_ah - Destroys an address handle.
+ * rdma_destroy_ah - Destroys an address handle.
  * @ah: The address handle to destroy.
  */
-int ib_destroy_ah(struct ib_ah *ah);
+int rdma_destroy_ah(struct ib_ah *ah);
 
 /**
  * ib_create_srq - Creates a SRQ associated with the specified protection
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
